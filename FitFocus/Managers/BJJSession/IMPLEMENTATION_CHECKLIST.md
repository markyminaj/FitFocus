//
//  IMPLEMENTATION_CHECKLIST.md
//  FitFocus - Onboarding Implementation Checklist
//

# ✅ Onboarding Implementation Checklist

Use this checklist to integrate the new onboarding flow into your app.

---

## 📦 Files Created (6 files)

- ✅ `ModernWelcomeView.swift` - Animated welcome screen
- ✅ `OnboardingFlowView.swift` - Page-based onboarding
- ✅ `InteractiveOnboardingView.swift` - Card-based onboarding
- ✅ `MinimalistOnboardingView.swift` - Minimalist onboarding
- ✅ `OnboardingStylePicker.swift` - Development preview tool
- ✅ `OnboardingIntegrationGuide.swift` - Integration documentation

---

## 🎯 Step 1: Choose Your Style

Preview all styles using `OnboardingStylePicker.swift`:

```swift
#Preview {
    OnboardingStylePicker()
}
```

**Recommendations:**
- **Energetic/Fitness Apps**: ModernWelcome + Interactive
- **Professional Apps**: ModernWelcome + Minimalist
- **Educational Apps**: ModernWelcome + PageFlow

---

## 🔧 Step 2: Update Router Protocol

Add methods to your `WelcomeRouter` protocol:

```swift
protocol WelcomeRouter: AppRouter {
    func showOnboardingFlow(delegate: OnboardingFlowDelegate)
    func showInteractiveOnboarding(delegate: OnboardingFlowDelegate)
    func showMinimalistOnboarding(delegate: OnboardingFlowDelegate)
    
    // Existing methods...
    func showOnboardingCompletedView(delegate: OnboardingCompletedDelegate)
    func showCreateAccountView(delegate: CreateAccountDelegate, onDismiss: (() -> Void)?)
    func switchToCoreModule()
}
```

---

## 🔨 Step 3: Implement Router Methods

In `CoreRouter.swift` (or your router implementation):

```swift
extension CoreRouter: WelcomeRouter {
    
    func showOnboardingFlow(delegate: OnboardingFlowDelegate) {
        router.showScreen(.push) { _ in
            builder.onboardingFlowView(router: router, delegate: delegate)
        }
    }
    
    func showInteractiveOnboarding(delegate: OnboardingFlowDelegate) {
        router.showScreen(.push) { _ in
            builder.interactiveOnboardingView(router: router, delegate: delegate)
        }
    }
    
    func showMinimalistOnboarding(delegate: OnboardingFlowDelegate) {
        router.showScreen(.push) { _ in
            builder.minimalistOnboardingView(router: router, delegate: delegate)
        }
    }
    
    // Keep existing implementations...
}
```

---

## 📝 Step 4: Update WelcomePresenter

In `WelcomePresenter.swift`, update `onGetStartedPressed()`:

```swift
func onGetStartedPressed() {
    interactor.trackEvent(event: Event.getStartedPressed)
    
    // Choose your preferred style:
    router.showOnboardingFlow(delegate: OnboardingFlowDelegate())
    
    // OR:
    // router.showInteractiveOnboarding(delegate: OnboardingFlowDelegate())
    
    // OR:
    // router.showMinimalistOnboarding(delegate: OnboardingFlowDelegate())
}
```

Don't forget to add the event to your Event enum:

```swift
enum Event: LoggableEvent {
    // ... existing cases
    case getStartedPressed
    
    var eventName: String {
        switch self {
        // ... existing cases
        case .getStartedPressed: return "WelcomeView_GetStarted_Pressed"
        }
    }
}
```

---

## 🎨 Step 5: Customize Content

### Update App Name

In `ModernWelcomeView.swift`:

```swift
Text("FitFocus")  // Change this
    .font(.system(size: 48, weight: .bold, design: .rounded))
```

### Customize Onboarding Steps

Choose which view you're using and update its content:

**OnboardingFlowView** - Edit `OnboardingStep.steps`:
```swift
extension OnboardingStep {
    static let steps: [OnboardingStep] = [
        OnboardingStep(
            id: 0,
            icon: "timer",  // SF Symbol name
            title: "Track Your Sessions",
            description: "Log every training session...",
            accentColor: .blue
        ),
        // Add more steps...
    ]
}
```

**InteractiveOnboardingView** - Edit `OnboardingCard.cards`:
```swift
extension OnboardingCard {
    static let cards: [OnboardingCard] = [
        OnboardingCard(
            id: 0,
            icon: "timer",
            title: "Log Every Session",
            description: "Track your training...",
            color: .blue,
            features: ["Feature 1", "Feature 2"]
        ),
        // Add more cards...
    ]
}
```

**MinimalistOnboardingView** - Edit `MinimalistStep.steps`:
```swift
extension MinimalistStep {
    static let steps: [MinimalistStep] = [
        MinimalistStep(
            id: 0,
            icon: "figure.martial.arts",
            title: "Welcome to FitFocus",
            description: "Your personal BJJ...",
            details: []  // Optional detail list
        ),
        // Add more steps...
    ]
}
```

