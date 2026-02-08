//
//  StreamTyperApp.swift
//  StreamTyper
//
//  Created by Hector on 9/12/2025.
//  Copyright © 2025 Qingdao Yiben Zhengjing Education Co., Ltd. All rights reserved.
//

import SwiftUI
import ApplicationServices
import Combine

@main
struct StreamTyperApp: App {
    @State private var isTrusted = AXIsProcessTrusted()

    let permissionTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    init() {
        if AXIsProcessTrusted() {
            HotKeyManager.shared.registerHotKey()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isTrusted {
                    ContentView()
                } else {
                    PermissionOnboardingView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                configureWindow()
            }
            .onReceive(permissionTimer) { _ in
                let newStatus = AXIsProcessTrusted()
                if newStatus != isTrusted {
                    isTrusted = newStatus
                    if newStatus {
                        HotKeyManager.shared.registerHotKey()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                let newStatus = AXIsProcessTrusted()
                if newStatus != isTrusted {
                    isTrusted = newStatus
                    if newStatus {
                        HotKeyManager.shared.registerHotKey()
                    }
                }
            }
        }
        .defaultSize(width: 540, height: 720)
        .commands {
            // Remove "New Window" menu item for single-window app
            CommandGroup(replacing: .newItem) { }
        }
    }
    
    private func configureWindow() {
        DispatchQueue.main.async {
            for window in NSApplication.shared.windows {
                window.titlebarAppearsTransparent = true
                window.titleVisibility = .hidden
                // Let macOS handle the window background color based on system appearance
                window.backgroundColor = .windowBackgroundColor
                window.isOpaque = true
            }
        }
    }
}
