# FinTech Mobile App - Flutter Interview Assignment

A comprehensive FinTech mobile application built with Flutter, following Clean Architecture principles and modern development practices. This project demonstrates a complete authentication flow, a feature-rich dashboard, and profile management.

## 🚀 Features Implemented

### MODULE 01: Authentication Flow
- **Splash Screen**: Branded launch screen for a professional app entry.
- **Onboarding Screens**: Multi-step interactive introduction for new users.
- **Login Screen**: Email/password authentication with validation.
- **Register Screen**: New user registration with form validation and real-time feedback.
- **OTP Verification with Audio Support**: 
    - Secure 6-digit OTP entry.
    - **Audio OTP (Plus Feature)**: Integrated `flutter_tts` to read out digits as they are typed and a "Listen to OTP" button for accessibility.
- **Forgot Password**: Complete email-based password recovery flow using Firebase.
- **Reset Password**: Seamless transition from recovery email to password reset.

### MODULE 02: FinTech Dashboard
A dynamic and responsive dashboard containing:
- **Account Balance Card**: Displays real-time balance with interactive update capability.
- **Gold Balance Card**: Shows gold holdings in grams and its equivalent market value.
- **Quick Action Buttons**: Easy access to Deposit, Income, and Expense management.
- **Advertisement Section**: Horizontal scrollable banner-style ad section for special offers.
- **Games Section**: "Play & Earn" cards for user engagement.
- **Referral Section**: Referral program UI with a unique code and "Copy to Clipboard" functionality.
- **YouTube Section**: Educational content feed with direct linking to YouTube.
- **Blog Section**: List of relevant financial articles and blog posts.

### MODULE 03: Profile Screen
- **User Profile Details**: Displays name, email, and user avatar.
- **Account Settings**: Management of user preferences.
- **Dark Mode**: Integrated theme switching support.
- **Logout**: Secure session termination and redirection to login.

## 🛠 Technical Requirements Met

- **Framework**: Flutter (Latest Stable).
- **Navigation**: **Go Router** used for all navigation.
    - Implemented **Redirect Logic** (Auth Guard) to ensure unauthenticated users are sent to Login and authenticated users to the Dashboard.
    - All routes are named and modularly defined.
- **State Management**: **GetX**
    - *Justification*: Chosen for its high productivity, efficient dependency injection, and reactive programming model which simplifies real-time updates from Firestore.
- **Firebase Integration**:
    - **Firebase Auth**: For Login, Registration, and Password Recovery.
    - **Cloud Firestore**: Used as the backend to store and retrieve user financial data, profile info, and dashboard content.
- **Architecture**: **Clean Architecture / Feature-First** structure for high maintainability and scalability.
- **UI/UX**: Responsive design using `flutter_screenutil`, consistent theming, and attention to detail.

## 🏗 Project Structure
```text
lib/
├── core/            # App-wide configurations
│   ├── controller/  # GetX Controllers (Auth, Theme, Dashboard)
│   ├── router/      # GoRouter configuration & guards
│   ├── services/    # Firebase & External service logic
│   └── theme/       # App themes (Light/Dark)
├── models/          # Data models for Firestore
├── screens/         # UI Screens (Feature-wise)
└── main.dart        # Entry point
```

## 📦 Setup & Installation

1. **Clone the Repo**: `git clone <repo-url>`
2. **Install Dependencies**: `flutter pub get`
3. **Firebase Configuration**:
   - Ensure `google-services.json` is present in `android/app/`.
4. **Run the App**: `flutter run`


---
