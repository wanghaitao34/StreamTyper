//
//  PermissionOnboardingView.swift
//  StreamTyper
//
//  Created by Hector on 2026/2/8.
//  Copyright © 2025 Qingdao Yiben Zhengjing Education Co., Ltd. All rights reserved.
//

import SwiftUI
import ApplicationServices
import Combine

struct PermissionOnboardingView: View {
    @State private var isTrusted = AXIsProcessTrusted()
    @State private var pulse = false
    @State private var appeared = false
    @ObservedObject var manager = LanguageManager.shared

    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // System-adaptive background
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()

            // Main content
            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 50)

                    VStack(spacing: 28) {
                        // App icon
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.12))
                                .frame(width: 100, height: 100)
                                .blur(radius: 20)
                                .scaleEffect(pulse ? 1.08 : 0.95)
                                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: pulse)

                            Image(nsImage: NSApplication.shared.applicationIconImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .offset(y: appeared ? 0 : -20)
                        .opacity(appeared ? 1 : 0)

                        // Title
                        VStack(spacing: 8) {
                            Text(manager.t(.onboardingTitle))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)

                            Text(manager.t(.onboardingSubtitle))
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .offset(y: appeared ? 0 : 15)
                        .opacity(appeared ? 1 : 0)

                        // Steps
                        VStack(spacing: 10) {
                            StepRow(
                                number: 1,
                                icon: "gear",
                                title: manager.t(.onboardingStep1Title),
                                subtitle: manager.t(.onboardingStep1Desc)
                            )
                            StepRow(
                                number: 2,
                                icon: "hand.point.right",
                                title: manager.t(.onboardingStep2Title),
                                subtitle: manager.t(.onboardingStep2Desc)
                            )
                            StepRow(
                                number: 3,
                                icon: "checkmark.shield",
                                title: manager.t(.onboardingStep3Title),
                                subtitle: manager.t(.onboardingStep3Desc)
                            )
                        }
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)

                        // Buttons
                        VStack(spacing: 12) {
                            Button {
                                openAccessibilitySettings()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "lock.open.fill")
                                    Text(manager.t(.onboardingOpenSettings))
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.blue)
                                )
                            }
                            .buttonStyle(.plain)

                            Button {
                                isTrusted = AXIsProcessTrusted()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.clockwise")
                                    Text(manager.t(.onboardingCheckAgain))
                                }
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(nsColor: .controlBackgroundColor))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)

                        // Security note
                        HStack(spacing: 6) {
                            Image(systemName: "lock.shield")
                                .font(.system(size: 11))
                            Text(manager.t(.onboardingPrivacyNote))
                                .font(.system(size: 11))
                        }
                        .foregroundStyle(.tertiary)
                        .offset(y: appeared ? 0 : 10)
                        .opacity(appeared ? 1 : 0)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            pulse = true
            withAnimation(.easeOut(duration: 0.8)) {
                appeared = true
            }
        }
        .onReceive(timer) { _ in
            isTrusted = AXIsProcessTrusted()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            isTrusted = AXIsProcessTrusted()
        }
    }

    private func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
}

// MARK: - Step Row

struct StepRow: View {
    let number: Int
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 38, height: 38)

                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}

#Preview {
    PermissionOnboardingView()
}
