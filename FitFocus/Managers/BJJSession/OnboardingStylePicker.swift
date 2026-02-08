//
//  OnboardingStylePicker.swift
//  FitFocus
//
//  A picker view to preview and choose between different onboarding styles
//

import SwiftUI

/// Development tool to preview and compare all onboarding styles
struct OnboardingStylePicker: View {
    
    @State private var selectedStyle: OnboardingStyle = .modernWelcome
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(OnboardingStyle.allCases) { style in
                        Button {
                            selectedStyle = style
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(style.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text(style.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                if selectedStyle == style {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Choose Onboarding Style")
                } footer: {
                    Text("Select a style to see a live preview")
                }
                
                Section {
                    NavigationLink {
                        selectedStyle.view
                    } label: {
                        Label("Preview \(selectedStyle.title)", systemImage: "play.fill")
                    }
                } header: {
                    Text("Preview")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                        
                        ForEach(selectedStyle.features, id: \.self) { feature in
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
                        
                        Text(selectedStyle.bestFor)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Details")
                }
            }
            .navigationTitle("Onboarding Styles")
        }
    }
}

// MARK: - Onboarding Style

enum OnboardingStyle: String, CaseIterable, Identifiable {
    case modernWelcome = "Modern Welcome"
    case pageFlow = "Page Flow"
    case interactive = "Interactive Cards"
    case minimalist = "Minimalist"
    
    var id: String { rawValue }
    
    var title: String {
        rawValue
    }
    
    var description: String {
        switch self {
        case .modernWelcome:
            return "Animated gradient welcome screen with feature highlights"
        case .pageFlow:
            return "Traditional page-based walkthrough with color-coded steps"
        case .interactive:
            return "Swipeable card stack with interactive gestures"
        case .minimalist:
            return "Clean, focused design with progress tracking"
        }
    }
    
    var features: [String] {
        switch self {
        case .modernWelcome:
            return [
                "Animated gradient background",
                "Pulsing SF Symbol icon",
                "Feature list",
                "Sign in option"
            ]
        case .pageFlow:
            return [
                "4-step walkthrough",
                "Color-coded steps",
                "Swipe navigation",
                "Skip button",
                "Custom page indicators"
            ]
        case .interactive:
            return [
                "Card stack effect",
                "Swipe gestures",
                "Drag animations",
                "Feature lists",
                "Dynamic gradients"
            ]
        case .minimalist:
            return [
                "Progress bar",
                "Back navigation",
                "Detailed features",
                "Clean typography",
                "System colors"
            ]
        }
    }
    
    var bestFor: String {
        switch self {
        case .modernWelcome:
            return "Making a strong first impression with vibrant, energetic design"
        case .pageFlow:
            return "Educational onboarding that explains features in detail"
        case .interactive:
            return "Engaging modern apps targeting users who like interactive experiences"
        case .minimalist:
            return "Professional apps or users who prefer simplicity and clarity"
        }
    }
    
    @ViewBuilder
    var view: some View {
        let container = DevPreview.shared.container()
        let builder = CoreBuilder(interactor: CoreInteractor(container: container))
        
        switch self {
        case .modernWelcome:
            builder.modernWelcomeView()
        case .pageFlow:
            builder.onboardingFlowView()
        case .interactive:
            builder.interactiveOnboardingView()
        case .minimalist:
            builder.minimalistOnboardingView()
        }
    }
}

// MARK: - Side by Side Comparison

struct OnboardingSideBySideView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(OnboardingStyle.allCases) { style in
                        VStack(alignment: .leading, spacing: 12) {
                            // Header
                            HStack {
                                Text(style.title)
                                    .font(.title2.bold())
                                Spacer()
                                NavigationLink {
                                    style.view
                                } label: {
                                    Text("View")
                                        .font(.subheadline.weight(.semibold))
                                }
                            }
                            
                            Text(style.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            // Screenshot placeholder (would show actual preview in real app)
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: gradientColors(for: style),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 300)
                                .overlay(
                                    Text("Tap 'View' to preview")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.8))
                                )
                            
                            // Features
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(style.features.prefix(3), id: \.self) { feature in
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                            .font(.caption)
                                        
                                        Text(feature)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Compare Styles")
        }
    }
    
    private func gradientColors(for style: OnboardingStyle) -> [Color] {
        switch style {
        case .modernWelcome:
            return [.blue, .purple, .pink]
        case .pageFlow:
            return [.blue, .green]
        case .interactive:
            return [.purple, .pink]
        case .minimalist:
            return [.gray.opacity(0.3), .gray.opacity(0.1)]
        }
    }
}

// MARK: - Previews

#Preview("Style Picker") {
    OnboardingStylePicker()
}

#Preview("Side by Side") {
    OnboardingSideBySideView()
}

// MARK: - Quick Access for Development

/// Use this in your app's debug menu or during development
struct OnboardingDebugMenu: View {
    var body: some View {
        List {
            Section("Preview Onboarding Styles") {
                NavigationLink("Style Picker") {
                    OnboardingStylePicker()
                }
                
                NavigationLink("Side by Side Comparison") {
                    OnboardingSideBySideView()
                }
            }
            
            Section("Direct Previews") {
                ForEach(OnboardingStyle.allCases) { style in
                    NavigationLink(style.title) {
                        style.view
                    }
                }
            }
        }
        .navigationTitle("Onboarding Debug")
    }
}

#Preview("Debug Menu") {
    NavigationStack {
        OnboardingDebugMenu()
    }
}
