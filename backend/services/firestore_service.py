from backend.utils.firebase_client import initialize_firebase


db = None


def get_db():
    global db
    if db is None:
        db = initialize_firebase()
    return db


def save_user(user_id: str, user_data: dict):
    db = get_db()
    doc = db.collection('users').document(user_id)
    doc.set(user_data, merge=True)
    return doc.get().to_dict()


def get_user(user_id: str):
    db = get_db()
    doc = db.collection('users').document(user_id).get()
    return doc.to_dict() if doc.exists else None


def save_alert(alert_data: dict):
    db = get_db()
    alerts = db.collection('alerts')
    alerts.add(alert_data)
    return alert_data


def save_activity_log(log_data: dict):
    db = get_db()
    logs = db.collection('logs')
    logs.add(log_data)
    return log_data


def get_alerts(limit: int = 50):
    db = get_db()
    docs = db.collection('alerts').order_by('timestamp', direction='DESCENDING').limit(limit).stream()
    return [doc.to_dict() for doc in docs]
