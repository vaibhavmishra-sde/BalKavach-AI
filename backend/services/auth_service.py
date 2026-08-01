import os
import requests
import firebase_admin
from firebase_admin import auth
from backend.services.firestore_service import save_user, get_user
from backend.models.user import UserProfile

FIREBASE_WEB_API_KEY = os.getenv('FIREBASE_WEB_API_KEY')


def initialize_firebase_auth():
    if not firebase_admin._apps:
        from backend.utils.firebase_client import initialize_firebase
        initialize_firebase()


def signup_user(email: str, password: str, display_name: str, role: str):
    initialize_firebase_auth()
    user_record = auth.create_user(email=email, password=password, display_name=display_name)
    profile = UserProfile(
        user_id=user_record.uid,
        email=email,
        role=role,
        display_name=display_name,
        created_at=user_record.user_metadata.creation_timestamp,
    )
    save_user(user_record.uid, profile.to_dict())
    return profile.to_dict()


def login_user(email: str, password: str):
    if not FIREBASE_WEB_API_KEY:
        raise EnvironmentError('FIREBASE_WEB_API_KEY is required for login')

    endpoint = f'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_WEB_API_KEY}'
    response = requests.post(endpoint, json={
        'email': email,
        'password': password,
        'returnSecureToken': True,
    })
    data = response.json()
    if response.status_code != 200:
        raise ValueError(data.get('error', {}).get('message', 'Authentication failed'))

    user = get_user(data['localId'])
    if not user:
        raise ValueError('User profile not found')
    return user


def query_user_by_email(email: str):
    users = auth.list_users().iterate_all()
    for user in users:
        if user.email == email:
            return get_user(user.uid)
    return None
