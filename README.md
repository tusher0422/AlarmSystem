# AlarmSystem

A smart Flutter alarm app that helps you relax and sync with nature’s rhythm. 
This app includes onboarding, location-based personalization, and alarm notifications.

---

## Tools & Packages Used

- **Flutter** 3.32.4
- **Dart** 3.8.1
- **Android Studio** (recommended IDE)
- **Packages:**
  - `flutter_local_notifications` → for showing notifications when the alarm goes off or is turned off
  - `geolocator` → for getting current user location
  - `smooth_page_indicator` → for onboarding page indicators

---

## Features

- 3 beautiful onboarding screens
- Location permission and location fetch
- Alarm setting with:
  - Toggle on/off switch
  - Notifications when alarm fires or gets turned off
- Clean and minimal UI

---

## Project Setup 

```bash
git clone https://github.com/your-username/nature-sync-alarm.git
cd nature-sync-alarm
flutter pub get
flutter run
