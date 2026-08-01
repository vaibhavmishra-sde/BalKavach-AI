from backend.utils.firebase_client import get_fcm_client


def send_fcm_notification(token: str, title: str, body: str, data: dict = None):
    messaging = get_fcm_client()
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body),
        token=token,
        data=data or {}
    )
    response = messaging.send(message)
    return response
