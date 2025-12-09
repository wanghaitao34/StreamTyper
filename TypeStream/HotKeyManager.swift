import Foundation
import Carbon
import AppKit

class HotKeyManager {
    static let shared = HotKeyManager()
    
    private var hotKeyRefs: [EventHotKeyRef] = []
    private var eventHandler: EventHandlerRef?
    
    private init() {}
    
    func registerHotKey() {
        // Unregister existing first
        unregisterHotKey()
        
        // Cmd + Shift + Option
        let modifiers = UInt32(cmdKey | shiftKey | optionKey)
        
        // Define keys to register
        // ID 1-4 map to slots 0-3
        // ID 5 maps to 'V', which also triggers slot 0
        let keys: [(id: UInt32, code: Int)] = [
            (1, kVK_ANSI_1),
            (2, kVK_ANSI_2),
            (3, kVK_ANSI_3),
            (4, kVK_ANSI_4),
            (5, kVK_ANSI_V)
        ]
        
        for (id, code) in keys {
            var hotKeyID = EventHotKeyID()
            hotKeyID.signature = OSType(bitPattern: 0x41545950) // 'ATYP'
            hotKeyID.id = id
            
            var ref: EventHotKeyRef?
            let status = RegisterEventHotKey(UInt32(code),
                                             modifiers,
                                             hotKeyID,
                                             GetApplicationEventTarget(),
                                             0,
                                             &ref)
            
            if status == noErr, let ref = ref {
                hotKeyRefs.append(ref)
            } else {
                print("Failed to register hotkey ID \(id): \(status)")
            }
        }
        
        // Install event handler
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                                      eventKind: UInt32(kEventHotKeyPressed))
        
        let handler: EventHandlerUPP = { _, event, _ in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(event,
                              EventParamName(kEventParamDirectObject),
                              EventParamType(typeEventHotKeyID),
                              nil,
                              MemoryLayout<EventHotKeyID>.size,
                              nil,
                              &hotKeyID)
            
            print("Hotkey pressed! ID: \(hotKeyID.id)")
            
            if hotKeyID.id == 5 {
                // 'V' -> Type current clipboard content
                Typer.shared.typeClipboardContent()
            } else if hotKeyID.id >= 1 && hotKeyID.id <= 4 {
                // 1-4 -> Slot 0-3
                Typer.shared.typeSlot(index: Int(hotKeyID.id) - 1)
            }
            
            return noErr
        }
        
        InstallEventHandler(GetApplicationEventTarget(),
                            handler,
                            1,
                            &eventType,
                            nil,
                            &eventHandler)
        
        print("Hotkeys registered successfully")
    }
    
    func unregisterHotKey() {
        for ref in hotKeyRefs {
            UnregisterEventHotKey(ref)
        }
        hotKeyRefs.removeAll()
        
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }
}
