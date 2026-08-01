from backend.controllers.auth_controller import auth_bp
from backend.controllers.ai_controller import ai_bp
from backend.controllers.admin_controller import admin_bp

all_blueprints = [auth_bp, ai_bp, admin_bp]
