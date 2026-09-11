# Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com.

2. Enable Email/Password Authentication in Firebase Auth.

3. Create a Firestore database in production or test mode.

4. Enable Firebase Cloud Messaging.

5. Generate a service account JSON file:
   - Go to Project Settings > Service Accounts
   - Create a new private key
   - Download the JSON and save to `firebase/serviceAccountKey.json`

6. Update `backend/.env` with the credentials path:
   ```text
   FIREBASE_CREDENTIALS=../firebase/serviceAccountKey.json
   ```

7. Add Firebase rules for secure Firestore access in production.
