//
//  TypeStreamApp.swift
//  TypeStream
//
//  Created by Hector on 9/12/2025.
//

import SwiftUI

@main
struct TypeStreamApp: App {
    init() {
        HotKeyManager.shared.registerHotKey()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
