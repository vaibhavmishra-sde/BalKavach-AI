# Deployment Guide

## Backend Deployment

1. Provision a server or container with Python 3.11+.
2. Copy the project and install dependencies:
   ```powershell
   cd backend
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```
3. Add production environment variables to `backend/.env`.
4. Ensure `FIREBASE_CREDENTIALS` points to a valid Firebase service account file.
5. Use a WSGI server such as Gunicorn or Waitress to run `backend/main.py`.
   Example with Waitress:
   ```powershell
   pip install waitress
   waitress-serve --host=0.0.0.0 --port=5000 backend.main:create_app()
   ```
6. Configure HTTPS and a reverse proxy (Nginx, Apache) for SSL and host routing.

## Flutter Deployment

1. Ensure Flutter is installed and `flutter doctor` is clean.
2. Build Android APK:
   ```powershell
   cd frontend\flutter_app
   flutter build apk --release
   ```
3. Build iOS app on macOS with Xcode:
   ```bash
   cd frontend/flutter_app
   flutter build ios --release
   ```
4. For web deployment:
   ```powershell
   flutter build web
   ```

## Firebase Production

- Set up Firebase Authentication for email/password login.
- Configure Cloud Firestore with appropriate security rules.
- Enable Firebase Cloud Messaging for notifications.
- Use a separate Firebase project for production.
