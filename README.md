# 🕵️‍♂️ SPY

Welcome to **SPY**, a Flutter-based surveillance tool designed for educational purposes. This app captures device data and syncs it with Firebase for analysis.

> ⚠️ **Disclaimer**: Use responsibly. This project is for learning and ethical testing only.

---

## 🚀 Getting Started

### 🔗 Clone the Repository

```bash
git clone https://github.com/rojanparajuli/spy.git
cd spy

🛠️ Setup Instructions
Follow the steps below to get the app up and running:

✅ Step 1: Create a Firebase Account
Go to Firebase Console

Create a new project named spy.


🔐 Step 2: Enable Authentication
Navigate to Authentication > Sign-in method

Enable Google and Email/Password authentication methods.


💾 Step 3: Create a Firestore Database
Go to Cloud Firestore

Click Create database and choose your location.


🛡️ Step 4: Set Database Rules
Set your database rules to the following (for dev/testing purposes):

# js
# Copy
# Edit
# rules_version = '2';
# service cloud.firestore {
#   match /databases/{database}/documents {
#     match /{document=**} {
#       allow read, write: if true;
#     }
#   }
# }
⚠️ Note: Do NOT use open rules in production.

▶️ Step 5: Run the App
Make sure your Flutter SDK is installed.

bash
Copy
Edit
flutter pub get
flutter run
☁️ Step 6: Data Syncs to Firebase
Once the app is running, it will automatically begin sending data (contacts & SMS) to your Firebase Firestore.


🔍 Step 7: View Data by User ID
Enter the user ID, and the screen will display the user's contacts and SMS data pulled from Firebase.


📷 Screenshots
Home Screen	Firebase Auth	Firebase Database

📚 Resources
Flutter Docs
### 🖼️ App Screenshots

Below are sample screenshots of the app:

| Home Screen | Firebase Auth | Firebase Database |
|-------------|--------------|------------------|
| ![Home Screen](assets/ss1.jpg) | ![Data screen](assets/ss2.jpg)  |

Write your first Flutter app

Firebase for Flutter

❤️ Support
If you like this project, consider giving it a ⭐ on GitHub!

