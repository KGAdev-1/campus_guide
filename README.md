# Campus Guide

A comprehensive Flutter application designed to assist students with campus navigation and engagement in student activities.

## 🌟 **Key Features**

* **Interactive Campus Map:** Navigate the campus with a searchable, interactive map that includes color-coded buildings, pathways, and a detailed directory.
* **Event Calendar & Registration:** Discover and register for various campus events with a powerful event management system.
* **Lost & Found Section:** Report and find lost items on campus with a dedicated database.
* **Club & Organization Directory:** Explore a directory of student clubs with member tracking, contact information, and a seamless registration system.
* **Offline Support:** All core features, including the campus map, events, and club data, are available offline thanks to robust SQLite database storage.
* **Custom UI & Dark Mode:** Enjoy a modern user interface with custom animations, Material 3 design, and full support for a dark theme.

## 📦 **Dependencies**

This project uses the following key packages, as defined in `pubspec.yaml`:

| Package | Description |
| :--- | :--- |
| `provider` | State management for efficient and reactive UI updates. |
| `sqflite` | Database for local, offline data storage. |
| `path` | Helps in locating the correct path to the database. |
| `flutter_launcher_icons` | Used for generating platform-specific app icons from a single asset. |

## 🚀 **Installation & Setup Guide**

Follow these steps to get a copy of the project up and running on your local machine.

### **1. Prerequisites**

Make sure you have the following installed on your system:

* **Flutter SDK:** [Install Flutter](https://docs.flutter.dev/get-started/install)
* **Android Studio / VS Code:** With the Flutter and Dart plugins installed.
* **A physical device or emulator** to run the app.

### **2. Clone the Repository**

Clone the project from your version control system (e.g., Git) using the following command:

```bash
git clone https://github.com/KGAdev-1/campus_guide.git
cd campus_guide
```

### **3. Install Dependencies**

Open a terminal in the project directory and run the following command to install all the necessary packages:

```bash
flutter pub get
```

### **4. Generate App Icons**

This project uses `flutter_launcher_icons` to manage app icons. A custom logo is configured in `pubspec.yaml`. To generate the icons for both Android and iOS, run:

```bash
flutter pub run flutter_launcher_icons:main
```

### **5. Run the App**

Connect a physical device or start an emulator. Then, run the application from your terminal:

```bash
flutter run
```

You can also run the app directly from your IDE by pressing the "Run" button.

### **6. Database Setup**

The app uses `sqflite` for local storage. The database schema and sample data will be automatically initialized the first time you run the app. No manual setup is required.

## 🖼️ **Screenshots**

<img width="1408" height="2974" alt="Screenshot_20250805_174517" src="https://github.com/user-attachments/assets/e3941dea-d462-4c00-8993-d80b43158a7d" />

<img width="1408" height="2974" alt="Screenshot_20250805_174656" src="https://github.com/user-attachments/assets/c47ffe9b-a40c-40cd-be1e-56263bedeeb3" />

<img width="1408" height="2974" alt="Screenshot_20250805_174729" src="https://github.com/user-attachments/assets/c1793521-715b-406e-9680-995cce128bb8" />

<img width="1408" height="2974" alt="Screenshot_20250805_175411" src="https://github.com/user-attachments/assets/2be1de06-2c61-47fc-9a65-8bc27ebe9e8b" />

<img width="1408" height="2974" alt="Screenshot_20250805_175459" src="https://github.com/user-attachments/assets/8be2d47e-f29e-4b8d-bb9b-cb3b0d56e48e" />