---

## 🎨 Step 6: Adjust Colors (Optional)

To match your brand, update colors in each view:

```swift
// Change accent colors
Color.accentColor  // Uses your app's accent color
Color.blue         // Or use specific colors
```

For custom colors, you can:
1. Use Asset Catalog colors: `Color("YourColorName")`
2. Define custom colors: `Color(red: 0.5, green: 0.2, blue: 0.8)`

---

## 🧪 Step 7: Test the Flow

### Test User Flows:

1. **New User Flow**:
   - [ ] App launches → WelcomeView appears
   - [ ] Tap "Get Started" → Onboarding appears
   - [ ] Complete onboarding → Main app appears
   - [ ] Verify onboarding marked complete

2. **Sign In Flow**:
   - [ ] Tap "Sign In" → CreateAccountView appears
   - [ ] Sign in as new user → Onboarding appears
   - [ ] Sign in as returning user → Skip to main app

3. **Skip Flow**:
   - [ ] Tap "Skip" during onboarding
   - [ ] Verify marks onboarding complete
   - [ ] Verify goes to main app

### Test Interactions:

- [ ] Swipe gestures work (for page-based views)
- [ ] Animations are smooth
- [ ] Back button works (minimalist view)
- [ ] Skip button works
- [ ] CTA buttons work
- [ ] Links (Terms, Privacy) work

---

## 📊 Step 8: Verify Analytics

Check that events are being logged:

1. **Welcome Screen Events**:
   - [ ] `WelcomeView_Appear`
   - [ ] `WelcomeView_GetStarted_Pressed`
   - [ ] `WelcomeView_SignIn_Pressed`

2. **Onboarding Events**:
   - [ ] `OnboardingFlow_Appear`
   - [ ] `OnboardingFlow_Next_Pressed` (with step number)
   - [ ] `OnboardingFlow_Skip_Pressed`
   - [ ] `OnboardingFlow_Finish_Pressed`

---

## ♿️ Step 9: Test Accessibility

- [ ] Test with VoiceOver enabled
- [ ] Test with Large Text size
- [ ] Test in Light and Dark mode
- [ ] Test with Reduce Motion enabled
- [ ] Test with High Contrast mode

---

## 📱 Step 10: Test on Devices

- [ ] Test on iPhone (multiple sizes)
- [ ] Test on iPad (if supported)
- [ ] Test different iOS versions
- [ ] Test in landscape orientation

---

## 🚀 Step 11: Deploy

### Pre-deployment Checklist:

- [ ] Remove debug tools (OnboardingStylePicker)
- [ ] Update app name in all views
- [ ] Verify all text is correct
- [ ] Check for typos
- [ ] Ensure colors match brand
- [ ] Test with real analytics service
- [ ] Get design approval
- [ ] Test with QA team

### Optional Improvements:

- [ ] Add localization support
- [ ] Add custom animations
- [ ] Add sound effects
- [ ] Add haptic feedback
- [ ] A/B test different styles

---

## 🐛 Troubleshooting

### Common Issues:

**Issue**: Onboarding doesn't appear
- ✅ Check router methods are implemented
- ✅ Verify builder methods exist
- ✅ Check delegate is passed correctly

**Issue**: Analytics not tracking
- ✅ Verify LogManager is injected
- ✅ Check event names match your tracking service
- ✅ Verify parameters are formatted correctly

**Issue**: Navigation doesn't work
- ✅ Check router.switchToCoreModule() is implemented
- ✅ Verify saveOnboardingComplete() is called
- ✅ Check user auth state

**Issue**: Colors look wrong
- ✅ Check accent color in Asset Catalog
- ✅ Verify appearance (Light/Dark mode)
- ✅ Test color accessibility

---

## 💡 Tips

1. **Start Simple**: Begin with one onboarding style, test thoroughly
2. **User Feedback**: Collect feedback on onboarding experience
3. **Iterate**: Update content based on user behavior
4. **A/B Test**: Try different styles with different user segments
5. **Keep It Short**: 3-4 steps is ideal, don't overwhelm users
6. **Clear Value**: Each step should communicate clear value
7. **Easy Exit**: Always provide skip option
8. **Mobile First**: Design for portrait orientation first

---

## 📚 Additional Resources

- `OnboardingIntegrationGuide.swift` - Detailed integration guide
- `ONBOARDING_README.md` - Complete documentation
- `OnboardingStylePicker.swift` - Preview tool

---

## ✅ Final Checklist

Before marking complete:

- [ ] Chose onboarding style
- [ ] Updated router protocol
- [ ] Implemented router methods
- [ ] Updated WelcomePresenter
- [ ] Customized content
- [ ] Adjusted colors
- [ ] Tested all user flows
- [ ] Verified analytics
- [ ] Tested accessibility
- [ ] Tested on real devices
- [ ] Got design approval
- [ ] Ready to deploy

---

**Status**: ⬜️ Not Started | 🔄 In Progress | ✅ Complete

**Date Started**: _______

**Date Completed**: _______

**Deployed Version**: _______

---

🎉 **You're all set!** Enjoy your beautiful new onboarding experience!
