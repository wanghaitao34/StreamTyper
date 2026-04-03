# StreamTyper

[English](README.md) | [中文](README_zh-CN.md)

**A macOS utility that simulates keyboard input to type text from your clipboard — bypassing paste restrictions.**

<p align="center">
  <img src="docs/1.jpg" alt="StreamTyper" width="600">
</p>

## Features

- **Simulated Typing** — Types text character by character via keyboard event simulation, bypassing apps that block `Cmd+V` paste
- **Speed Control** — Adjustable typing speed from ~5 to ~200 characters per second
- **Clipboard Slots** — 4 independent slots to store and manage frequently used text snippets, with drag-to-reorder
- **Newline Modes** — Three options: ignore newlines, send Enter, or send Shift+Enter (for chat apps / rich text editors)
- **Global Hotkeys** — Trigger typing from any app without switching windows:
  - `Cmd + Shift + Option + V` — Type current clipboard
  - `Cmd + Shift + Option + 1–4` — Type from slot 1–4
- **Bilingual UI** — English and Simplified Chinese interface
- **Cancellation** — Press `Esc` or click the mouse to stop typing instantly

## Requirements

- macOS 11.0 (Big Sur) or later
- Xcode 15+ (to build from source)
- Accessibility permission (required for simulating key presses)

## Installation

### Download

Download the latest DMG from the [Releases](https://github.com/wanghaitao34/StreamTyper/releases/latest) page. Open the DMG and drag StreamTyper to your Applications folder.

The app is signed and notarized by Apple — no Gatekeeper warnings.

### Build from Source

```bash
git clone https://github.com/wanghaitao34/StreamTyper.git
cd StreamTyper
open StreamTyper.xcodeproj
```

Build and run in Xcode (`Cmd + R`).

On first launch, the app will prompt you to grant Accessibility permission in **System Settings > Privacy & Security > Accessibility**.

## Usage

1. Launch StreamTyper and grant Accessibility permission when prompted.
2. Copy text to your clipboard, or enter text into one of the 4 clipboard slots.
3. Switch to the target application where you want to type.
4. Press the hotkey:
   - `Cmd + Shift + Option + V` to type clipboard contents
   - `Cmd + Shift + Option + 1` through `4` to type from a slot
5. StreamTyper will simulate keyboard input character by character.
6. Press `Esc` or click the mouse at any time to stop.

### Settings

- **Typing Speed** — Use the slider to adjust how fast characters are typed. Slower speeds may be needed for apps with input lag.
- **Newline Mode** — Choose how newlines in your text are handled:
  - *Ignore* — Newlines are skipped
  - *Enter* — Newlines send a Return key press
  - *Shift+Enter* — Newlines send Shift+Return (useful for Slack, Discord, etc.)

## How It Works

StreamTyper uses macOS `CGEvent` APIs to post Unicode keyboard events directly to the system's HID event tap. Each character is sent as a key-down/key-up pair with the Unicode string attached, bypassing virtual key code mapping entirely. This allows it to type any Unicode character regardless of the active keyboard layout.

Global hotkeys are registered via the Carbon `RegisterEventHotKey` API to capture key combinations system-wide.

## Contributing

Contributions are welcome! Feel free to:

- Open an [issue](https://github.com/wanghaitao34/StreamTyper/issues) to report bugs or request features
- Submit a [pull request](https://github.com/wanghaitao34/StreamTyper/pulls) with improvements

## License

Copyright 2025 Qingdao Yiben Zhengjing Education Co., Ltd.

Licensed under the [Apache License, Version 2.0](LICENSE). See the [LICENSE](LICENSE) file for details.
