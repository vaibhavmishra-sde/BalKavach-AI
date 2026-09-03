# BalKavach – AI Parental Security System

BalKavach helps parents protect their children from harmful digital behavior using AI-powered toxicity detection, image analysis, location monitoring, and alert management.

## Project Structure

- `backend/` – Flask backend API, Firebase integration, AI inference services
- `frontend/flutter_app/` – Flutter application with authentication, dashboard, alerts, analytics, and settings
- `ai_models/` – AI model utilities for text toxicity and image safety detection
- `firebase/` – Firebase service account guidance and integration notes
- `docs/` – Architecture, deployment, and setup documentation

## Setup Instructions

** 1. Backend Setup

1. Create a Python virtual environment and activate it.
2. Install dependencies:
   ```powershell
   cd backend
   python -m venv .venv
   .\\.venv\\Scripts\\Activate.ps1
   pip install -r requirements.txt
   ```
3. Copy `backend/.env.example` to `backend/.env` and set your Firebase credentials path.
4. Place your Firebase service account JSON at `firebase/serviceAccountKey.json`, or update `FIREBASE_CREDENTIALS`.
5. Run the backend from the workspace root:
   ```powershell
   cd ..
   python -m backend.main
   ```
   Or from the repository root using package entrypoint:
   ```powershell
   python -m backend
   ```

If you are inside the `backend/` folder and want a direct command, use:
```powershell
python .\run.py
```
Or run the provided PowerShell helper:
```powershell
.\run_backend.ps1
```

** 2. Flutter Frontend Setup

1. Install Flutter SDK and ensure `flutter doctor` passes.
2. From the Flutter project folder:
   ```powershell
   cd frontend\\flutter_app
   flutter pub get
   ```
3. If the project has not been initialized with platform folders yet, run:
   ```powershell
   flutter create .
   ```
4. Run the app on an emulator or device:
   ```powershell
   flutter run
   ```

** 3. AI Model Setup

- The backend uses Hugging Face BERT for toxicity detection and a TensorFlow CNN for image safety checks.
- The image model loader falls back to a default architecture if weights are not available.
- To train a custom model, see `ai_models/training/README.md`.

** 4.Development Notes

- The backend supports JWT token generation and stores activity logs in Firestore.
- Firebase Auth is expected to operate via the Firebase Admin SDK in the backend.
- Flutter app uses `provider` for state management and includes login, signup, dashboard, AI analysis, alerts, and settings screens.

** 5. Deployment

See `docs/deployment.md` for deployment recommendations for Flask and Flutter.

** 6.Contributing

We welcome contributions from the open-source community! If you'd like to help improve BalKavach AI, please see our [Contributing Guide](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) for details on how to get started.

## License

This project is open-source. Please see the [LICENSE](LICENSE) file for more information.
