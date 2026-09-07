import os
import sqlite3
import json
import shutil
import tempfile
from backend.utils.firebase_client import initialize_firebase

_db_conn = None
_legacy_db_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'local_db.sqlite3'))
_app_data_dir = os.path.join(os.getenv('LOCALAPPDATA', os.path.expanduser('~')), 'BalKavach')
_db_path = os.path.abspath(os.getenv('LOCAL_DB_PATH', os.path.join(_app_data_dir, 'local_db.sqlite3')))
_temporary_db_path = os.path.join(tempfile.gettempdir(), 'BalKavach', 'local_db.sqlite3')
_db_path = os.path.abspath(_db_path)
_use_firestore = None


def _connect_local_db():
    global _db_conn, _db_path
    if _db_conn is None:
        try:
            os.makedirs(os.path.dirname(_db_path), exist_ok=True)
        except PermissionError:
            # Some managed IDE/sandbox environments cannot write to the project
            # or LocalAppData folders. The temporary directory remains writable
            # and is sufficient for local development accounts.
            _db_path = _temporary_db_path
            os.makedirs(os.path.dirname(_db_path), exist_ok=True)

        # Earlier versions stored SQLite beside the source code. That folder can
        # be read-only when the app is launched from a downloaded archive or an
        # IDE sandbox. Migrate it once to the user's writable application-data
        # folder so account creation and login keep working.
        if _db_path != _legacy_db_path and not os.path.exists(_db_path) and os.path.exists(_legacy_db_path):
            shutil.copy2(_legacy_db_path, _db_path)

        _db_conn = sqlite3.connect(_db_path, check_same_thread=False)
        _db_conn.row_factory = sqlite3.Row
        _create_local_tables(_db_conn)
    return _db_conn


def _create_local_tables(conn):
    with conn:
        conn.execute(
            '''
            CREATE TABLE IF NOT EXISTS users (
                user_id TEXT PRIMARY KEY,
                email TEXT UNIQUE,
                password_hash TEXT,
                role TEXT,
                display_name TEXT,
                created_at TEXT,
                data TEXT
            )
            '''
        )
        conn.execute(
            '''
            CREATE TABLE IF NOT EXISTS alerts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp TEXT,
                payload TEXT
            )
            '''
        )
        conn.execute(
            '''
            CREATE TABLE IF NOT EXISTS logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp TEXT,
                payload TEXT
            )
            '''
        )


def _row_to_dict(row):
    if not row:
        return None
    try:
        payload = json.loads(row['data']) if row['data'] else {}
    except Exception:
        payload = {}

    return {
        'user_id': row['user_id'],
        'email': row['email'],
        'role': row['role'],
        'display_name': row['display_name'],
        'created_at': row['created_at'],
        **payload,
    }


def _save_local_user(user_id: str, user_data: dict):
    conn = _connect_local_db()
    with conn:
        conn.execute(
            'REPLACE INTO users (user_id, email, password_hash, role, display_name, created_at, data) VALUES (?, ?, ?, ?, ?, ?, ?)',
            (
                user_id,
                user_data.get('email'),
                user_data.get('password_hash'),
                user_data.get('role'),
                user_data.get('display_name'),
                user_data.get('created_at'),
                json.dumps({k: v for k, v in user_data.items() if k not in ('user_id', 'email', 'password_hash', 'role', 'display_name', 'created_at')}),
            ),
        )
    return _get_local_user(user_id)


def _get_local_user(user_id: str):
    conn = _connect_local_db()
    row = conn.execute('SELECT * FROM users WHERE user_id = ?', (user_id,)).fetchone()
    return _row_to_dict(row)


def _get_local_user_by_email(email: str):
    conn = _connect_local_db()
    row = conn.execute('SELECT * FROM users WHERE email = ?', (email,)).fetchone()
    return _row_to_dict(row)


def _save_local_payload(table: str, payload: dict):
    conn = _connect_local_db()
    with conn:
        conn.execute(
            f'INSERT INTO {table} (timestamp, payload) VALUES (?, ?)',
            (payload.get('timestamp'), json.dumps(payload)),
        )
    return payload


def _get_local_alerts(limit: int = 50):
    conn = _connect_local_db()
    rows = conn.execute('SELECT payload FROM alerts ORDER BY id DESC LIMIT ?', (limit,)).fetchall()
    return [json.loads(row['payload']) for row in rows]


def _should_use_firestore():
    global _use_firestore
    if _use_firestore is not None:
        return _use_firestore
    try:
        initialize_firebase()
        _use_firestore = True
    except Exception:
        _use_firestore = False
    return _use_firestore


def get_db():
    if _should_use_firestore():
        return initialize_firebase()
    return None


def save_user(user_id: str, user_data: dict):
    db = get_db()
    if db is not None:
        doc = db.collection('users').document(user_id)
        doc.set(user_data, merge=True)
        return doc.get().to_dict()
    return _save_local_user(user_id, user_data)


def get_user(user_id: str):
    db = get_db()
    if db is not None:
        doc = db.collection('users').document(user_id).get()
        return doc.to_dict() if doc.exists else None
    return _get_local_user(user_id)


def get_user_by_email(email: str):
    db = get_db()
    if db is not None:
        users = db.collection('users').where('email', '==', email).limit(1).stream()
        for doc in users:
            return doc.to_dict()
        return None
    return _get_local_user_by_email(email)


def save_alert(alert_data: dict):
    db = get_db()
    if db is not None:
        alerts = db.collection('alerts')
        alerts.add(alert_data)
        return alert_data
    return _save_local_payload('alerts', alert_data)


def save_activity_log(log_data: dict):
    db = get_db()
    if db is not None:
        logs = db.collection('logs')
        logs.add(log_data)
        return log_data
    return _save_local_payload('logs', log_data)


def get_alerts(limit: int = 50):
    db = get_db()
    if db is not None:
        docs = db.collection('alerts').order_by('timestamp', direction='DESCENDING').limit(limit).stream()
        return [doc.to_dict() for doc in docs]
    return _get_local_alerts(limit)
