Thermal Tracker Local Setup Guide

This guide provides step-by-step instructions to set up the Thermal Tracker project on your local machine. Follow these steps to clone the repository, install dependencies, and run the application.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Git](https://git-scm.com/)
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development on macOS)


## Git Flow

This project follows the Git Flow branching model. Here are the main branches used in this project:

- `main`: The main production branch.
- `feat/*`: Branches for new features.
- `fix/*`: Branches for bug fixes.

Proceed to create feature or fix branches from `main` as needed.

```
git checkout -b feat/PJ-your-feature-number
```

For example, to create a feature branch for feature number 12, you would run:

```
git checkout -b feat/PJ-12
```

## Clone the Repository

1. Open a terminal window.
2. Navigate to the directory where you want to clone the project.
3. Run the following command to clone the repository:

   ```bash
   git clone https://github.com/RodrigoSCoutinho/thermal_tracker.git
   ```

4. Navigate into the project directory:

   ```bash
   cd thermal_app
   ```

## Install Dependencies

1. Ensure you are in the project directory.
2. Run the following command to install the required dependencies:

   ```bash
   flutter pub get
   ```

## Run the Application

1. Connect a physical device or start an emulator.
2. Run the following command to start the application:

   ```bash
   flutter run
   ```

## Conclusion

You have successfully set up the Thermal Tracker project on your local machine. You can now start developing and testing the application.