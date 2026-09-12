@echo off
setlocal
set "ROOT=%~dp0"
set "BACKEND_PY=%ROOT%backend\.venv\Scripts\python.exe"

if not exist "%BACKEND_PY%" (
    echo Backend virtual environment not found.
    echo Run the following once from the backend folder:
    echo   python -m venv .venv
    echo   .venv\Scripts\python.exe -m pip install -r requirements.txt
    pause
    exit /b 1
)


echo Starting BalKavach backend at http://127.0.0.1:5000 ...
start "BalKavach Backend" /D "%ROOT%" cmd /k ""%BACKEND_PY%" -m backend"

echo Starting BalKavach Flutter frontend in Chrome ...
start "BalKavach Frontend" /D "%ROOT%frontend\flutter_app" cmd /k "flutter run -d chrome"

echo.
echo Backend and frontend have been started in separate windows.
echo Keep both windows open while using BalKavach.
endlocal
