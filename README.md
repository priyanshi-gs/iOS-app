# LabLearn — Native iOS App (Swift & SwiftUI)

**LabLearn: Your Virtual Intelligent Science Lab** is a high-fidelity, native iOS application built with **Swift 5 & SwiftUI** for Classes 6–12 PCM (Physics, Chemistry, Biology) students, meticulously styled to match the official Figma design system.

---

## 📱 How to Run in Xcode

1. Open the project in Xcode:
   ```bash
   open LabLearn.xcodeproj
   ```
2. In Xcode, select the **LabLearn** target and scheme from the top toolbar.
3. Select any **iOS Simulator** (e.g., *iPhone 16 Pro*, *iPhone 15*, etc.).
4. Press **⌘ + R** (or click the **Play** button) to build and run.

---

## 🧭 The 6 Core Screens

The application is structured around a streamlined, interactive onboarding & subscription funnel:

| # | Screen | SwiftUI View | Key Features |
|:---:|:---|:---|:---|
| **1** | **Splash / Welcome** | `SplashWelcomeView.swift` | Full-bleed hero artwork (`splash_bg`), logo aligned 4pt above yellow bar, "Continue with Apple", soft crimson "Continue with Email", and "Create Account" navigation. |
| **2** | **Role Selection** | `RoleSelectionView.swift` | Persona choice between *School-linked learner* (gold building icon) and *Independent learner* (soft crimson graduation cap) with selection badges. |
| **3** | **Learning Plan (Monthly)** | `LearningPlanView.swift` | Interactive draggable glass toggle set to *Monthly*, Basic free tier card, and Premium Plan card (₹199 / month). |
| **4** | **Learning Plan (Yearly)** | `LearningPlanView.swift` | Draggable glass toggle set to *Yearly*, dynamic *Save 20% (₹400 off)* gold badge, and discounted price (₹1,999 / year). |
| **5** | **Complete Purchase** | `CheckoutPaymentView.swift` | Order summary, promo code applicator (`SAVE100`), payment method selector (UPI, Credit/Debit Card, Net Banking), and secure "Pay Now" trigger. |
| **6** | **Payment Successful** | `PaymentSuccessView.swift` | Celebration checkmark badge, active plan confirmation banner, transaction breakdown receipt card, and "Explore Labs" button. |

---

## 🎨 Signature Design & UI Highlights

### 1. Mathematically Fitted Organic Wave Header (`WaveHeader.swift`)
- **Organic Double-Crest Wave**: Fitted directly to Figma reference artboards using high-precision cubic Bézier curves:
  - Slopes smoothly up from the left edge (`y = 0.895h`) to a gentle crest under the back chevron (`x = 0.15w, y = 0.757h`).
  - Dips into a graceful center trough directly beneath the centered navigation title (`x = 0.47w, y = 1.000h`).
  - Rises to the right crest (`x = 0.86w, y = 0.710h`) and sweeps down to meet the trailing edge (`y = 0.800h`).
- **Signature Crimson Ring**: A bold `24pt` thick crescent band entering from the top edge, sweeping past the title level, and meeting the right wave boundary.

### 2. Draggable Glass Segmented Control (`CycleToggleBar`)
- **Interactive Drag Physics**: Drag the indicator pill horizontally with real-time gesture tracking and spring snapping (`.spring(response: 0.28, dampingFraction: 0.78)`).
- **Glassmorphism Styling**: Top-lit specular reflection gradient overlay, frosted bevel rim (`strokeBorder`), soft ambient shadow, and dynamic `1.02x` scale-up during drag.
- **Dual Interaction**: Supports both continuous dragging and instant single-tap switching between *Monthly* and *Yearly*.

### 3. Soft, Eye-Friendly Palette (`Theme.swift`)
- **Calibrated Matte Crimson & Ruby**: Specifically tuned (`#BA1438` and `#BD173B`) to eliminate eye strain and screen glare while maintaining crisp white text contrast.
- **Deep Velvet Card Gradient**: Luxurious wine-ruby background gradient (`#A61233` to `#850826`) on large card rectangles, eliminating the harshness of electric/neon reds.
- **Subtle Drop Shadows**: Reduced shadow opacity (`0.12` to `0.16`) to remove over-saturated glowing halos.

---

## 🏛 Clean & Lean Project Structure

```text
LabLearn/
├── App/
│   └── LabLearnApp.swift           # Root coordinator linking all 6 screens
├── Models/
│   └── PaymentModels.swift         # BillingCycle & PaymentMethodType enums
├── Views/
│   ├── Common/
│   │   ├── CardContainer.swift     # Reusable rounded card container
│   │   ├── Theme.swift             # Soft crimson & navy brand palette
│   │   └── WaveHeader.swift        # Curved organic wave header with red arc
│   └── Screens/
│       ├── SplashWelcomeView.swift # Screen 1: Welcome & Auth options
│       ├── RoleSelectionView.swift # Screen 2: Persona / Role selection
│       ├── LearningPlanView.swift  # Screens 3 & 4: Monthly & Yearly plans
│       ├── CheckoutPaymentView.swift # Screen 5: Order summary & payment
│       └── PaymentSuccessView.swift  # Screen 6: Confirmation & receipt
└── Resources/
    ├── Assets.xcassets             # splash_bg, AppIcon, AccentColor
    └── Info.plist                  # iOS bundle configuration
```

---

## 🛠 Tech Stack
- **Language**: Swift 5.0
- **Framework**: SwiftUI (iOS 16.0+ deployment target)
- **Architecture**: Lightweight State-Driven / MVVM
- **Dependencies**: 100% pure native Apple frameworks (Zero external third-party dependencies)
