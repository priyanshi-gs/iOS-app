# LabLearn — Native iOS App (Swift & SwiftUI)

**LabLearn: Your Virtual Intelligent Science Lab** is a native iOS application built with **Swift 5 / SwiftUI** for Classes 6–12 PCM (Physics, Chemistry, Biology) students, designed using a clean, data-driven **MVVM (Model-View-ViewModel)** architecture.

---

## 📱 How to Run in Xcode

1. Open the project in Xcode:
   ```bash
   open LabLearn.xcodeproj
   ```
2. In Xcode, select the **LabLearn** scheme from the top toolbar.
3. Select any **iOS Simulator** (e.g., *iPhone 16 Pro*, *iPhone 15*, etc.).
4. Press **Cmd + R** (or click the **Play / Run** button) to build and run.

---

## 🏛 Architecture (MVVM & Data-Driven)

```
LabLearn/
├── App/
│   └── LabLearnApp.swift                 # App entry point & RootCoordinatorView
├── Models/
│   ├── LabExperiment.swift               # PCM experiment entities, subjects, status
│   ├── PeriodicElement.swift             # Element data, Bohr shells, Hinglish mnemonics
│   ├── Badge.swift                       # 18 Achievement badges & unlock criteria
│   └── Student.swift                     # Student profile, School, Entitlement, Orders
├── ViewModels/
│   ├── AppState.swift                    # Central coordinator for navigation & session
│   ├── AuthViewModel.swift               # Authentication & role selection logic
│   ├── LabsViewModel.swift               # Search & subject-filtered lab discovery
│   ├── PeriodicLabViewModel.swift        # Bohr orbital simulation & audio speech synthesis
│   └── SubscriptionViewModel.swift       # Billing cycle, promo codes, order calculation
├── Views/
│   ├── Common/
│   │   ├── Theme.swift                   # LabLearn color palette (Navy & Crimson)
│   │   ├── WaveHeader.swift              # Signature top curved wave header
│   │   └── CommonUI.swift                # PrimaryButton, CardContainer, chips, rows
│   ├── Auth/
│   │   ├── SplashLoginView.swift         # Welcome screen, Apple/Email login
│   │   ├── RoleSelectionView.swift       # School-linked vs. Independent choice
│   │   └── ConnectSchoolView.swift       # School referral code verification & access
│   ├── Main/
│   │   ├── MainTabView.swift             # Bottom tab bar navigation
│   │   ├── HomeView.swift                # Dashboard with active lab, stats & recents
│   │   └── BrowseLabsView.swift          # Searchable lab catalog with launch triggers
│   ├── Simulation/
│   │   ├── PeriodicLabView.swift         # Periodic Table selector & interactive modes
│   │   ├── BohrModelView.swift           # Real-time animated canvas of orbital shells
│   │   └── ElementDetailView.swift       # Element specs & Hinglish mnemonic audio player
│   ├── Subscription/
│   │   ├── LearningPlanView.swift        # Monthly/Yearly toggle & plan comparison
│   │   └── CheckoutPaymentView.swift     # UPI, Card, Net Banking & Payment Success
│   ├── Stats/
│   │   ├── LearningStatisticsView.swift  # Progress rings, monthly bar chart & streaks
│   │   └── MyBadgesView.swift            # 3-column grid of 18 achievement badges
│   └── Profile/
│       └── StudentProfileView.swift      # Profile specs, institution entitlement, sign-out
└── Resources/
    ├── Info.plist                        # App metadata & capabilities
    └── Assets.xcassets                   # AppIcon & AccentColor tokens
```

---

## ✨ Features Implemented from Design Mockups

1. **Authentication & Onboarding**:
   - Welcome Splash with brand illustrations and Apple/Email authentication.
   - Persona selection: *School-linked learner* vs. *Independent learner*.
   - School referral code verification (`EDU-PCM-2026`) with entitlement breakdown.
   - School connection confirmation for *Chaplin Pre-University (CPU)*.

2. **Dashboard & Labs**:
   - Interactive continue-card for in-progress experiments (*Acid-Base Titration*).
   - Metric pills: *2 Available Labs*, *12 Badges Won*, *18.5h Lab Hours*.
   - Subject categories: *Physics*, *Chemistry*, *Biology*.
   - Searchable lab directory with instant Launch actions.

3. **PeriodicLab Simulation**:
   - Interactive Periodic Table with category highlighting (Group 2 Alkaline Earth Metals).
   - **Bohr Atomic Shell Simulation**: Custom SwiftUI `Canvas` rendering rotating orbital electrons across K, L, M, N shells ($2, 8, 8, 2$).
   - **Audio Mnemonic**: Native iOS Speech Synthesis (`AVSpeechSynthesizer`) reciting Hinglish memory tricks (*"Beta Mange Car Scooter Baap Razi"*).

4. **Pricing, Checkout & Entitlements**:
   - Monthly (₹199/mo) and Yearly (₹1,999/yr, Save 20%) plans comparison.
   - Checkout with UPI, Credit/Debit cards, and Net Banking simulation.
   - Instant receipt and plan activation screen.

5. **Gamification & Analytics**:
   - Subject-wise progress bars (Physics, Chemistry, Biology).
   - Monthly activity bar chart and 7-day streak tracker.
   - 18 achievement badges with category filters and completion percentage ($12/18 = 67\%$).

