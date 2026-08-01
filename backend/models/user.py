from dataclasses import dataclass
from typing import Optional


@dataclass
class UserProfile:
    user_id: str
    email: str
    role: str  # 'parent', 'child', 'admin'
    display_name: Optional[str] = None
    created_at: Optional[str] = None

    def to_dict(self):
        return {
            'user_id': self.user_id,
            'email': self.email,
            'role': self.role,
            'display_name': self.display_name,
            'created_at': self.created_at,
        }
