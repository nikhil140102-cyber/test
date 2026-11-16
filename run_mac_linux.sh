#!/usr/bin/env bash
# Sets up and runs this Flutter app. Usage: ./run_mac_linux.sh
cd "$(dirname "$0")" || exit 1
echo
echo "  Flutter setup and run"
echo

if ! command -v flutter >/dev/null 2>&1; then
  echo "  [X] Flutter was not found. Install it and add it to PATH (see HOW_TO_RUN.md, step 1)."
  exit 1
fi

if [ ! -d android ]; then
  echo "  [1/5] Creating the Android, iOS and web project files..."
  flutter create --org com.avadhesh --project-name test --platforms android,ios,web . || { echo "  [X] Setup stopped. See HOW_TO_RUN.md, 'Problems and fixes'."; exit 1; }
else
  echo "  [1/5] Project files already exist. Skipped."
fi

echo "  [2/5] Downloading packages..."
flutter pub get || { echo "  [X] Setup stopped. See HOW_TO_RUN.md, 'Problems and fixes'."; exit 1; }
flutter pub add supabase_flutter http

echo "  [3/5] Preparing Android settings..."
dart tool/prepare_android.dart

echo "  [4/5] Running automatic checks..."
if flutter test; then
  echo "  [OK] All checks passed."
else
  echo "  [!] Some checks failed. Read the messages above. The app will still start."
fi

echo
echo "  [5/5] Starting the app. Start an emulator first, or pick Chrome from the list."
echo "        While it runs: r = reload, R = restart, q = quit."
echo
flutter run
