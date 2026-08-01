import firebase_admin
from firebase_admin import credentials, firestore, auth as fb_auth
from app.core.config import FIREBASE_CREDENTIALS
import os
import logging


def init_firebase():
    # Development-friendly: if service account not present, skip initialization
    cred_path = os.path.abspath(FIREBASE_CREDENTIALS)
    if not os.path.exists(cred_path):
        logging.warning(f"Firebase credentials not found at {cred_path}. Skipping firebase init (dev mode).")
        return None
    if not firebase_admin._apps:
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
    return firestore.client()


db = init_firebase()
