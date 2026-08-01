import os

SECRET_KEY = os.environ.get("BAL_KAVACH_SECRET", "change-me-in-prod")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24  # 1 day

FIREBASE_CREDENTIALS = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS", "serviceAccount.json")
