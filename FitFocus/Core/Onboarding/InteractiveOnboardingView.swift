//
//  InteractiveOnboardingView.swift
//  FitFocus
//
//  Interactive card-based onboarding with swipe gestures
//

import SwiftUI

struct InteractiveOnboardingView: View {
    
    @State var presenter: OnboardingFlowPresenter
    let delegate: OnboardingFlowDelegate
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    
    private let cards = OnboardingCard.cards
    
    var body: some View {
        ZStack {
            // Animated background
            AnimatedMeshGradient(currentIndex: currentIndex)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                
                Spacer()
                
                // Card stack
                cardStack
                    .frame(maxHeight: 500)
                
                Spacer()
                
                // Progress and CTA
                bottomSection
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
            }
        }
        .onAppear {
            presenter.onViewAppear(delegate: delegate)
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
    }
    
    private var header: some View {
        HStack {
            Spacer()
            
            if currentIndex < cards.count - 1 {
                Button {
                    presenter.onSkipPressed()
                } label: {
                    Text("Skip")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                        )
                }
            }
        }
    }
    
    private var cardStack: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                if index >= currentIndex {
                    OnboardingCardView(card: card, isActive: index == currentIndex)
                        .offset(y: CGFloat(index - currentIndex) * 20)
                        .scaleEffect(1 - CGFloat(index - currentIndex) * 0.05)
                        .opacity(index == currentIndex ? 1 : 0.5)
                        .offset(x: index == currentIndex ? dragOffset : 0)
                        .rotationEffect(.degrees(index == currentIndex ? Double(dragOffset) / 25 : 0))
                        .gesture(
                            index == currentIndex ? DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    handleSwipe(value: value)
                                }
                            : nil
                        )
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: dragOffset)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentIndex)
                }
            }
        }
        .padding(.horizontal, 32)
    }
    
    private var bottomSection: some View {
        VStack(spacing: 20) {
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<cards.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(currentIndex == index ? .white : .white.opacity(0.3))
                        .frame(width: currentIndex == index ? 32 : 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                }
            }
            
            // CTA button
            Button {
                if currentIndex < cards.count - 1 {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        currentIndex += 1
                    }
                    presenter.onNextPressed(step: currentIndex)
                } else {
                    presenter.onFinishPressed()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(currentIndex < cards.count - 1 ? "Next" : "Let's Go!")
                        .font(.headline)
                    
                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .foregroundStyle(cards[currentIndex].color)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
                .shadow(color: .black.opacity(0.2), radius: 15, y: 10)
            }
            .buttonStyle(.plain)
        }
    }
    
    private func handleSwipe(value: DragGesture.Value) {
        let threshold: CGFloat = 100
        
        if value.translation.width < -threshold && currentIndex < cards.count - 1 {
            // Swipe left - next
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentIndex += 1
                presenter.onNextPressed(step: currentIndex)
            }
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = 0
        }
    }
}

// MARK: - Onboarding Card Data

struct OnboardingCard: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let color: Color
    let features: [String]
}

extension OnboardingCard {
    static let cards: [OnboardingCard] = [
        OnboardingCard(
            id: 0,
            icon: "timer",
            title: "Log Every Session",
            description: "Track your training with precision",
            color: .blue,
            features: [
                "Record duration and intensity",
                "Note techniques practiced",
                "Add session notes"
            ]
        ),
        OnboardingCard(
            id: 1,
            icon: "chart.bar.fill",
            title: "Visualize Progress",
            description: "See your improvement over time",
            color: .green,
            features: [
                "Interactive charts and graphs",
                "Weekly and monthly stats",
                "Compare performance"
            ]
        ),
        OnboardingCard(
            id: 2,
            icon: "flame.fill",
            title: "Build Streaks",
            description: "Stay consistent and motivated",
            color: .orange,
            features: [
                "Daily training reminders",
                "Streak freeze protection",
                "Unlock achievements"
            ]
        ),
        OnboardingCard(
            id: 3,
            icon: "star.fill",
            title: "Level Up",
            description: "Earn XP and reach new belts",
            color: .purple,
            features: [
                "Experience points system",
                "Belt progression tracking",
                "Celebrate milestones"
            ]
        )
    ]
}

// MARK: - Card View

struct OnboardingCardView: View {
    let card: OnboardingCard
    let isActive: Bool
    
    @State private var showFeatures = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [card.color.opacity(0.3), card.color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: card.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(card.color)
                    .symbolEffect(.bounce, options: .repeating, value: isActive)
            }
            
            // Title and description
            VStack(spacing: 12) {
                Text(card.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(card.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            // Features list
            VStack(spacing: 12) {
                ForEach(Array(card.features.enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(card.color)
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                        
                        Spacer()
                    }
                    .opacity(showFeatures ? 1 : 0)
                    .offset(x: showFeatures ? 0 : -20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1), value: showFeatures)
                }
            }
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        )
        .onChange(of: isActive) { _, newValue in
            if newValue {
                showFeatures = false
                withAnimation {
                    showFeatures = true
                }
            }
        }
        .onAppear {
            if isActive {
                withAnimation {
                    showFeatures = true
                }
            }
        }
    }
}

// MARK: - Animated Mesh Gradient

struct AnimatedMeshGradient: View {
    let currentIndex: Int
    
    var body: some View {
        ZStack {
            currentGradient
                .ignoresSafeArea()
        }
        .animation(.easeInOut(duration: 0.8), value: currentIndex)
    }
    
    private var currentGradient: some View {
        let colors = gradientColors(for: currentIndex)
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func gradientColors(for index: Int) -> [Color] {
        switch index {
        case 0:
            return [.blue.opacity(0.8), .cyan.opacity(0.6)]
        case 1:
            return [.green.opacity(0.8), .teal.opacity(0.6)]
        case 2:
            return [.orange.opacity(0.8), .red.opacity(0.6)]
        case 3:
            return [.purple.opacity(0.8), .pink.opacity(0.6)]
        default:
            return [.blue.opacity(0.8), .purple.opacity(0.6)]
        }
    }
}

// MARK: - Preview

#Preview("Interactive Onboarding") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    
    return builder.interactiveOnboardingView()
}

// MARK: - Builder Extension

extension CoreBuilder {
    func interactiveOnboardingView(router: AnyRouter? = nil, delegate: OnboardingFlowDelegate = OnboardingFlowDelegate()) -> some View {
        if let router {
            return AnyView(
                InteractiveOnboardingView(
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
                    InteractiveOnboardingView(
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
