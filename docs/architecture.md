# Architecture Overview


## System Layers


- **Frontend**: Flutter mobile app using `provider` for state management, Firebase SDKs for authentication and messaging, and a REST API service layer for backend communication.

- **Backend**: Flask API with modular controllers, service layers, and Firestore persistence.

- **AI Models**: Transformer-based toxicity detection and TensorFlow CNN image safety detection.

- **Firebase**: Auth, Firestore, and Cloud Messaging for user management, event storage, and notifications.


## Main Components

- `backend/main.py` - Flask application entrypoint
- `backend/controllers/` - API route handlers
- `backend/services/` - business logic, Firebase, AI inference, notification dispatch
- `frontend/flutter_app/lib/` - UI screens, provider state management, API service layer
- `ai_models/` - model loaders and training utilities

## Data Flow


1. User logs in or signs up in Flutter.
2. Flutter sends credentials to Flask `/api/auth` endpoints.
3. Backend verifies and saves users in Firestore.
4. Child content is analyzed through `/api/ai/toxicity` and `/api/ai/image`.
5. Results are stored in Firestore logs and pushed to parent dashboards.
6. SOS alerts are saved and dispatched via FCM.
