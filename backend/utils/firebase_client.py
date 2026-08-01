import os
import firebase_admin
from firebase_admin import credentials, firestore, messaging


def initialize_firebase():
    credentials_path = os.getenv('FIREBASE_CREDENTIALS', 'firebase/serviceAccountKey.json')
    if not os.path.exists(credentials_path):
        raise FileNotFoundError(
            f'Firebase credentials file not found at {credentials_path}. Set FIREBASE_CREDENTIALS in .env.')

    cred = credentials.Certificate(credentials_path)
    if not firebase_admin._apps:
        firebase_admin.initialize_app(cred)
    return firestore.client()


def get_fcm_client():
    if not firebase_admin._apps:
        initialize_firebase()
    return messaging
