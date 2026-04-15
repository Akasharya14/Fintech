# FinTech Mobile App - Flutter

A complete FinTech application built with Flutter, following Clean Architecture principles. This project features a robust authentication flow, a dynamic dashboard, and user profile management.

## 🚀 Features

### Module 01: Authentication Flow
- **Splash Screen**: Branded launch screen.
- **Onboarding**: Interactive multi-step introduction for new users.
- **Login & Register**: Email/password based auth with form validation.
- **OTP Verification**: Secure OTP entry with Firebase integration.
- **Password Recovery**: Forgot password and recovery flow via Firebase.

### Module 02: FinTech Dashboard
- **Account Balance**: Real-time display of user's account balance.
- **Gold Portfolio**: Track gold holdings and current value.
- **Quick Actions**: Deposit, Portfolio, and Token management.
- **Interactive Sections**:
    - Scrollable Advertisement banners.
    - Play & Earn Games section.
    - Referral program with copy-to-clipboard functionality.
    - Educational YouTube content feed.
    - Financial Blog posts.

### Module 03: Profile Screen
- User profile details (Name, Email, Profile Initials).
- Account settings and preferences.
- **Dark Mode** toggle support.
- Secure Logout functionality.

## 🛠 Tech Stack
- **Framework**: Flutter (Latest Stable)
- **State Management**: GetX
- **Navigation**: Go Router (With redirect logic for Auth Guard).
- **Backend**: Firebase Authentication & Cloud Firestore.
- **UI/UX**: ScreenUtil for responsive design, Google Fonts, and Custom Themes.

## 🏗 Architecture
The project follows a **Feature-First / Clean Architecture** structure:
- `lib/core/`: Contains shared controllers, routing, themes, and utilities.
- `lib/screens/`: UI layer containing all the feature screens.
- `lib/models/`: Data models for Firestore objects.
- - `lib/service/`: Backend services for Firebase.



## 🧠 State Management Justification (GetX)
For this project, **GetX** was chosen for the following reasons:
1. **Productivity**: GetX reduces boilerplate code significantly, allowing for faster development of complex features like the FinTech dashboard.
2. **Dependency Injection**: It provides a simple yet powerful way to manage dependencies without the need for complex context-based providers.
3. **Reactive Programming**: The built-in `Obx` and `Worker` system makes it easy to handle real-time updates from Firebase (e.g., balance updates) reactively.
4. **Navigation**: While GoRouter is used for routing as per requirements, GetX's snackbar and dialog management simplifies UI feedback.

## 📦 Getting Started

### Prerequisites
- Flutter SDK installed.
- Android Studio / VS Code.
- A Firebase project setup.

### Installation
1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   ```
2. **Navigate to the project folder:**
   ```bash
   cd Fintech
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Firebase Setup:**
   - Add your `google-services.json` to `android/app/`.
   - Ensure the Firebase project has Authentication and Firestore enabled.
5. **Run the app:**
   ```bash
   flutter run
   ```

