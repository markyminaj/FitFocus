//
//  OnboardingFlowView.swift
//  FitFocus
//
//  Multi-step onboarding flow with page-based navigation
//

import SwiftUI

// MARK: - Onboarding Step Data

struct OnboardingStep: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
}

extension OnboardingStep {
    static let steps: [OnboardingStep] = [
        OnboardingStep(
            id: 0,
            icon: "timer",
            title: "Track Your Sessions",
            description: "Log every training session with detailed information about duration, techniques, and intensity.",
            accentColor: .blue
        ),
        OnboardingStep(
            id: 1,
            icon: "chart.line.uptrend.xyaxis",
            title: "Monitor Progress",
            description: "Visualize your journey with comprehensive stats, charts, and insights about your training.",
            accentColor: .green
        ),
        OnboardingStep(
            id: 2,
            icon: "flame.fill",
            title: "Build Streaks",
            description: "Stay motivated by building training streaks and earning achievements along the way.",
            accentColor: .orange
        ),
        OnboardingStep(
            id: 3,
            icon: "trophy.fill",
            title: "Achieve Your Goals",
            description: "Set goals, track milestones, and celebrate your progress as you level up your BJJ game.",
            accentColor: .purple
        )
    ]
}

// MARK: - Onboarding Flow View

struct OnboardingFlowView: View {
    
    @State var presenter: OnboardingFlowPresenter
    let delegate: OnboardingFlowDelegate
    
    @State private var currentStep = 0
    @State private var isAnimating = false
    
    private let steps = OnboardingStep.steps
    
    var body: some View {
        ZStack {
            // Background gradient
            currentStepColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentStep)
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    
                    Button {
                        presenter.onSkipPressed()
                    } label: {
                        Text("Skip")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Content
                TabView(selection: $currentStep) {
                    ForEach(steps) { step in
                        OnboardingStepView(step: step, isAnimating: $isAnimating)
                            .tag(step.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
                
                // Custom page indicator
                pageIndicator
                    .padding(.bottom, 24)
                
                // Bottom CTA
                ctaButton
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
            }
        }
        .onChange(of: currentStep) { _, _ in
            triggerAnimation()
        }
        .onAppear {
            presenter.onViewAppear(delegate: delegate)
            triggerAnimation()
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
    }
    
    private var currentStepColor: Color {
        steps[safe: currentStep]?.accentColor.opacity(0.7) ?? .blue.opacity(0.7)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(steps) { step in
                Circle()
                    .fill(currentStep == step.id ? .white : .white.opacity(0.3))
                    .frame(width: currentStep == step.id ? 10 : 8, height: currentStep == step.id ? 10 : 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentStep)
            }
        }
    }
    
    private var ctaButton: some View {
        Button {
            if currentStep < steps.count - 1 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    currentStep += 1
                }
                presenter.onNextPressed(step: currentStep)
            } else {
                presenter.onFinishPressed()
            }
        } label: {
            HStack(spacing: 12) {
                Text(currentStep < steps.count - 1 ? "Continue" : "Get Started")
                    .font(.headline)
                
                Image(systemName: currentStep < steps.count - 1 ? "arrow.right" : "checkmark")
                    .font(.headline)
            }
            .foregroundStyle(currentStepColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }
    
    private func triggerAnimation() {
        isAnimating = false
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
            isAnimating = true
        }
    }
}

// MARK: - Onboarding Step View

struct OnboardingStepView: View {
    let step: OnboardingStep
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .blur(radius: 30)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0.5 : 0)
                
                Image(systemName: step.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, options: .repeating.speed(0.5), value: isAnimating)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.7)
            .opacity(isAnimating ? 1 : 0)
            
            // Text content
            VStack(spacing: 16) {
                Text(step.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text(step.description)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
            }
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Presenter and Delegate

struct OnboardingFlowDelegate {
    var eventParameters: [String: Any]? {
        nil
    }
}

@MainActor
protocol OnboardingFlowRouter {
    func switchToCoreModule()
}

protocol OnboardingFlowInteractor: GlobalInteractor {
    func saveOnboardingComplete() async throws
}

@MainActor
@Observable
class OnboardingFlowPresenter {
    private let interactor: OnboardingFlowInteractor
    private let router: OnboardingFlowRouter
    
    init(interactor: OnboardingFlowInteractor, router: OnboardingFlowRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func onViewAppear(delegate: OnboardingFlowDelegate) {
        interactor.trackScreenEvent(event: Event.onAppear(delegate: delegate))
    }
    
    func onViewDisappear(delegate: OnboardingFlowDelegate) {
        interactor.trackEvent(event: Event.onDisappear(delegate: delegate))
    }
    
    func onNextPressed(step: Int) {
        interactor.trackEvent(event: Event.nextPressed(step: step))
    }
    
    func onSkipPressed() {
        interactor.trackEvent(event: Event.skipPressed)
        completeOnboarding()
    }
    
    func onFinishPressed() {
        interactor.trackEvent(event: Event.finishPressed)
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        Task {
            do {
                try await interactor.saveOnboardingComplete()
                router.switchToCoreModule()
            } catch {
                print("Error completing onboarding: \(error)")
            }
        }
    }
    
    enum Event: LoggableEvent {
        case onAppear(delegate: OnboardingFlowDelegate)
        case onDisappear(delegate: OnboardingFlowDelegate)
        case nextPressed(step: Int)
        case skipPressed
        case finishPressed
        
        var eventName: String {
            switch self {
            case .onAppear:         return "OnboardingFlow_Appear"
            case .onDisappear:      return "OnboardingFlow_Disappear"
            case .nextPressed:      return "OnboardingFlow_Next_Pressed"
            case .skipPressed:      return "OnboardingFlow_Skip_Pressed"
            case .finishPressed:    return "OnboardingFlow_Finish_Pressed"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
            case .nextPressed(step: let step):
                return ["step": step]
            default:
                return nil
            }
        }
        
        var type: LogType {
            .analytic
        }
    }
}

// MARK: - Preview

#Preview("Onboarding Flow") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    
    return builder.onboardingFlowView()
}

// MARK: - Builder Extension

extension CoreBuilder {
    func onboardingFlowView(router: AnyRouter? = nil, delegate: OnboardingFlowDelegate = OnboardingFlowDelegate()) -> some View {
        if let router {
            return AnyView(
                OnboardingFlowView(
                    presenter: OnboardingFlowPresenter(
                        interactor: interactor,
                        router: CoreRouter(router: router, builder: self)
                    ),
                    delegate: delegate
                )
            )
        } else {
            return AnyView(
                RouterView { router in
                    OnboardingFlowView(
                        presenter: OnboardingFlowPresenter(
                            interactor: interactor,
                            router: CoreRouter(router: router, builder: self)
                        ),
                        delegate: delegate
                    )
                }
            )
        }
    }
}

// MARK: - Router Conformance

@MainActor
extension CoreRouter: OnboardingFlowRouter {
    // switchToCoreModule() should already be implemented in CoreRouter
}

// MARK: - Utilities

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
