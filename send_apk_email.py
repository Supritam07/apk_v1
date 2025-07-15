import smtplib
from email.message import EmailMessage

EMAIL_ADDRESS = 'supritam310797@gmail.com'         # <-- Your email address
EMAIL_PASSWORD = 'pzwwqrbozwovzqve'           # <-- Your app password (not your main password)
TO_ADDRESS = 'supritam310797@gmail.com'       # <-- Recipient's email address
APK_PATH = 'build/app/outputs/flutter-apk/app-release.apk'

msg = EmailMessage()
msg['Subject'] = 'Your Flutter APK Build'
msg['From'] = EMAIL_ADDRESS
msg['To'] = TO_ADDRESS
msg.set_content('Find the APK attached.')

with open(APK_PATH, 'rb') as f:
    file_data = f.read()
    file_name = 'app-release.apk'

msg.add_attachment(file_data, maintype='application', subtype='octet-stream', filename=file_name)

with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
    smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
    smtp.send_message(msg)

print('Email sent successfully!')