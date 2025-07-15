@echo off
REM Build the APK
C:\src\flutter\bin\flutter build apk --release

REM Check if build was successful
if exist build\app\outputs\flutter-apk\app-release.apk (
    echo APK build successful, sending email...
    python send_apk_email.py
) else (
    echo APK build failed, not sending email.
)
pause 