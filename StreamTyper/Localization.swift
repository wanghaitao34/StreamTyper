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
    // Onboarding
    case onboardingTitle
    case onboardingSubtitle
    case onboardingStep1Title
    case onboardingStep1Desc
    case onboardingStep2Title
    case onboardingStep2Desc
    case onboardingStep3Title
    case onboardingStep3Desc
    case onboardingOpenSettings
    case onboardingCheckAgain
    case onboardingPrivacyNote
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
            .permissionDesc: "StreamTyper needs permission to simulate keystrokes. Please enable it in System Settings.",
            .openSettings: "Open System Settings",
            .language: "Language",
            .onboardingTitle: "Enable Accessibility",
            .onboardingSubtitle: "StreamTyper needs Accessibility permission to simulate keystrokes. Your data stays local and private.",
            .onboardingStep1Title: "Open System Settings",
            .onboardingStep1Desc: "Click the button below to go directly to the settings page.",
            .onboardingStep2Title: "Find StreamTyper",
            .onboardingStep2Desc: "Locate StreamTyper in the app list and toggle it on.",
            .onboardingStep3Title: "All Set",
            .onboardingStep3Desc: "Return here — the app will detect the permission automatically.",
            .onboardingOpenSettings: "Open System Settings",
            .onboardingCheckAgain: "Check Permission Again",
            .onboardingPrivacyNote: "We only simulate keystrokes. No data is collected or transmitted."
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
            .permissionDesc: "StreamTyper 需要权限来模拟按键。请在系统设置中开启。",
            .openSettings: "打开系统设置",
            .language: "语言",
            .onboardingTitle: "启用辅助功能",
            .onboardingSubtitle: "StreamTyper 需要辅助功能权限来模拟键盘输入。您的数据始终保留在本地，安全私密。",
            .onboardingStep1Title: "打开系统设置",
            .onboardingStep1Desc: "点击下方按钮直接跳转到设置页面。",
            .onboardingStep2Title: "找到 StreamTyper",
            .onboardingStep2Desc: "在应用列表中找到 StreamTyper 并开启权限。",
            .onboardingStep3Title: "大功告成",
            .onboardingStep3Desc: "返回此处，应用会自动检测权限状态。",
            .onboardingOpenSettings: "打开系统设置",
            .onboardingCheckAgain: "重新检查权限",
            .onboardingPrivacyNote: "我们仅模拟键盘输入，不会收集或传输任何数据。"
        ]
    ]
}
