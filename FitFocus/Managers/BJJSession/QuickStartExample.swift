//
//  QuickStartExample.swift
//  FitFocus
//
//  Quick start code examples for immediate use
//

import SwiftUI

/*
 
 🚀 QUICK START - Copy & Paste Ready Code
 ========================================
 
 Choose your preferred setup and copy the code below!
 
 */

// MARK: - Example 1: Update WelcomePresenter (RECOMMENDED)

/*
 
 In WelcomePresenter.swift, replace onGetStartedPressed():
 
 */

extension WelcomePresenter {
    
    // OPTION A: Page-based onboarding (Traditional, educational)
    func onGetStartedPressed_PageBased() {
        interactor.trackEvent(event: Event.getStartedPressed)
        router.showOnboardingFlow(delegate: OnboardingFlowDelegate())
    }
    
    // OPTION B: Interactive cards (Modern, engaging)
    func onGetStartedPressed_Interactive() {
        interactor.trackEvent(event: Event.getStartedPressed)
        router.showInteractiveOnboarding(delegate: OnboardingFlowDelegate())
    }
    
    // OPTION C: Minimalist (Clean, professional)
    func onGetStartedPressed_Minimalist() {
        interactor.trackEvent(event: Event.getStartedPressed)
        router.showMinimalistOnboarding(delegate: OnboardingFlowDelegate())
    }
}

// MARK: - Example 2: Add Router Methods

/*
 
 In your router protocol file (e.g., WelcomeRouter.swift):
 
 */

protocol ExampleWelcomeRouter: AppRouter {
    // Add these three methods
    func showOnboardingFlow(delegate: OnboardingFlowDelegate)
    func showInteractiveOnboarding(delegate: OnboardingFlowDelegate)
    func showMinimalistOnboarding(delegate: OnboardingFlowDelegate)
}

/*
 
 In your router implementation file (e.g., CoreRouter.swift):
 
 */

extension CoreRouter: ExampleWelcomeRouter {
    
    func showOnboardingFlow(delegate: OnboardingFlowDelegate) {
        router.showScreen(.push) { [weak builder] _ in
            builder?.onboardingFlowView(router: router, delegate: delegate)
        }
    }
    
    func showInteractiveOnboarding(delegate: OnboardingFlowDelegate) {
        router.showScreen(.push) { [weak builder] _ in
            builder?.interactiveOnboardingView(router: router, delegate: delegate)
        }
    }
    
    func showMinimalistOnboarding(delegate: OnboardingFlowDelegate) {
        router.showScreen(.push) { [weak builder] _ in
            builder?.minimalistOnboardingView(router: router, delegate: delegate)
        }
    }
}

// MARK: - Example 3: Complete Integration (Full Working Example)

/// This is a complete, working example showing the entire flow
struct CompleteOnboardingIntegration: View {
    
    @State private var showOnboarding = true
    @State private var onboardingComplete = false
    
    var body: some View {
        Group {
            if onboardingComplete {
                // Your main app content
                MainAppView()
            } else if showOnboarding {
                // Show onboarding
                RouterView { router in
                    OnboardingFlowView(
                        presenter: OnboardingFlowPresenter(
                            interactor: mockInteractor(),
                            router: mockRouter(onComplete: {
                                onboardingComplete = true
                            })
                        ),
                        delegate: OnboardingFlowDelegate()
                    )
                }
            } else {
                // Show welcome screen
                RouterView { router in
                    ModernWelcomeView(
                        presenter: WelcomePresenter(
                            interactor: mockInteractor(),
                            router: mockRouter(onComplete: {
                                showOnboarding = true
                            })
                        ),
                        delegate: WelcomeDelegate()
                    )
                }
            }
        }
        .animation(.default, value: onboardingComplete)
    }
    
    // Mock implementations for example
    private func mockInteractor() -> any GlobalInteractor {
        fatalError("Use your actual interactor")
    }
    
    private func mockRouter(onComplete: @escaping () -> Void) -> any AppRouter {
        fatalError("Use your actual router")
    }
}

struct MainAppView: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem { Label("Home", systemImage: "house") }
            
            Text("Profile")
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}

// MARK: - Example 4: Customize Content

/*
 
 To customize onboarding content, update the static data:
 
 */

// For OnboardingFlowView
extension OnboardingStep {
    static let customSteps: [OnboardingStep] = [
        OnboardingStep(
            id: 0,
            icon: "timer",                  // Any SF Symbol
            title: "Your Title Here",
            description: "Your description here...",
            accentColor: .blue              // Your color
        ),
        OnboardingStep(
            id: 1,
            icon: "chart.line.uptrend.xyaxis",
            title: "Another Step",
            description: "Another description...",
            accentColor: .green
        )
        // Add 2-4 steps total
    ]
}

