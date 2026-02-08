//
//  MinimalistOnboardingView.swift
//  FitFocus
//
//  A clean, minimalist onboarding experience with subtle animations
//

import SwiftUI

struct MinimalistOnboardingView: View {
    
    @State var presenter: OnboardingFlowPresenter
    let delegate: OnboardingFlowDelegate
    
    @State private var currentStep = 0
    @State private var progress: CGFloat = 0
    
    private let steps = MinimalistStep.steps
    
    var body: some View {
        ZStack {
            // Clean white/black background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top progress bar
                progressBar
                    .padding(.top, 16)
                
                // Content
                TabView(selection: $currentStep) {
                    ForEach(steps) { step in
                        MinimalistStepView(step: step)
                            .tag(step.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom controls
                bottomControls
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
            }
        }
        .onChange(of: currentStep) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                progress = CGFloat(newValue + 1) / CGFloat(steps.count)
            }
        }
        .onAppear {
            presenter.onViewAppear(delegate: delegate)
            progress = 1.0 / CGFloat(steps.count)
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 3)
                
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: geometry.size.width * progress, height: 3)
            }
        }
        .frame(height: 3)
        .padding(.horizontal, 32)
    }
    
    private var bottomControls: some View {
        VStack(spacing: 20) {
            // Navigation dots
            HStack(spacing: 12) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Circle()
                        .fill(currentStep >= index ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(currentStep == index ? Color.accentColor : Color.clear, lineWidth: 2)
                                .frame(width: 16, height: 16)
                        )
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
                }
            }
            
            // Action buttons
            HStack(spacing: 16) {
                if currentStep > 0 {
                    Button {
                        withAnimation {
                            currentStep -= 1
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            )
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Button {
                    if currentStep < steps.count - 1 {
                        withAnimation {
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
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentColor)
                    )
                }
            }
            
            // Skip button
            if currentStep < steps.count - 1 {
                Button {
                    presenter.onSkipPressed()
                } label: {
                    Text("Skip")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .transition(.opacity)
            }
        }
    }
}

// MARK: - Minimalist Step Data

struct MinimalistStep: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let details: [String]
}

extension MinimalistStep {
    static let steps: [MinimalistStep] = [
        MinimalistStep(
            id: 0,
            icon: "figure.martial.arts",
            title: "Welcome to FitFocus",
            description: "Your personal BJJ training companion. Track sessions, monitor progress, and achieve your martial arts goals.",
            details: []
        ),
        MinimalistStep(
            id: 1,
            icon: "clock",
            title: "Track Every Session",
            description: "Log your training with detailed information about duration, intensity, and techniques practiced.",
            details: [
                "Quick session logging",
                "Custom session types",
                "Technique library",
                "Training notes"
            ]
        ),
        MinimalistStep(
            id: 2,
            icon: "chart.xyaxis.line",
            title: "Monitor Your Progress",
            description: "Visualize your improvement with comprehensive statistics and interactive charts.",
            details: [
                "Training frequency",
                "Total mat time",
                "Technique mastery",
                "Performance trends"
            ]
        ),
        MinimalistStep(
            id: 3,
            icon: "target",
            title: "Achieve Your Goals",
            description: "Set goals, build streaks, and earn achievements as you level up your BJJ journey.",
            details: [
                "Goal setting",
                "Streak tracking",
                "Achievement system",
                "Belt progression"
            ]
        )
    ]
}

// MARK: - Minimalist Step View

struct MinimalistStepView: View {
    let step: MinimalistStep
    
    @State private var showContent = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                Spacer()
                    .frame(height: 40)
                
                // Icon
                Image(systemName: step.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.accentColor, .accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(showContent ? 1.0 : 0.8)
                    .opacity(showContent ? 1 : 0)
                
                // Title and description
                VStack(spacing: 16) {
                    Text(step.title)
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text(step.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .lineSpacing(6)
                        .padding(.horizontal, 20)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                
                // Details list
                if !step.details.isEmpty {
                    VStack(spacing: 16) {
                        ForEach(Array(step.details.enumerated()), id: \.offset) { index, detail in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.2))
                                    .frame(width: 8, height: 8)
                                
                                Text(detail)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                            }
                            .opacity(showContent ? 1 : 0)
                            .offset(x: showContent ? 0 : -20)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1 + 0.3), value: showContent)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal, 32)
                }
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
        .onChange(of: step.id) { _, _ in
            showContent = false
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

// MARK: - Preview

#Preview("Minimalist Onboarding") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    
    return builder.minimalistOnboardingView()
}

// MARK: - Builder Extension

extension CoreBuilder {
    func minimalistOnboardingView(router: AnyRouter? = nil, delegate: OnboardingFlowDelegate = OnboardingFlowDelegate()) -> some View {
        if let router {
            return AnyView(
                MinimalistOnboardingView(
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
                    MinimalistOnboardingView(
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
