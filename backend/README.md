# PawCare Firebase Admin SDK Backend

This backend module allows you to securely interact with Firebase using the **Firebase Admin SDK** to:
1. **Send Push Notifications (FCM)**: Send targeted alerts, vaccination reminders, and topic broadcasts to your Flutter app users.
2. **Manage Firestore Data**: Seed, query, and update users, pets, and vaccination records with full administrator privileges.
3. **Manage Auth Users**: Create, verify, or update user profiles programmatically.

---

## 🔒 Security Notice
> **IMPORTANT**: The Firebase Service Account JSON (`petcare-75450-firebase-adminsdk-*.json`) grants full administrative access to your Firebase project. 
> - **Never** bundle this file inside the Flutter client app (`/lib` or `/assets`).
> - It is automatically added to `.gitignore` to prevent pushing it to GitHub.

---

## 🚀 Setup & Installation

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Ensure `.env` is configured with your service account key path:
   ```env
   FIREBASE_SERVICE_ACCOUNT_PATH=/Users/bankimkamila/Downloads/petcare-75450-firebase-adminsdk-fbsvc-56e0edf315.json
   DEFAULT_NOTIFICATION_TOPIC=all_pet_parents
   ```

---

## 📲 Sending Push Notifications (FCM)

### 1. Vaccination Reminder:
```javascript
const { sendVaccinationReminder } = require('./src/notifications');

// Target device FCM token
const token = 'YOUR_DEVICE_FCM_TOKEN';

await sendVaccinationReminder(
  token,
  'Bella',             // Pet name
  'Rabies Booster',    // Vaccine
  'Tomorrow at 10:00 AM' // Due Date
);
```

### 2. General Pet Care Alert:
```javascript
const { sendCareAlert } = require('./src/notifications');

await sendCareAlert(
  token,
  'Bella',
  'Medication',
  'Give 1 dose of Heartgard with food.'
);
```

### 3. Broadcast to All Users (Topic):
```javascript
const { sendToTopic } = require('./src/notifications');

await sendToTopic(
  'all_pet_parents',
  '🎉 Welcome to PawCare!',
  'Explore new pet health and vaccination tracking features today.'
);
```

---

## 🗄️ Firestore Data Management

```javascript
const { savePet, addVaccinationRecord } = require('./src/dataManager');

// Save a pet for a user
await savePet('USER_FIREBASE_UID', {
  name: 'Bella',
  species: 'Dog',
  breed: 'Golden Retriever',
  gender: 'Female',
  age: 3,
  weight: 28.5,
  isNeutered: true,
});
```

---

## ☁️ Deploying to Firebase Cloud Functions (Optional)

If you want automated scheduling (e.g. daily cron jobs for vaccination checks), you can copy these handlers directly into `functions/index.js` using `firebase-functions/v2/scheduler`.
