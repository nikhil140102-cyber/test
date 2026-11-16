# How to run "test"

This guide takes you from this folder to the app running on a phone.
Commands are for **Windows PowerShell** unless marked otherwise.

App id: `com.avadhesh.test` (change the prefix in App Builder under App → App ID prefix, before the first setup).

---

## 1. Install the tools (one time per computer)

| Tool | Why | Get it |
|---|---|---|
| **Flutter SDK 3.27 or newer** | Builds and runs the app | docs.flutter.dev → Get started → Install |
| **Android Studio** | Android emulator and Android build tools | developer.android.com/studio |
| **VS Code** *(optional)* | A lighter code editor | code.visualstudio.com |
| **Xcode** *(Mac only, optional)* | Needed only for iPhone builds | Mac App Store |

### Windows: install Flutter

1. Download the Flutter SDK zip and extract it to **`C:\src\flutter`**.
   Do not use `Program Files`, OneDrive or any folder with spaces.
2. Add `C:\src\flutter\bin` to PATH:
   Start → "Edit environment variables for your account" → **Path** → Edit → New → `C:\src\flutter\bin` → OK.
3. Open a **new** PowerShell window and check:
   ```powershell
   flutter --version
   where.exe flutter
   ```
   `where.exe` must show **only one** Flutter folder. If it shows two, remove one from PATH (see Problems and fixes).

### Set up Android (one time)

1. Open Android Studio → **More Actions → SDK Manager → SDK Tools** → tick **Android SDK Command-line Tools** → Apply.
2. **More Actions → Virtual Device Manager → Create device** → **Pixel 8** → choose an **API 35** image → Finish.
3. Accept the licences:
   ```powershell
   flutter doctor --android-licenses
   flutter doctor
   ```
   Press **y** for every question. `flutter doctor` should show green ticks for Flutter and Android toolchain.

---

## 2. Put this folder somewhere safe

Unzip or save the app to a simple local path, for example:

```
C:\projects\apps\test
```

Avoid **OneDrive**, **Downloads** synced by OneDrive, and paths with spaces. OneDrive locks build files and causes random build errors.

---

## 3. Run it — choose one way

### A. One click (easiest)

1. Start your emulator: Android Studio → **Device Manager** → ▶ next to the phone. Wait for the home screen.
2. Double-click **`run_windows.bat`** (Mac/Linux: `./run_mac_linux.sh`).
3. If asked, type the number of the emulator in the device list.

The script does steps B1–B5 for you.

### B. Commands

Open PowerShell **in this folder** — the prompt must end with `\test>`:

```powershell
cd C:\projects\apps\test

# B1. Create the Android/iOS/web folders (first time only)
flutter create --org com.avadhesh --project-name test --platforms android,ios,web .

# B2. Download packages
flutter pub get

# B3. Add the internet permission for web images
dart tool/prepare_android.dart

# B4. Automatic checks
flutter analyze
flutter test

# B5. Start the emulator and run
flutter emulators
flutter emulators --launch <ID from the list above>
flutter devices
flutter run -d <device id, for example emulator-5554>
```

Replace `<...>` with the real value and leave out the `<` and `>` characters.
To try it quickly without an emulator: `flutter run -d chrome`.

### C. Android Studio

1. **Plugins:** File → Settings → Plugins → Marketplace → install **Flutter** (Dart comes with it) → **restart Android Studio**.
2. **File → Open** → select **this folder** (the one with `pubspec.yaml`, not the `android` folder) → Trust Project.
3. **File → Settings → Languages & Frameworks → Flutter** → Flutter SDK path = the folder that contains `bin` (for example `C:\src\flutter`) → Apply.
   This page only appears while a Flutter project is open.
4. Click **Pub get** in the bar at the top of the editor.
5. In the toolbar pick your emulator from the device list, check that **main.dart** is selected, and press the green **▶ Run**.

### D. VS Code

