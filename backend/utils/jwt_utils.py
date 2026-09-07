import os
import datetime
import jwt

JWT_ALGORITHM = 'HS256'
JWT_EXP_DELTA_SECONDS = int(os.getenv('JWT_EXP_SECONDS', '3600'))


def _jwt_secret() -> str:
    """Read the secret at request time so local .env configuration is honoured."""
    secret = os.getenv('JWT_SECRET')
    if not secret or secret == 'replace_with_secure_secret':
        if os.getenv('FLASK_DEBUG', 'false').lower() != 'true':
            raise RuntimeError('JWT_SECRET must be configured outside development')
        return 'development-only-secret-change-me'
    return secret


def create_token(payload: dict) -> str:
    payload = payload.copy()
    payload['exp'] = datetime.datetime.utcnow() + datetime.timedelta(seconds=JWT_EXP_DELTA_SECONDS)
    return jwt.encode(payload, _jwt_secret(), algorithm=JWT_ALGORITHM)


def decode_token(token: str) -> dict:
    try:
        return jwt.decode(token, _jwt_secret(), algorithms=[JWT_ALGORITHM])
    except jwt.ExpiredSignatureError:
        raise ValueError('Token expired')
    except jwt.InvalidTokenError:
        raise ValueError('Invalid token')
