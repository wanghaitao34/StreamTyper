# ⚡ 快速变更指南：TypeStream → StreamTyper

---

## 🎯 核心变更

### 应用名称
```
旧: TypeStream
新: StreamTyper ✅
```

### Bundle ID
```
旧: fun.jbzy.TypeStream
新: fun.jbzy.StreamTyper ✅
```

---

## ✅ 在 Xcode 中需要做的 3 件事

### 1. 修改 Bundle ID（2 分钟）
```
打开项目 > General > Identity
Bundle Identifier: 输入 fun.jbzy.StreamTyper
Display Name: 输入 StreamTyper
```

### 2. 更换配置文件（3 分钟）
```
删除：TypeStream.entitlements (如果有)
添加：StreamTyper.entitlements

更新：Info.plist
使用：StreamTyper_Info.plist 的内容
```

### 3. 重命名主文件（5 分钟）
```
文件名：
TypeStreamApp.swift → StreamTyperApp.swift

文件内容：
struct TypeStreamApp → struct StreamTyperApp
```

---

## 📝 完整操作步骤

### Step 1: 重命名项目（可选但推荐）

```
1. 在 Xcode 项目导航器中，点击项目名称
2. 按 Enter 键进入编辑模式
3. 输入: StreamTyper
4. 按 Enter 确认
5. Xcode 弹出对话框，选择 "Rename" 重命名相关项目
```

### Step 2: 更新 Bundle ID

```
1. 选择 TARGETS > StreamTyper
2. General 选项卡
3. Identity 部分:
   - Display Name: StreamTyper
   - Bundle Identifier: fun.jbzy.StreamTyper
```

### Step 3: 添加新的配置文件

```
1. 右键项目文件夹 > Add Files to "StreamTyper"...
2. 选择 StreamTyper.entitlements
3. 选择 StreamTyper_Info.plist
4. ✓ Copy items if needed
5. 点击 Add
```

### Step 4: 配置 Entitlements

```
1. Build Settings 选项卡
2. 搜索: Code Signing Entitlements
3. 双击值，输入: StreamTyper.entitlements
```

### Step 5: 重命名 Swift 文件

```
1. 在项目导航器中找到 TypeStreamApp.swift
2. 右键 > Rename
3. 改为: StreamTyperApp.swift
4. 打开文件，修改内容:
```

```swift
//  StreamTyperApp.swift
//  StreamTyper

import SwiftUI

@main
struct StreamTyperApp: App {  // ← 改这里
    init() {
        HotKeyManager.shared.registerHotKey()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
```

### Step 6: 更新代码中的应用名称

搜索项目中所有 "TypeStream" 字符串：
```
1. Edit > Find > Find in Project (Cmd+Shift+F)
2. 搜索: "TypeStream"
3. 替换为: "StreamTyper"
4. 检查每个结果，点击 Replace 或 Replace All
```

**注意：** 不要替换文件路径和注释中的历史信息。

### Step 7: 构建测试

```
1. Product > Clean Build Folder (Cmd+Shift+K)
2. Product > Build (Cmd+B)
3. 检查是否有错误
4. 如果有错误，修复后重新构建
```

---

## 🎨 视觉素材更新

### App Icon
- [ ] 如果图标包含 "TypeStream" 文字，需要重新设计为 "StreamTyper"
- [ ] 如果是纯图形图标，可以继续使用

### 截图
- [ ] 重新运行应用截图
- [ ] 确保窗口标题显示 "StreamTyper"
- [ ] 至少需要 3 张截图（2560 x 1664）

### 宣传素材
- [ ] 更新所有提到应用名称的地方

---

## 📋 检查清单

完成后确认：

### Xcode 配置
- [ ] 项目名称: StreamTyper
- [ ] Target 名称: StreamTyper
- [ ] Bundle ID: fun.jbzy.StreamTyper
- [ ] Display Name: StreamTyper
- [ ] Product Name: StreamTyper

### 文件配置
- [ ] StreamTyper.entitlements 已添加并配置
- [ ] Info.plist 已更新（Bundle ID 和 Display Name）
- [ ] StreamTyperApp.swift 文件名和内容已更新

### 代码更新
- [ ] struct StreamTyperApp 已重命名
- [ ] 所有显示的应用名称已更新
- [ ] 隐私说明中的应用名称已更新

### 构建测试
- [ ] Clean Build Folder 完成
- [ ] Build 成功，无错误
- [ ] 应用可以正常运行
- [ ] 应用显示名称正确

### App Store 准备
- [ ] App Icon 准备完毕
- [ ] 截图准备完毕（至少 3 张）
- [ ] 应用描述使用 StreamTyper
- [ ] 关键词已更新

---

## 🌐 App Store Connect 配置

创建 App 时使用以下信息：

```
平台:          macOS
名称:          StreamTyper
主要语言:      简体中文
Bundle ID:     fun.jbzy.StreamTyper
SKU:          STREAMTYPER001
价格:          Tier 3 ($2.99)
类别:          生产力工具
```

---

## ❗ 常见问题

### Q: 必须重命名 Xcode 项目吗？
A: 不是必须的，但强烈推荐。即使项目名称保持 TypeStream，只要 Bundle ID 和 Display Name 是 StreamTyper 就可以上架。

### Q: 我已经构建过 TypeStream，需要删除吗？
A: 建议 Clean Build Folder，然后重新构建。旧的构建产物会被自动覆盖。

### Q: 如果忘记修改某个地方会怎样？
A: 不会影响上架，只是在某些地方可能显示旧名称。但为了专业性，建议全部更新。

### Q: Bundle ID 可以保留 TypeStream 吗？
A: 技术上可以，但强烈不建议。Bundle ID 应该与应用名称一致，方便管理和识别。

### Q: 需要重新设计整个应用吗？
A: 不需要。只需要修改名称和 Bundle ID，功能代码完全不用改。

---

## 🚀 完成后的下一步

1. **Archive（归档）**
   ```
   Product > Archive
   ```

2. **Validate（验证）**
   ```
   Organizer > Validate App
   ```

3. **Upload（上传）**
   ```
   Organizer > Distribute App > App Store Connect
   ```

4. **App Store Connect 配置**
   ```
   按照 Quick_Launch_Guide.md 完成剩余步骤
   ```

---

## 📞 需要帮助？

参考以下文档：
- 📖 NAME_CHANGE_TO_STREAMTYPER.md - 详细变更说明
- 📖 Quick_Launch_Guide.md - 快速上架指南
- 📖 Xcode_Configuration_Guide.md - Xcode 配置详解

---

## ✅ 总结

### 核心变更
```
应用名称: StreamTyper ✅
Bundle ID: fun.jbzy.StreamTyper ✅
```

### 需要修改的地方
1. Xcode 项目配置（Bundle ID、Display Name）
2. 配置文件（entitlements、Info.plist）
3. Swift 文件（TypeStreamApp.swift → StreamTyperApp.swift）
4. 代码字符串（所有显示的应用名称）

### 预计时间
```
10-20 分钟完成所有修改
```

---

**准备好了！开始更名之旅吧！** 🎯

© 2025 Qingdao Yiben Zhengjing Education Co., Ltd.
