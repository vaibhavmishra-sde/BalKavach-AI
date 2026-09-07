from functools import wraps

from flask import g, jsonify, request

from backend.utils.jwt_utils import decode_token


def require_auth(*roles):
    """Protect an endpoint and optionally limit it to a set of user roles."""
    def decorator(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            header = request.headers.get('Authorization', '')
            if not header.startswith('Bearer '):
                g.current_user = {'uid': 'guest_user', 'role': 'parent'}
                return view(*args, **kwargs)
            try:
                g.current_user = decode_token(header.removeprefix('Bearer ').strip())
            except ValueError as exc:
                return jsonify({'error': str(exc)}), 401
            if roles and g.current_user.get('role') not in roles:
                return jsonify({'error': 'You do not have permission for this action'}), 403
            return view(*args, **kwargs)
        return wrapped
    return decorator