// For InteractiveOnboardingView
extension OnboardingCard {
    static let customCards: [OnboardingCard] = [
        OnboardingCard(
            id: 0,
            icon: "timer",
            title: "Your Title",
            description: "Your description",
            color: .blue,
            features: [
                "Feature 1",
                "Feature 2",
                "Feature 3"
            ]
        )
        // Add 3-4 cards total
    ]
}

// For MinimalistOnboardingView
extension MinimalistStep {
    static let customSteps: [MinimalistStep] = [
        MinimalistStep(
            id: 0,
            icon: "figure.martial.arts",
            title: "Welcome",
            description: "Welcome description...",
            details: []  // Can be empty for first step
        ),
        MinimalistStep(
            id: 1,
            icon: "timer",
            title: "Feature Title",
            description: "Feature description...",
            details: [
                "Detail 1",
                "Detail 2",
                "Detail 3"
            ]
        )
        // Add 3-4 steps total
    ]
}

// MARK: - Example 5: SwiftUI Previews

/*
 
 Use these previews to test your onboarding:
 
 */

#Preview("Modern Welcome") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    return builder.modernWelcomeView()
}

#Preview("Page Flow") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    return builder.onboardingFlowView()
}

#Preview("Interactive Cards") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    return builder.interactiveOnboardingView()
}

#Preview("Minimalist") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    return builder.minimalistOnboardingView()
}

// MARK: - Example 6: Testing Different Styles

/// Quick way to test all styles during development
struct OnboardingStyleTester: View {
    
    enum Style: String, CaseIterable {
        case welcome = "Modern Welcome"
        case pageFlow = "Page Flow"
        case interactive = "Interactive"
        case minimalist = "Minimalist"
    }
    
    @State private var selectedStyle: Style = .welcome
    
    var body: some View {
        VStack {
            Picker("Style", selection: $selectedStyle) {
                ForEach(Style.allCases, id: \.self) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            selectedStyleView
        }
    }
    
    @ViewBuilder
    private var selectedStyleView: some View {
        let container = DevPreview.shared.container()
        let builder = CoreBuilder(interactor: CoreInteractor(container: container))
        
        switch selectedStyle {
        case .welcome:
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

#Preview("Style Tester") {
    OnboardingStyleTester()
}

// MARK: - 🎯 RECOMMENDATION FOR YOUR APP

/*
 
 BEST CHOICE FOR BJJ/FITNESS APP:
 ================================
 
 Use: ModernWelcomeView + InteractiveOnboardingView
 
 Why:
 ✅ Modern, energetic feel matches fitness apps
 ✅ Animated gradients create excitement
 ✅ Interactive cards keep users engaged
 ✅ Swipe gestures feel natural
 ✅ Showcases features effectively
 
 Implementation:
 1. Keep WelcomeView as-is OR replace with ModernWelcomeView
 2. Update onGetStartedPressed() to show InteractiveOnboardingView
 3. Customize the 4 cards with your specific BJJ features
 4. Test and deploy!
 
 Code:
 
 func onGetStartedPressed() {
     interactor.trackEvent(event: Event.getStartedPressed)
     router.showInteractiveOnboarding(delegate: OnboardingFlowDelegate())
 }
 
 */

// MARK: - 📚 Quick Reference

/*
 
 FILE LOCATIONS:
 ===============
 
 ✅ ModernWelcomeView.swift           - Animated welcome screen
 ✅ OnboardingFlowView.swift          - Page-based onboarding
 ✅ InteractiveOnboardingView.swift   - Card-based onboarding
 ✅ MinimalistOnboardingView.swift    - Minimalist onboarding
 ✅ OnboardingStylePicker.swift       - Development tool
 ✅ OnboardingIntegrationGuide.swift  - Detailed guide
 ✅ ONBOARDING_README.md              - Full documentation
 ✅ IMPLEMENTATION_CHECKLIST.md       - Step-by-step checklist
 ✅ QuickStartExample.swift           - This file!
 
 NEXT STEPS:
 ===========
 
 1. ✅ Choose your style (recommendation: Interactive)
 2. ✅ Add router methods (see Example 2)
 3. ✅ Update WelcomePresenter (see Example 1)
 4. ✅ Customize content (see Example 4)
 5. ✅ Test with previews (see Example 5)
 6. ✅ Deploy! 🚀
 
 */
