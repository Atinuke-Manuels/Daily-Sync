# 🗓️ DailySync

**DailySync** is a collaborative standup reporting app designed to help teams stay aligned. It supports **admin scheduling**, **daily report submissions**, **role-based access**, and **team interaction via comments** — all in one intuitive interface.

---

## 🚀 Features Overview

### 🔐 Authentication & Roles
- **Firebase Authentication**: Secure signup and login.
- **Role-Based Access**: Differentiated views and actions for Admins and Users.
   - **Default Admin Account**:  
     Email: `dorcas@yahoo.com`  
     Password: `Dorcas@2022`

---

### 👩‍💼 Admin Features
- Create & schedule **daily standups**
- **View, add, and edit** team members
- Access and comment on **all standup reports** (comments are only visible to the user)

---

### 👤 User Features
- Submit **1 standup report per day**
- **Edit or delete** own report within **1 hour** of submission
- View **own reports**
- View **all team reports** *(read-only)*
- View **admin-scheduled standup reminders** (time, days, and notes)

---

## 🧱 Tech Stack

| Layer         | Technology        |
|---------------|-------------------|
| Frontend      | Flutter            |
| Auth          | Firebase Auth      |
| Database      | Cloud Firestore    |
| State Mgmt    | Provider           |

---

## 📁 Updated Folder Structure

```
lib/
├── core/
│   ├── models/              # Data models
│   ├── services/            # Firebase & other services
├── provider/                # App-wide providers
├── view_model/              # View models for business logic
├── views/
│   ├── auth/                # Login, Signup, Forgot Password
│   ├── admin/               # Admin dashboard, team, scheduling
│   ├── user/                # User home, submissions, reminders
├── widgets/                 # Reusable UI components
└── main.dart                # Entry point
```

---

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Atinuke-Manuels/Daily-Sync.git
   ```

2. **Navigate into the project**
   ```bash
   cd dailysync
   ```

3. **Get all dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📌 Usage Flow

- **Sign up** or **Log in** using Firebase Auth.
- **Admin** can schedule standups, manage team, and leave comments.
- **Users** can submit daily updates, and interact with the team's updates.

---

## 🤝 Contribution

Want to help improve DailySync? Fork the project, make changes, and create a pull request. Let’s build together!

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

