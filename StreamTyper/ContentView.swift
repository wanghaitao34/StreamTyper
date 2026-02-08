//
//  ContentView.swift
//  StreamTyper
//
//  Created by Hector on 9/12/2025.
//

import SwiftUI
import ApplicationServices
import Combine
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isTrusted: Bool = AXIsProcessTrusted()
    @ObservedObject private var typer = Typer.shared
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var clipboardPreview: String = ""
    
    // Timer to check clipboard content periodically
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    // Adaptive colors that follow system light/dark mode
    static let baseBg = Color(nsColor: .windowBackgroundColor)
    static let cardFill = Color(nsColor: .controlBackgroundColor)
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isTrusted: isTrusted)
            
            ScrollView {
                VStack(spacing: 16) {
                    LanguageSection()
                    HotkeysSection()
                    SpeedControlSection(typer: typer)
                    NewlineModeSection(typer: typer)
                    ClipboardSlotsSection(typer: typer)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Self.baseBg)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            isTrusted = AXIsProcessTrusted()
        }
        .onReceive(timer) { _ in
            // Keep timer for potential future use or remove if unused
        }
    }
}

struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(ContentView.cardFill)
            )
    }
}

struct LanguageSection: View {
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        GlassCard {
            HStack {
                Text(manager.t(.language))
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Picker("", selection: $manager.currentLanguage) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.rawValue).tag(lang)
                    }
                }
                .frame(width: 150)
            }
        }
    }
}

struct HeaderView: View {
    let isTrusted: Bool
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        HStack(spacing: 14) {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            
            VStack(alignment: .leading, spacing: 3) {
                Text("StreamTyper")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text(manager.t(.subtitle))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Label(manager.t(.ready), systemImage: "checkmark.circle.fill")
                .foregroundColor(Color.green)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.green.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24)
        .padding(.top, 36)
        .padding(.bottom, 14)
    }
}

struct HotkeysSection: View {
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text(manager.t(.globalHotkeys))
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    KeyView(symbol: "⌘", text: "Cmd")
                    KeyView(symbol: "⇧", text: "Shift")
                    KeyView(symbol: "⌥", text: "Opt")
                    Text("+")
                        .foregroundStyle(.tertiary)
                        .font(.system(size: 16, weight: .medium))
                    KeyView(symbol: "V", text: "Paste")
                }
                
                Text(manager.t(.hotkeyDescription))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct SpeedControlSection: View {
    @ObservedObject var typer: Typer
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Text(manager.t(.typingSpeed))
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text(String(format: "%.0f %@", 1.0 / typer.typingDelay, manager.t(.charsPerSecond)))
                        .font(.monospacedDigit(.callout)())
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(ContentView.baseBg)
                        .clipShape(Capsule())
                }
                
                Slider(value: $typer.typingDelay, in: 0.005...0.2) {
                    Text(manager.t(.speed))
                } minimumValueLabel: {
                    Image(systemName: "hare")
                        .foregroundStyle(.secondary)
                } maximumValueLabel: {
                    Image(systemName: "tortoise")
                        .foregroundStyle(.secondary)
                }
                .tint(.accentColor)
            }
        }
    }
}

struct NewlineModeSection: View {
    @ObservedObject var typer: Typer
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text(manager.t(.newlineHandling))
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker(manager.t(.newlineMode), selection: $typer.newlineMode) {
                    ForEach(NewlineMode.allCases) { mode in
                        Text(mode.localizedName).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .id(manager.currentLanguage)
            }
        }
    }
}

struct ClipboardSlotsSection: View {
    @ObservedObject var typer: Typer
    @ObservedObject var manager = LanguageManager.shared
    @State private var draggedItem: ClipboardSlot?
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Text(manager.t(.clipboardSlots))
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text(manager.t(.dragToReorder))
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                }
                
                ForEach(Array(typer.slots.enumerated()), id: \.element.id) { index, slot in
                    ClipboardSlotRow(index: index, slot: $typer.slots[index], allSlots: $typer.slots, draggedItem: $draggedItem)
                }
            }
        }
    }
}

struct ClipboardSlotRow: View {
    let index: Int
    @Binding var slot: ClipboardSlot
    @Binding var allSlots: [ClipboardSlot]
    @Binding var draggedItem: ClipboardSlot?
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        HStack {
            Text("\(index + 1)")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            TextField(manager.t(.emptySlot), text: $slot.content)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                slot.content = ""
            }) {
                Image(systemName: "xmark.circle")
            }
            .help(manager.t(.clearSlot))
            .buttonStyle(.borderless)
            
            Image(systemName: "line.3.horizontal")
                .foregroundStyle(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(ContentView.baseBg)
        )
        .onDrag {
            self.draggedItem = self.slot
            return NSItemProvider(object: slot.id.uuidString as NSString)
        }
        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: slot, items: $allSlots, draggedItem: $draggedItem))
    }
}

struct PermissionWarningSection: View {
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Text(manager.t(.permissionTitle))
                .font(.headline)
                .foregroundStyle(.red)
            
            Text(manager.t(.permissionDesc))
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button(manager.t(.openSettings)) {
                let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
                NSWorkspace.shared.open(url)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
    }
}

struct KeyView: View {
    let symbol: String
    let text: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 3) {
            Text(symbol)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
            Text(text)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(width: 56, height: 52)
        .background(
            ZStack {
                // Bottom edge (3D depth)
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(colorScheme == .dark
                          ? Color.white.opacity(0.06)
                          : Color.black.opacity(0.12))
                    .offset(y: 2)
                
                // Key face
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(colorScheme == .dark
                          ? Color.white.opacity(0.10)
                          : Color(nsColor: .controlBackgroundColor))
                
                // Top highlight
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                colorScheme == .dark ? Color.white.opacity(0.12) : Color.white.opacity(0.9),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark
                    ? Color.white.opacity(0.15)
                    : Color.black.opacity(0.15),
                    lineWidth: 0.5
                )
        )
        .shadow(
            color: colorScheme == .dark
            ? Color.black.opacity(0.5)
            : Color.black.opacity(0.18),
            radius: 1, y: 2
        )
    }
}

struct DropViewDelegate: DropDelegate {
    let destinationItem: ClipboardSlot
    @Binding var items: [ClipboardSlot]
    @Binding var draggedItem: ClipboardSlot?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else { return }
        if draggedItem.id != destinationItem.id {
            if let from = items.firstIndex(of: draggedItem),
               let to = items.firstIndex(of: destinationItem) {
                withAnimation {
                    items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
