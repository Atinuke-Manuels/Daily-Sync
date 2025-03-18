# DailySync

DailySync is a standup update tracking app that allows users to submit, edit, and delete their updates. Users can also view all submissions and comment on standup updates from others. The app supports role-based authentication, ensuring proper access control for different users.

## Features
- **User Authentication**: Secure login and signup with Firebase Authentication.
- **Role-Based Access Control**: Admins have access to the admin dashboard, while users can submit and manage their standup updates.
- **Standup Updates**: Users can add, edit, and delete their own standup updates.
- **Comments**: Users can comment on other users' standup updates.
- **Admin Dashboard**: Admins can manage users and view submitted updates.
- **Navigation System**: Users can navigate between their home screen and the all-submissions screen.

## Tech Stack
- **Flutter** (Frontend)
- **Firebase Auth** (User Authentication)
- **Cloud Firestore** (Database)
- **Provider** (State Management)

## Installation
1. Clone the repository:
   ```bash
   git clone 
   ```
2. Navigate to the project directory:
   ```bash
   cd dailysync
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Folder Structure
```
lib/
│── core/
│   ├── models/
│   ├── services/
│── view_model/
│── views/
│   ├── auth/
│   ├── admin/
│   ├── user/
│── widgets/
│── main.dart
```

## Usage
- **Sign Up / Login**: Users can create an account and log in.
- **Submit Standup Update**: Users can add a standup update.
- **Edit & Delete**: Users can edit or delete only their own submissions.
- **View All Submissions**: Users can navigate to a screen that displays all standup updates.
- **Commenting**: Users can comment on standup updates from others.
- **Admin Features**: Admins can manage users and view updates from all users.

## Contribution
Feel free to contribute! Fork the repository, make your changes, and submit a pull request.

## License
This project is licensed under the MIT License.

