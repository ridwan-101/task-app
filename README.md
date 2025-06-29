# Pocket Tasks

A simple task management app built with Flutter using Provider for state management and Hive for local storage.

## Features
- Add, edit, delete tasks
- Mark tasks as complete/incomplete
- Filter tasks by status (All/Active/Completed)
- Sort tasks by due date or creation date
- Light/dark theme support
- Offline support with Hive

## Architecture
The app follows MVVM (Model-View-ViewModel) architecture with clean separation of concerns:

- **Data Layer**: 
  - `models/`: Data models (e.g., Task)
  - `repositories/`: Business logic and data coordination
  - `data_sources/`: Concrete data implementations (Hive)

- **Presentation Layer**:
  - `views/`: UI screens
  - `view_models/`: State management with Provider
  - `widgets/`: Reusable UI components

- **Core**:
  - Utility classes, constants, and extensions

## State Management
The app uses the Provider package for state management. Each screen has its own ViewModel that extends ChangeNotifier. The ViewModels handle business logic and state, while the Views are purely presentational.

## Running the App
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## Testing
Run tests with:
```bash
flutter test