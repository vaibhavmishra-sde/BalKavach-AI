import os
import requests
import hashlib
import uuid
from werkzeug.security import check_password_hash, generate_password_hash

try:
    import firebase_admin
    from firebase_admin import auth
    FIREBASE_AVAILABLE = True
except ImportError:
    firebase_admin = None
    auth = None
    FIREBASE_AVAILABLE = False

from backend.services.firestore_service import save_user, get_user, get_user_by_email
from backend.models.user import UserProfile

FIREBASE_WEB_API_KEY = os.getenv('FIREBASE_WEB_API_KEY')


def _hash_password(password: str) -> str:
    return generate_password_hash(password)


def _password_matches(password: str, stored_hash: str) -> bool:
    """Support legacy local accounts while new accounts use salted hashes."""
    if not stored_hash:
        return False
    if stored_hash.startswith(('pbkdf2:', 'scrypt:')):
        return check_password_hash(stored_hash, password)
    return hashlib.sha256(password.encode('utf-8')).hexdigest() == stored_hash


def _has_firebase_credentials() -> bool:
    credentials_path = os.getenv('FIREBASE_CREDENTIALS')
    return bool(credentials_path and os.path.exists(credentials_path) and FIREBASE_AVAILABLE)


def initialize_firebase_auth():
    if not _has_firebase_credentials():
        return False
    if not firebase_admin._apps:
        from backend.utils.firebase_client import initialize_firebase
        initialize_firebase()
    return True


def signup_user(email: str, password: str, display_name: str, role: str):
    if get_user_by_email(email):
        raise ValueError('An account with this email already exists')
    if initialize_firebase_auth():
        try:
            user_record = auth.create_user(email=email, password=password, display_name=display_name)
            profile = UserProfile(
                user_id=user_record.uid,
                email=email,
                role=role,
                display_name=display_name,
                created_at=str(user_record.user_metadata.creation_timestamp),
            )
            save_user(user_record.uid, profile.to_dict())
            return profile.to_dict()
        except Exception:
            pass

    user_id = str(uuid.uuid4())
    profile = UserProfile(
        user_id=user_id,
        email=email,
        role=role,
        display_name=display_name,
        created_at=None,
    )
    data = profile.to_dict()
    data['password_hash'] = _hash_password(password)
    save_user(user_id, data)
    return {k: v for k, v in data.items() if k != 'password_hash'}


def login_user(email: str, password: str):
    if FIREBASE_WEB_API_KEY and initialize_firebase_auth():
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

    user = get_user_by_email(email)
    if not user:
        raise ValueError('No account exists for this email. Create an account first.')
    if not _password_matches(password, user.get('password_hash', '')):
        raise ValueError('Incorrect password. Please try again.')

    # Upgrade hashes created by older local versions on a successful login.
    if not user.get('password_hash', '').startswith(('pbkdf2:', 'scrypt:')):
        user['password_hash'] = _hash_password(password)
        save_user(user['user_id'], user)

    return {k: v for k, v in user.items() if k != 'password_hash'}


def query_user_by_email(email: str):
    if FIREBASE_AVAILABLE and _has_firebase_credentials():
        users = auth.list_users().iterate_all()
        for user in users:
            if user.email == email:
                return get_user(user.uid)
    return get_user_by_email(email)
