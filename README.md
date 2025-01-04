# whatsapp_call_console

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

## Explanation of the Code
State Management with Provider:

The CallViewModel class manages the call states (idle, ringing, inCall, callEnded) and transitions between them.
Views:

IdleView: Allows users to initiate a call or simulate an incoming call.
RingingView: Displays incoming call options (accept/reject).
InCallView: Shows in-call controls like mute, end call, and switch camera (for video calls).
CallEndedView: Displays a simple message when the call ends.
Architecture:

The CallViewModel handles all business logic, adhering to MVVM principles.
The UI updates automatically using Provider.

## Project Structure:

lib/
├── main.dart              // Entry point of the app
├── view/
│   └── call_screen.dart   // UI for all call-related views
└── view_model/
└── call_view_model.dart // State management logic

## Instructions to Run:
Create a Flutter Project:

Run flutter create whatsapp_call_console.
Replace Files:

Replace the generated main.dart with the one provided above.
Create folders view and view_model under lib/, and add the respective files.
Run the App:

Use flutter run to launch the app.

## Add Dependencies
Open your pubspec.yaml file in the root directory of your Flutter project.
Add the following dependency under the dependencies section:

dependencies:
flutter:
sdk: flutter
provider: ^6.1.3
camera: ^0.10.0+3
android_intent_plus: ^3.0.0
flutter_ringtone_player: ^3.0.0

Save the file and run the following command in your terminal to fetch the dependencies:

flutter pub get

## Permissions:
Ensure you have added camera permissions in the AndroidManifest.xml and Info.plist files:

For Android:

<uses-permission android:name="android.permission.CAMERA"/>

For iOS: Add this to your Info.plist:

<key>NSCameraUsageDescription</key>
<string>We need access to your camera for video calls</string>
Run on a Physical Device:
Camera functionality works only on physical devices, not on emulators.