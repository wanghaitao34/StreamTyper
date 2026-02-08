# TypeStream - App Store Review Notes

## App Information
- **Bundle ID**: fun.jbzy.TypeStream
- **Version**: 1.0
- **Build**: 1
- **Price**: Tier 3 ($2.99 USD)
- **Developer**: Qingdao Yiben Zhengjing Education Co., Ltd.
- **Account**: 15092283828@163.com

---

## App Description (English)

### Title
TypeStream - Multi-Slot Clipboard Typer

### Subtitle
Boost productivity with intelligent clipboard management

### Description
TypeStream is a powerful macOS productivity tool that revolutionizes how you work with clipboard content. With multi-slot clipboard management and intelligent auto-typing, you can save hours of repetitive work.

**Key Features:**
✓ Multi-Slot Clipboard Management - Store up to 4 frequently used text snippets
✓ Global Hotkeys - Quick access with Cmd+Shift+Option+1-4
✓ Adjustable Typing Speed - Customize typing speed to match your needs
✓ Smart Newline Handling - Choose how newlines are processed (Ignore, Enter, Shift+Enter)
✓ Drag-to-Reorder - Easily organize your clipboard slots
✓ Bilingual Interface - Supports English and Chinese

**Perfect For:**
• Customer service representatives
• Data entry professionals
• Developers and programmers
• Content writers
• Anyone who frequently copies and pastes

**How It Works:**
1. Copy your frequently used text to clipboard slots
2. Use hotkeys (Cmd+Shift+Option+1-4) to trigger auto-typing
3. Watch as TypeStream types the content naturally
4. Save time and boost your productivity

**Privacy & Security:**
TypeStream requires accessibility permission to simulate keyboard input. All data stays on your device - no internet connection required, no data collection.

### Keywords
clipboard, typing, automation, productivity, hotkey, text, snippets, keyboard, efficiency, tool

### Promotional Text
Save hours of repetitive typing! TypeStream brings intelligent clipboard management and auto-typing to your Mac. Try it today!

---

## App Description (Chinese - 中文)

### Title
TypeStream - 智能剪贴板打字机

### Subtitle  
多槽位剪贴板管理，提升工作效率

### Description
TypeStream 是一款强大的 macOS 生产力工具，彻底改变您使用剪贴板的方式。通过多槽位剪贴板管理和智能自动输入，帮您节省大量重复工作时间。

**核心功能：**
✓ 多槽位剪贴板管理 - 存储最多 4 个常用文本片段
✓ 全局快捷键 - 使用 Cmd+Shift+Option+1-4 快速访问
✓ 可调节输入速度 - 根据需求自定义打字速度
✓ 智能换行处理 - 选择换行处理方式（忽略、回车、Shift+回车）
✓ 拖拽排序 - 轻松整理剪贴板槽位
✓ 双语界面 - 支持中英文切换

**适用场景：**
• 客服人员
• 数据录入工作
• 开发者和程序员
• 内容创作者
• 任何需要频繁复制粘贴的工作

**使用方法：**
1. 将常用文本复制到剪贴板槽位
2. 使用快捷键（Cmd+Shift+Option+1-4）触发自动输入
3. TypeStream 自然地输入内容
4. 节省时间，提升效率

**隐私与安全：**
TypeStream 需要辅助功能权限来模拟键盘输入。所有数据保存在本地设备 - 无需联网，不收集任何数据。

### Keywords
剪贴板,打字,自动化,生产力,快捷键,文本,片段,键盘,效率,工具

### Promotional Text
节省数小时重复打字时间！TypeStream 为您的 Mac 带来智能剪贴板管理和自动输入功能。立即试用！

---

## Review Notes for Apple

### English Version

**App Purpose:**
TypeStream is a productivity tool designed to help users manage multiple clipboard contents and automatically type them using keyboard simulation.

**Accessibility Permission Requirement:**
This app requires accessibility permission to:
1. Simulate keyboard events (typing characters)
2. Detect global hotkey combinations (Cmd+Shift+Option+1-4)
3. Automatically input clipboard content into any application

**Why Accessibility Permission is Essential:**
The core functionality of TypeStream is to simulate typing, which requires accessibility APIs. Without this permission, the app cannot function as designed. Users must explicitly grant this permission in System Settings > Privacy & Security > Accessibility.

**How to Test:**
1. Launch TypeStream
2. Grant accessibility permission when prompted (System Settings > Privacy & Security > Accessibility)
3. Copy some text (e.g., "Hello World")
4. Click on any text input field (e.g., TextEdit, Notes)
5. Press Cmd+Shift+Option+1 to load the clipboard content to Slot 1
6. Press Cmd+Shift+Option+1 again to auto-type the content
7. Observe the text being typed automatically

