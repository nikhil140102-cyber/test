@echo off
setlocal
cd /d "%~dp0"
title test - setup and run
echo.
echo  ===================================================
echo   Flutter setup and run
echo  ===================================================
echo.

where flutter >nul 2>nul
if errorlevel 1 goto :noflutter

echo %CD% | find /I "OneDrive" >nul
if not errorlevel 1 echo  [!] This folder is inside OneDrive. If the build fails, move it to C:\projects\apps and run again.

if exist "android\" goto :haveplatforms
echo  [1/5] Creating the Android, iOS and web project files...
call flutter create --org com.avadhesh --project-name test --platforms android,ios,web .
if errorlevel 1 goto :failed
goto :pubget
:haveplatforms
echo  [1/5] Project files already exist. Skipped.

:pubget
echo  [2/5] Downloading packages...
call flutter pub get
if errorlevel 1 goto :failed
call flutter pub add supabase_flutter http

echo  [3/5] Preparing Android settings...
call dart tool\prepare_android.dart

echo  [4/5] Running automatic checks...
call flutter test
if errorlevel 1 echo  [!] Some checks failed. Read the messages above. The app will still start.
if not errorlevel 1 echo  [OK] All checks passed.

echo.
echo  [5/5] Starting the app.
echo       Start your Android emulator first, or pick Chrome from the list.
echo       While it runs: r = reload, R = restart, q = quit.
echo.
call flutter run
goto :end

:firebasefail
echo.
echo  [X] Could not connect to Firebase.
echo      1. Install the Firebase CLI:  npm install -g firebase-tools
echo      2. Sign in:                   firebase login
echo      3. Check the Firebase project ID in the builder, App - Backend.
echo      Then run this file again. See HOW_TO_RUN.md, "Firebase".
goto :end

:noflutter
echo  [X] Flutter was not found on this computer.
echo      Install Flutter and add its bin folder to PATH, then run this file again.
echo      See HOW_TO_RUN.md, step 1.
goto :end

:failed
echo.
echo  [X] Setup stopped because of the error above.
echo      See HOW_TO_RUN.md, section "Problems and fixes".

:end
echo.
pause
