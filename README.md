## FitQuest is a fitness tracking mobile application that allows users to monitor their running goals, track recent activity, and manage weekly fitness progress. Designed for simplicity and engagement, it uses intuitive graphs, goal management, and dynamic activity tracking features to help users achieve their fitness journey.

---

## 🚀 Features

### 🏃 Weekly Goals
- Set and track weekly running goals.
- Visualize weekly progress using real-time stats.

### 📊 Dynamic Jogging Stats
- Display stats such as distance, duration, and progress trends.

### 📅 Recent Activity Log
- View recent runs with durations and stats history.

### 📍 Real-Time Location Tracking
- Integrated with Google Maps API to track your location live while running.

### 🔗 Cloud Sync
- Data is synced with the cloud to ensure your progress persists.

### 🖥️ Profile Section
- Easily set up and view user fitness progress.

---

## 📱 Installation Guide

To set up and run the FitQuest app locally on your machine:

1. Clone the repository:

```bash
git clone git@gitlab.wethinkco.de:nsithole023/fitquest.git
```

## 🔧 Prerequisites
Before running FitQuest locally, ensure you have the following:

- **Flutter SDK**: [Setup instructions here](https://flutter.dev/docs/get-started/install).
- **Firebase Account**: Set up the Firebase project and connect the necessary configurations for cloud database syncing. [Firebase guide here](https://firebase.google.com/docs).
- **A configured Android/iOS environment** for running Flutter apps.

---

## 🛠️ Tech Stack

### **Languages & Frameworks**
- **Flutter** - Frontend framework for mobile development.
- **Dart** - Programming language.

### **Tools & Libraries**
- **Connectivity Plus**: Monitors network changes.
- **Provider**: State management pattern.
- **Cloud Firestore**: Scalable NoSQL database.

---

## 📂 Architecture Overview
The app follows the **MVVM (Model-View-ViewModel)** design pattern:

1. **Model**: Represents data structures like user fitness stats, recent runs, and user activity.
2. **ViewModel**: Contains the logic for managing user interaction with data and state changes.
3. **View**: Handles rendering UI components dynamically.


## 📸 App Screenshots

Below are sample screenshots of the app in action:

1. ![Home Screen](assets/images/Jla3P43tx11 (1).png)
2. ![Weekly Goals](assets/images/Jla3P43tx11 (2).png)
3. ![Real-Time Map Tracking](assets/images/Jla3P43tx11 (3).png)
4. ![Activity Log](assets/images/Jla3P43tx11 (4).png)
5. ![Profile Section](assets/images/Jla3P43tx11 (5).png)