**Additional Features to Test:**
- Adjust typing speed using the slider
- Change newline handling mode
- Switch between English and Chinese interface
- Test all 4 clipboard slots

**No Server/Network Requirements:**
This app works entirely offline. No data is transmitted to any server.

---

### Chinese Version (中文版本)

**应用用途：**
TypeStream 是一款生产力工具，帮助用户管理多个剪贴板内容并通过键盘模拟自动输入。

**辅助功能权限要求：**
本应用需要辅助功能权限用于：
1. 模拟键盘事件（输入字符）
2. 检测全局快捷键组合（Cmd+Shift+Option+1-4）
3. 自动将剪贴板内容输入到任何应用程序

**为什么辅助功能权限必不可少：**
TypeStream 的核心功能是模拟打字，这需要辅助功能 API。没有此权限，应用无法正常工作。用户必须在"系统设置 > 隐私与安全性 > 辅助功能"中明确授予此权限。

**测试步骤：**
1. 启动 TypeStream
2. 授予辅助功能权限（系统设置 > 隐私与安全性 > 辅助功能）
3. 复制一些文本（例如："你好世界"）
4. 点击任意文本输入框（如文本编辑、备忘录）
5. 按 Cmd+Shift+Option+1 将剪贴板内容加载到槽位 1
6. 再次按 Cmd+Shift+Option+1 自动输入内容
7. 观察文本自动输入

**其他功能测试：**
- 使用滑块调节输入速度
- 更改换行处理模式
- 切换中英文界面
- 测试所有 4 个剪贴板槽位

**无服务器/网络要求：**
本应用完全离线运行。不向任何服务器传输数据。

---

## Technical Details

### System Requirements
- macOS 13.0 or later
- Accessibility permission required

### Permissions Required
- Accessibility (NSAppleEventsUsageDescription)
  - Purpose: Simulate keyboard typing
  - User-facing explanation included in app

### Frameworks Used
- SwiftUI (UI framework)
- ApplicationServices (for accessibility APIs)
- AppKit (for macOS integration)
- Carbon (for global hotkey registration)
- Combine (for reactive programming)

### App Sandbox
- Enabled with required entitlements
- Apple Events automation allowed
- No network access required
- All data stored locally using UserDefaults

### Privacy Compliance
- No data collection
- No analytics
- No third-party SDKs
- All processing happens on-device
- No internet connection required

---

## Contact Information

**Developer Account:** 15092283828@163.com
**Company:** Qingdao Yiben Zhengjing Education Co., Ltd.

If you have any questions during the review process, please contact us through App Store Connect.

---

## Screenshots Requirements

### macOS Screenshots
You need to provide screenshots for:
- **13.3" MacBook Air**: 2560 x 1664 pixels (minimum 3 screenshots)
- **16" MacBook Pro**: 3456 x 2234 pixels (recommended)

### Screenshot Suggestions:
1. Main window showing all 4 clipboard slots with sample content
2. Typing speed control and newline handling options
3. Global hotkey reference and language selection
4. Permission screen (showing the app requesting accessibility)
5. Demo of the app in action (text being typed into another app)

---

## Build Configuration

### Bundle Identifier
Recommended: `fun.jbzy.TypeStream`

### Version
- Version: 1.0
- Build: 1

### Code Signing
- Team: Qingdao Yiben Zhengjing Education Co., Ltd.
- Signing Identity: Apple Distribution
- Provisioning Profile: App Store distribution profile

### Build Settings
- Enable App Sandbox: YES
- Hardened Runtime: YES
- Code Signing: Automatic (with your team)

---

## Submission Checklist

- [ ] Bundle ID configured in Xcode
- [ ] Team set to Qingdao Yiben Zhengjing Education Co., Ltd.
- [ ] Info.plist with privacy descriptions added
- [ ] Entitlements file configured
- [ ] App icon (1024x1024) prepared
- [ ] Screenshots (minimum 3) prepared
- [ ] App description written (English & Chinese)
- [ ] Keywords selected
- [ ] Price set to Tier 3 ($2.99)
- [ ] Review notes prepared
- [ ] Archive created in Xcode
- [ ] App uploaded to App Store Connect
- [ ] All metadata filled in App Store Connect
- [ ] Submitted for review

---

## Post-Submission

### Expected Review Time
- Standard: 1-3 business days
- With accessibility permissions: Potentially 3-7 days

### Common Rejection Reasons to Avoid
✓ Clear explanation of accessibility permission usage (included)
✓ Privacy policy not required (no data collection)
✓ App sandbox enabled (configured)
✓ Valid bundle identifier (set up required)
✓ Proper code signing (configure in Xcode)

### If Rejected
- Check Resolution Center in App Store Connect
- Respond promptly to Apple's questions
- Provide additional screenshots/videos if requested
- Appeal if necessary with detailed explanation

---

Good luck with your submission! 🚀