1. Extensions (Ctrl+Shift+X) → install **Flutter**.
2. File → Open Folder → this folder. In the terminal (Ctrl+`) run steps B1–B3 once.
3. Pick a device in the bottom-right corner and press **F5**.

---

## 4. Check that the app works

**Automatic:** `flutter test` opens every page at phone size and taps every button that leads to a page.
"All tests passed!" means no page has layout errors and every button goes to the right place.

**By hand on the emulator:**

- [ ] The start page matches the design in App Builder
- [ ] Every button goes to the right page
- [ ] The phone's Back button returns to the previous page
- [ ] Long pages scroll
- [ ] You can type in every text field
- [ ] No yellow-and-black striped bars (that means something does not fit)

The first launch in debug mode is slow and Android prints many lines starting with `I/` or `W/`.
Those are normal. Real errors start with `E/flutter`, `EXCEPTION CAUGHT`, `FAILURE` or `Error:`.

---

## 5. Make an installable app

```powershell
flutter build apk          # Android file to share: build\app\outputs\flutter-apk\app-release.apk
flutter build appbundle    # For the Google Play Store
flutter build web          # Website version in build\web
```

iPhone builds need a Mac with Xcode: `flutter build ios`.

---

## 6. After you change the design

Export again from App Builder into the **same folder** (or use **Save to my computer**).
Your `android`, `ios` and `web` folders and your `pubspec.yaml` are kept; the pages are replaced.
Then press **R** in the running app, or run it again.

If you have edited files in `lib/` by hand, copy your changes somewhere first: a new export replaces them.

---

## Problems and fixes

| Message or symptom | Fix |
|---|---|
| `'flutter' is not recognized` | Flutter's `bin` folder is not on PATH. Redo step 1 and open a **new** PowerShell window. |
| `No pubspec.yaml file found` | You are in the wrong folder. `cd` into this folder first. |
| Hundreds of errors like *"SingleChildScrollView isn't defined"* | Run `flutter pub get` inside this folder. |
| `The '<' operator is reserved` | You typed a placeholder. Replace `<ID>` with the real ID, without `<` `>`. |
| Error mentioning `spacing` | Flutter is older than 3.27. Run `flutter upgrade`. |
| `Device emulator-5554 is offline` | Wait for the phone's home screen, then restart adb: `& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" kill-server` and run `flutter devices` again. Still offline: Device Manager → ⋮ → **Cold Boot Now**, or create an **API 35** emulator. |
| Only Windows / Chrome / Edge in the device list | The emulator is not running yet. Start it from Device Manager and wait for the home screen. |
| Stuck on "Running Gradle task 'assembleDebug'" | The first Android build downloads tools and takes 5–15 minutes. Leave it running. Use `flutter run -v` to see progress. |
| `WARNING: A restricted method in java.lang.System` | Harmless Java message. Ignore it. |
| App shows only the Flutter logo | Wait 30 seconds. Then press **R** (hot restart), or stop and run `flutter run` from the terminal. |
| `expect` / `find` isn't defined in `test/` | `pubspec.yaml` is missing `flutter_test` under `dev_dependencies`. Copy it from a fresh export. |
| Android Studio: *"Flutter SDK installation is incomplete"* | Wrong SDK path. Run `where.exe flutter` and use the folder **before** `\bin`. |
| Android Studio: no **Flutter** under Languages & Frameworks | Install the Flutter plugin, restart, and **open this project first**. |
| `where.exe flutter` shows two folders | Keep one. Remove the other from PATH and delete that folder. |
| Images from the web do not show in the release APK | Run `dart tool/prepare_android.dart`, then build again. |
| Build fails with `compileSdk` or SDK version errors on a very new emulator | Create an **API 35** emulator and run on that. |
| Random build errors, files "in use" | Move the folder out of OneDrive, then run `flutter clean` and `flutter pub get`. |

Still stuck? Run `flutter doctor -v` and send the output together with the last 30 lines of the error.

---

## Sign-in, data and APIs

### Packages

This app uses: `supabase_flutter`, `http`. `run_windows.bat` adds them; by hand: `flutter pub add supabase_flutter http`.

### Supabase

The app connects to `https://suiqreqnohwsplpsldhz.supabase.co` with its publishable key.

- **Sign-in:** Supabase → Authentication → Sign In / Providers → Email must be on. With "Confirm email" on, new users must open the email before they can sign in.
- **Tables:** every table a Data list reads or a form saves to must exist, with row level security policies. Example for a `products` table anyone can read and signed-in users can add to:

```sql
create table if not exists public.products (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  user_id uuid default auth.uid(),
  name text,
  price numeric,
  image text
);
alter table public.products enable row level security;
create policy "Anyone can read products" on public.products for select using (true);
create policy "Signed-in users can add products" on public.products for insert to authenticated with check ((select auth.uid()) = user_id);
```

Column names must match the **field names** on your form ("Save as") and the `{{placeholders}}` in your Data list.

### APIs

- **Products**: `https://dummyjson.com/products?limit=20` (list at `products`)

Data lists GET these addresses; "Save the form" sends a JSON POST.

### Members-only pages

- Home
- Add product

Signed-out users see the login page instead.
