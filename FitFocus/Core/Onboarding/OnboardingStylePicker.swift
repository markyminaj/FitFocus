//
//  OnboardingStylePicker.swift
//  FitFocus
//
//  A preview tool for the OnboardingFlowView
//

import SwiftUI

/// Development tool to preview the onboarding flow
struct OnboardingPreviewTool: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("OnboardingFlowView")
                            .font(.headline)
                        
                        Text("Page-based onboarding with color-coded steps")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Available Onboarding")
                }
                
                Section {
                    NavigationLink {
                        onboardingPreview
                    } label: {
                        Label("Preview Onboarding Flow", systemImage: "play.fill")
                    }
                } header: {
                    Text("Preview")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                        
                        ForEach(features, id: \.self) { feature in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.caption)
                                
                                Text(feature)
                                    .font(.subheadline)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("Best For")
                            .font(.headline)
                        
                        Text("Educational onboarding that explains features in detail")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Details")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Steps Included:")
                            .font(.subheadline.weight(.semibold))
                        
                        ForEach(steps, id: \.title) { step in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(step.color)
                                    .frame(width: 8, height: 8)
                                
                                Text(step.title)
                                    .font(.caption)
                            }
                        }
                    }
                } header: {
                    Text("Content")
                }
            }
            .navigationTitle("Onboarding Preview")
        }
    }
    
    private var features: [String] {
        [
            "4-step walkthrough",
            "Color-coded steps",
            "Swipe navigation",
            "Skip button",
            "Custom page indicators",
            "Smooth animations",
            "Analytics tracking"
        ]
    }
    
    private var steps: [(title: String, color: Color)] {
        [
            ("Track Your Sessions", .blue),
            ("Monitor Progress", .green),
            ("Build Streaks", .orange),
            ("Achieve Your Goals", .purple)
        ]
    }
    
    @MainActor
    private var onboardingPreview: some View {
        let container = DevPreview.shared.container()
        let builder = CoreBuilder(interactor: CoreInteractor(container: container))
        return builder.onboardingFlowView()
    }
}

// MARK: - Previews

#Preview("Onboarding Preview Tool") {
    OnboardingPreviewTool()
}

// MARK: - Quick Access for Development

/// Use this in your app's debug menu or during development
struct OnboardingDebugMenu: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Preview Onboarding") {
                    NavigationLink("Onboarding Preview Tool") {
                        OnboardingPreviewTool()
                    }
                    
                    NavigationLink("Direct Preview") {
                        directPreview
                    }
                }
                
                Section("Integration") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Next Steps:")
                            .font(.headline)
                        
                        Text("1. Add showOnboardingFlow to WelcomeRouter")
                            .font(.caption)
                        
                        Text("2. Implement in CoreRouter")
                            .font(.caption)
                        
                        Text("3. Update WelcomePresenter")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Onboarding Debug")
        }
    }
    
    @MainActor
    private var directPreview: some View {
        let container = DevPreview.shared.container()
        let builder = CoreBuilder(interactor: CoreInteractor(container: container))
        return builder.onboardingFlowView()
    }
}

#Preview("Debug Menu") {
    OnboardingDebugMenu()
}
