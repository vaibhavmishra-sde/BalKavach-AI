# BalKavach Flutter app

BalKavach is an AI-assisted child safety dashboard for guardians. The Flutter client provides authenticated access to safety alerts, analysis tools, activity summaries, and account settings.

## Run locally

From this directory:

```sh
flutter pub get
flutter run
```

The app uses the API configured in `lib/services/api_service.dart`. Keep credentials and environment-specific endpoints outside committed source files.

## UI conventions

- Material 3 components with responsive layouts for desktop and mobile.
- The dark theme is the primary dashboard experience; light mode is available from Settings.
- Auth forms use autofill hints, inline validation, and loading/error feedback.
