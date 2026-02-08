import Foundation
import ApplicationServices
import AppKit
import Combine

enum NewlineMode: String, CaseIterable, Identifiable {
    case ignore
    case enter
    case shiftEnter
    
    var id: String { self.rawValue }
    
    var localizedName: String {
        switch self {
        case .ignore: return LanguageManager.shared.t(.ignoreNewlines)
        case .enter: return LanguageManager.shared.t(.enter)
        case .shiftEnter: return LanguageManager.shared.t(.shiftEnter)
        }
    }
}

struct ClipboardSlot: Identifiable, Hashable {
    let id = UUID()
    var content: String
}

class Typer: ObservableObject {
    static let shared = Typer()
    
    @Published var typingDelay: Double = 0.03
    @Published var isTyping: Bool = false
    @Published var newlineMode: NewlineMode = .ignore
    @Published var slots: [ClipboardSlot] = [
        ClipboardSlot(content: ""),
        ClipboardSlot(content: ""),
        ClipboardSlot(content: ""),
        ClipboardSlot(content: "")
    ]
    
    private var monitor: Any?
    private var mouseMonitor: Any?
    private var _shouldStop = false
    private let lock = NSLock()
    
    private var shouldStop: Bool {
        get { lock.lock(); defer { lock.unlock() }; return _shouldStop }
        set { lock.lock(); defer { lock.unlock() }; _shouldStop = newValue }
    }
    
    private init() {}
    
    func typeSlot(index: Int) {
        guard index >= 0 && index < slots.count else { return }
        let content = slots[index].content
        
        if content.isEmpty {
            print("Slot \(index + 1) is empty")
            return
        }
        
        typeText(content)
    }
    
    func typeClipboardContent() {
        guard let string = NSPasteboard.general.string(forType: .string) else {
            print("No text in clipboard")
            return
        }
        typeText(string)
    }
    
    private func typeText(_ string: String) {
        // Reset state
        self.shouldStop = false
        DispatchQueue.main.async { self.isTyping = true }
        
        // Start monitoring for cancellation events
        startMonitoring()
        
        // Capture the current delay setting
        let currentDelay = self.typingDelay
        
        // Run in background to not block the main thread and allow UI updates if needed
        DispatchQueue.global(qos: .userInteractive).async {
            // Wait a bit for the user to release the hotkeys (Cmd+Shift+Option)
            // This prevents the first character from being interpreted with modifiers
            Thread.sleep(forTimeInterval: 0.5)
            
            if self.shouldStop {
                self.cleanup()
                return
            }
            
            self.typeString(string, delay: currentDelay)
            
            self.cleanup()
        }
    }
    
    private func cleanup() {
        DispatchQueue.main.async {
            self.stopMonitoring()
            self.isTyping = false
        }
    }
    
    private func startMonitoring() {
        DispatchQueue.main.async {
            // Monitor Esc key
            self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
                if event.keyCode == 53 { // Esc
                    print("Esc pressed, stopping")
                    self?.shouldStop = true
                }
            }
            
            // Monitor Mouse Clicks (implies focus loss or user intervention)
            self.mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
                print("Mouse clicked, stopping")
                self?.shouldStop = true
            }
        }
    }
    
    private func stopMonitoring() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
        if let mouseMonitor = mouseMonitor {
            NSEvent.removeMonitor(mouseMonitor)
            self.mouseMonitor = nil
        }
    }
    
    private func typeString(_ string: String, delay: Double) {
        let source = CGEventSource(stateID: .hidSystemState)
        
        for char in string {
            if shouldStop { break }
            
            if char == "\n" || char == "\r" {
                switch self.newlineMode {
                case .ignore:
                    continue
                case .enter:
                    // Virtual key 0x24 is Return
                    guard let enterDown = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: true),
                          let enterUp = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: false) else {
                        continue
                    }
                    enterDown.flags = []
                    enterUp.flags = []
                    
                    enterDown.post(tap: .cghidEventTap)
                    Thread.sleep(forTimeInterval: 0.005)
                    enterUp.post(tap: .cghidEventTap)
                    Thread.sleep(forTimeInterval: delay)
                    
                case .shiftEnter:
                    // Virtual key 0x24 is Return
                    guard let enterDown = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: true),
                          let enterUp = CGEvent(keyboardEventSource: source, virtualKey: 0x24, keyDown: false) else {
                        continue
                    }
                    
                    // Set Shift flag
                    enterDown.flags = .maskShift
                    enterUp.flags = .maskShift
                    
                    enterDown.post(tap: .cghidEventTap)
                    Thread.sleep(forTimeInterval: 0.005)
                    enterUp.post(tap: .cghidEventTap)
                    Thread.sleep(forTimeInterval: delay)
                }
                continue
            }
            
            // Create a blank keyboard event
            // Virtual key 0 is 'a', but we will override the unicode string anyway
            guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true),
                  let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) else {
                continue
            }
            
            // Explicitly clear flags to avoid modifier interference (like Cmd/Shift still being held)
            keyDown.flags = []
            keyUp.flags = []
            
            // Set the character to type
            let str = String(char)
            var utf16Chars = Array(str.utf16)
            
            keyDown.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: &utf16Chars)
            keyUp.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: &utf16Chars)
            
            // Post the events
            keyDown.post(tap: .cghidEventTap)
            
            // Small delay between down and up can help some apps register it
            Thread.sleep(forTimeInterval: 0.005)
            
            keyUp.post(tap: .cghidEventTap)
            
            // Delay between characters to simulate typing
            Thread.sleep(forTimeInterval: delay)
        }
    }
}
