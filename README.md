# 🌍 Local Travel Guide — Sri Lanka
**SENG 31323 - Mobile Computing Technology**  
**University of Kelaniya — Faculty of Science**

---

## 👨‍💻 Developer Information
- **Name:** Hansi Tharaki
- **Student ID:** SE/2022/004
- **Track:** Track B — Local Tour & Travel Guide

---

## 📱 Framework & Technology
- **Framework:** Flutter (Dart)
- **Target Platform:** Android
- **Min SDK:** Android 8.0 (API 26)
- **State Management:** Provider

---

## 📦 Dependencies
```yaml
provider: ^6.1.2
sqflite: ^2.3.3+1
shared_preferences: ^2.2.3
geolocator: ^12.0.0
url_launcher: ^6.3.0
image_picker: ^1.1.2
path: ^1.9.0
```

---

## 🚀 Build & Run Steps

### Prerequisites
- Flutter SDK installed
- Android Studio installed (for Android SDK)
- USB Debugging enabled on Android device

### Steps
1. Clone or extract the project folder
2. Open terminal in the project root
3. Run dependencies:
```bash
flutter pub get
```
4. Connect Android device via USB
5. Verify device is detected:
```bash
flutter devices
```
6. Run the app:
```bash
flutter run
```

---

## ✨ Features Implemented

### Core Features (Track B)
- ✅ List/Grid of attractions filtered by Hotels, Nature, Historical
- ✅ Detailed page for each attraction
- ✅ Favourites bookmarking system (SQLite)

### Advanced Feature
- ✅ GPS distance calculation using Geolocator
- ✅ Google Maps navigation integration

### Extra Features
- ✅ User Registration & Login (SQLite)
- ✅ Forgot Password with OTP verification flow
- ✅ Star ratings with persistence
- ✅ Profile screen with photo picker
- ✅ Search bar with real-time filtering
- ✅ Notifications & Language settings
- ✅ Animated splash screen
- ✅ About screen

---

## 🗄️ Data Persistence
- **SQLite** — User accounts, favourites, ratings
- **SharedPreferences** — App settings, profile image path

## 🔧 Device Features Used
- **GPS / Geolocator** — Distance calculation
- **URL Launcher** — Google Maps navigation
- **Image Picker** — Profile photo from gallery

---

## 📁 Project Structure
```
lib/
├── data/           # Sample attractions data
├── models/         # Attraction data model
├── providers/      # State management (Provider)
├── screens/        # All app screens
├── services/       # Settings service
└── widgets/        # Reusable UI components
```