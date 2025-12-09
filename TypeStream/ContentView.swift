//
//  ContentView.swift
//  TypeStream
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
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isTrusted: isTrusted)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 24) {
                    LanguageSection()
                    HotkeysSection()
                    SpeedControlSection(typer: typer)
                    NewlineModeSection(typer: typer)
                    ClipboardSlotsSection(typer: typer)
                    
                    if !isTrusted {
                        PermissionWarningSection()
                    }
                }
                .padding()
            }
        }
        .frame(width: 450, height: 650)
        .background(Color(NSColor.windowBackgroundColor))
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            isTrusted = AXIsProcessTrusted()
        }
        .onReceive(timer) { _ in
            // Keep timer for potential future use or remove if unused
        }
    }
}

struct LanguageSection: View {
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        HStack {
            Text(manager.t(.language))
                .font(.headline)
            Spacer()
            Picker("", selection: $manager.currentLanguage) {
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.rawValue).tag(lang)
                }
            }
            .frame(width: 150)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct HeaderView: View {
    let isTrusted: Bool
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        HStack {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading) {
                Text("TypeStream")
                    .font(.title2)
                    .bold()
                Text(manager.t(.subtitle))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if isTrusted {
                Label(manager.t(.ready), systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
            } else {
                Label(manager.t(.permissionNeeded), systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
    }
}

struct HotkeysSection: View {
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Text(manager.t(.globalHotkeys))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                KeyView(symbol: "⌘", text: "Cmd")
                KeyView(symbol: "⇧", text: "Shift")
                KeyView(symbol: "⌥", text: "Opt")
                Text("+")
                    .foregroundStyle(.secondary)
                KeyView(symbol: "V", text: "Paste")
            }
            
            Text(manager.t(.hotkeyDescription))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct SpeedControlSection: View {
    @ObservedObject var typer: Typer
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(manager.t(.typingSpeed))
                    .font(.headline)
                Spacer()
                Text(String(format: "%.0f %@", 1.0 / typer.typingDelay, manager.t(.charsPerSecond)))
                    .font(.monospacedDigit(.body)())
                    .foregroundStyle(.secondary)
            }
            
            Slider(value: $typer.typingDelay, in: 0.005...0.2) {
                Text(manager.t(.speed))
            } minimumValueLabel: {
                Image(systemName: "hare")
            } maximumValueLabel: {
                Image(systemName: "tortoise")
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct NewlineModeSection: View {
    @ObservedObject var typer: Typer
    @ObservedObject var manager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Text(manager.t(.newlineHandling))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Picker(manager.t(.newlineMode), selection: $typer.newlineMode) {
                ForEach(NewlineMode.allCases) { mode in
                    Text(mode.localizedName).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .id(manager.currentLanguage)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ClipboardSlotsSection: View {
    @ObservedObject var typer: Typer
    @ObservedObject var manager = LanguageManager.shared
    @State private var draggedItem: ClipboardSlot?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(manager.t(.clipboardSlots))
                    .font(.headline)
                Spacer()
                Text(manager.t(.dragToReorder))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ForEach(Array(typer.slots.enumerated()), id: \.element.id) { index, slot in
                ClipboardSlotRow(index: index, slot: $typer.slots[index], allSlots: $typer.slots, draggedItem: $draggedItem)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
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
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
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
    
    var body: some View {
        VStack(spacing: 4) {
            Text(symbol)
                .font(.title2)
            Text(text)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(width: 60, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
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
