//
//  ModernWelcomeView.swift
//  FitFocus
//
//  A modern, animated welcome screen with gradient background
//

import SwiftUI

struct ModernWelcomeView: View {
    
    @State var presenter: WelcomePresenter
    let delegate: WelcomeDelegate
    
    @State private var isAnimating = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            gradientBackground
            
            // Content
            VStack(spacing: 0) {
                Spacer()
                
                // Hero section
                heroSection
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: showContent)
                
                Spacer()
                
                // CTA section
                ctaSection
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: showContent)
                
                // Policy links
                policyLinks
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeIn(duration: 0.3).delay(0.6), value: showContent)
                    .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            presenter.onViewAppear(delegate: delegate)
            
            withAnimation {
                isAnimating = true
                showContent = true
            }
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
    }
    
    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.6),
                Color.purple.opacity(0.7),
                Color.pink.opacity(0.5)
            ]),
            startPoint: isAnimating ? .topLeading : .bottomTrailing,
            endPoint: isAnimating ? .bottomTrailing : .topLeading
        )
        .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: isAnimating)
    }
    
    private var heroSection: some View {
        VStack(spacing: 24) {
            // Icon/Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Image(systemName: "figure.martial.arts")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.white)
                    .symbolEffect(.pulse.byLayer, options: .repeating, value: isAnimating)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .animation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.1), value: isAnimating)
            
            // Title and subtitle
            VStack(spacing: 12) {
                Text("FitFocus")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Track your BJJ journey")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            // Feature highlights
            VStack(spacing: 16) {
                FeatureRow(icon: "timer", text: "Track your training sessions")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Monitor your progress")
                FeatureRow(icon: "trophy.fill", text: "Achieve your goals")
            }
            .padding(.top, 32)
        }
        .padding(.horizontal, 32)
    }
    
    private var ctaSection: some View {
        VStack(spacing: 16) {
            // Primary CTA
            Button {
                presenter.onGetStartedPressed()
            } label: {
                HStack(spacing: 12) {
                    Text("Get Started")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            }
            .buttonStyle(.plain)
            
            // Secondary CTA
            Button {
                presenter.onSignInPressed()
            } label: {
                Text("Already have an account?")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                +
                Text(" Sign in")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 16)
    }
    
    private var policyLinks: some View {
        HStack(spacing: 16) {
            Link(destination: URL(string: Constants.termsOfServiceUrlString)!) {
                Text("Terms of Service")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Text("•")
                .foregroundStyle(.white.opacity(0.5))
            
            Link(destination: URL(string: Constants.privacyPolicyUrlString)!) {
                Text("Privacy Policy")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview("Modern Welcome") {
    let container = DevPreview.shared.container()
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    
    return builder.modernWelcomeView()
}

extension CoreBuilder {
    func modernWelcomeView(router: AnyRouter? = nil, delegate: WelcomeDelegate = WelcomeDelegate()) -> some View {
        if let router {
            return AnyView(
                ModernWelcomeView(
                    presenter: WelcomePresenter(
                        interactor: interactor,
                        router: CoreRouter(router: router, builder: self)
                    ),
                    delegate: delegate
                )
            )
        } else {
            return AnyView(
                RouterView { router in
                    ModernWelcomeView(
                        presenter: WelcomePresenter(
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
