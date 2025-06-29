# 📱 Pocket Tasks

A simple yet powerful task management app built with **Flutter**, using **Provider** for state management and **Hive** for offline local storage.

---

## ✨ Features

- ✅ Add, edit, delete tasks
- ✅ Mark tasks as complete/incomplete
- ✅ Filter tasks by status (All / Active / Completed)
- ✅ Sort tasks by due date or creation date
- ✅ Light and dark theme support
- ✅ Full offline support with Hive

---

## 🧠 Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture with a clean separation of concerns:

### 🔹 Data Layer
- `models/` – Data models (e.g., `Task`)
- `repositories/` – Business logic and data coordination
- `data_sources/` – Hive local database implementations

### 🔹 Presentation Layer
- `views/` – UI screens
- `view_models/` – State management using `ChangeNotifier`
- `widgets/` – Reusable UI components

### 🔹 Core
- Utility classes, constants, and extensions

---

## 🔧 State Management

The app uses **Provider** for state management.  
Each screen has its own `ViewModel` that extends `ChangeNotifier`.  
The ViewModels handle business logic and state changes, while Views remain purely presentational.

---

## ▶️ Demo Video

📺 **Watch the app in action**:  
[https://drive.google.com/file/d/1-sSYqzvGD41b5Q6MeMm3XwIhI9e3pxWC/view?usp=sharing](https://drive.google.com/file/d/1-sSYqzvGD41b5Q6MeMm3XwIhI9e3pxWC/view?usp=sharing)

---

## 📦 APK Download

📥 **Try the app on Android**:  
[Download APK](https://drive.google.com/file/d/1HeiGSnH_N_5HgIwq3V8-7HiG8zHxCECv/view?usp=sharing)

---

## 🚀 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/task-app.git
   cd task-app
