import Foundation
import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case chinese = "中文"
    
    var id: String { self.rawValue }
}

enum LocalizedKey {
    case subtitle
    case ready
    case permissionNeeded
    case globalHotkeys
    case hotkeyDescription
    case typingSpeed
    case speed
    case charsPerSecond
    case newlineHandling
    case newlineMode
    case ignoreNewlines
    case enter
    case shiftEnter
    case clipboardSlots
    case dragToReorder
    case emptySlot
    case clearSlot
    case permissionTitle
    case permissionDesc
    case openSettings
    case language
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
        }
    }
    
    init() {
        if let saved = UserDefaults.standard.string(forKey: "AppLanguage"),
           let lang = AppLanguage(rawValue: saved) {
            self.currentLanguage = lang
        } else {
            self.currentLanguage = .english
        }
    }
    
    func t(_ key: LocalizedKey) -> String {
        return translations[currentLanguage]?[key] ?? translations[.english]?[key] ?? ""
    }
    
    private let translations: [AppLanguage: [LocalizedKey: String]] = [
        .english: [
            .subtitle: "Multi-Slot Clipboard Typer",
            .ready: "Ready",
            .permissionNeeded: "Permission Needed",
            .globalHotkeys: "Global Hotkeys",
            .hotkeyDescription: "Cmd + Shift + Option + 1-4 = Slots 1-4",
            .typingSpeed: "Typing Speed",
            .speed: "Speed",
            .charsPerSecond: "chars/s",
            .newlineHandling: "Newline Handling",
            .newlineMode: "Newline Mode",
            .ignoreNewlines: "Ignore",
            .enter: "Enter",
            .shiftEnter: "Shift + Enter",
            .clipboardSlots: "Clipboard Slots",
            .dragToReorder: "Drag to reorder",
            .emptySlot: "Empty Slot",
            .clearSlot: "Clear Slot",
            .permissionTitle: "Accessibility Permission Required",
            .permissionDesc: "TypeStream needs permission to simulate keystrokes. Please enable it in System Settings.",
            .openSettings: "Open System Settings",
            .language: "Language"
        ],
        .chinese: [
            .subtitle: "多槽位剪贴板打字机",
            .ready: "就绪",
            .permissionNeeded: "需要权限",
            .globalHotkeys: "全局热键",
            .hotkeyDescription: "Cmd + Shift + Option + 1-4 = 槽位 1-4",
            .typingSpeed: "打字速度",
            .speed: "速度",
            .charsPerSecond: "字符/秒",
            .newlineHandling: "换行处理",
            .newlineMode: "换行模式",
            .ignoreNewlines: "忽略换行",
            .enter: "回车",
            .shiftEnter: "Shift + 回车",
            .clipboardSlots: "剪贴板槽位",
            .dragToReorder: "拖拽排序",
            .emptySlot: "空槽位",
            .clearSlot: "清空槽位",
            .permissionTitle: "需要辅助功能权限",
            .permissionDesc: "TypeStream 需要权限来模拟按键。请在系统设置中开启。",
            .openSettings: "打开系统设置",
            .language: "语言"
        ]
    ]
}
