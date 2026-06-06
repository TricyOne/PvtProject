# IceOut
IceOut is a crowdsourced mobile app for monitoring and reporting ice conditions at various 
locations around Stockholm. Users can sign in, browse recent ice reports and weather per 
location on a home screen, submit their own reports, and interact through a community feed.

The project has three parts: a **Flutter** mobile frontend (this section), a **Spring Boot**
microservice backend, and a **PostgreSQL** database. The frontend talks to the backend over HTTP.

## Frontend (Flutter app)

### Features
- Google Sign-In, plus a **guest mode** with restricted features - needs no setup, so anyone can try the app
- Home screen: nearest ice location auto-selected via GPS, recent ice reports across all locations and weather for certain hours
- Community feed: posts, other-user profiles, feeling picker
- Create and submit ice reports

### Requirements
- **Flutter SDK** 3.41.6 / **Dart SDK** `^3.11.4`. The Dart constraint is set in `pubspec.yaml` (`environment:`); verify your Flutter version with `flutter --version`.
- **Android Studio + Android SDK**, and either an Android emulator or a physical Android device with USB debugging enabled
- Target platform: **Android** (tested on emulator and physical device)
- Install Flutter: https://docs.flutter.dev/get-started/install
- *(Optional - only for Google Sign-In)* Your machine's debug SHA-1 fingerprint registered for the app (see Installation step 4). Without it, use **guest mode** - but several sections are then disabled (see *Running*).

Key packages (see `pubspec.yaml` for the full list and exact versions): `google_sign_in`
(pinned at `6.2.2`), `flutter_secure_storage`, `geolocator`, `flutter_map`, `flutter_osm_plugin`,
`latlong2`, `image_picker`, `http`, `google_fonts`.

### Installation
1. Clone the repository and open the project in VS Code / Android Studio.
2. From the project root, fetch dependencies:
```bash
   flutter pub get
```
3. Make sure the `assets/` folder (with its images and icons) is committed and present.
   The whole directory is declared in `pubspec.yaml` (`flutter:` → `assets: - assets/`),
   so no per-file paths need editing - the folder just has to exist.
4. *(Optional - Google Sign-In only)* Signing in with Google requires your machine's debug SHA-1
   to be registered for the app. Generate it and send it to the team member managing the project's
   Google Sign-In setup:
```bash
   cd android && ./gradlew signingReport   # Windows: gradlew signingReport
```
   Use the SHA-1 listed under "Variant: debug". To run the app without this, use **guest mode** on
   the login screen.

### Configuration
The app reaches the backend through a base-URL constant declared near the top of the
screen files:
```dart
const String apiBaseUrl = 'http://<BACKEND_HOST>:8080';
```
- Set `<BACKEND_HOST>` to wherever the backend runs. See the **Backend** section of this
  README for how to start it.
- If the backend runs locally on your machine (e.g. in Docker), note that from the Flutter app
  `localhost` points to the Android device/emulator itself, not your computer - so plain
  `localhost:8080` will not reach it. Use:
  - `10.0.2.2:8080` on an **Android emulator** (its alias for the host machine's localhost), or
  - your computer's **LAN IP** (e.g. `192.168.x.x:8080`) on a **physical device** on the same Wi-Fi.
  (`localhost:8080` only works for reaching the backend directly from the host, e.g. Swagger in a browser.)

The frontend needs no environment variables, credential files, API keys, or secrets to build or run.

### Running
```bash
flutter run
```
Pick your emulator or connected device when prompted. On the login screen, choose
**Sign in with Google** (works once your SHA-1 is registered - see Installation step 4) or **Continue as guest** (no setup needed).

In **guest mode**, the Community, ice-report, and profile sections are disabled at the
navigation bar - tapping those icons does nothing **by design** (it is not a bug). Sign in
with Google to access them.

**Tip:** The home screen renders an interactive OpenStreetMap view, which is
GPU-intensive. For the smoothest experience and real GPS, run on a **physical
Android device**. On an emulator, set Graphics to **Hardware - GLES 2.0**
(AVD Manager → Edit → Graphics) to avoid stutter while the map tiles load.

### Project structure (frontend)
- `lib/` - one Dart file per screen (`login_page.dart`, `home_screen.dart`,
  `community_screen.dart`, `profile_screen.dart`, `map_screen.dart`, …), plus
  `main.dart` (entry point) and `main_navigation.dart` (bottom-nav shell).
- `lib/ice_report/` - everything related to creating and submitting a new ice report. ← FRONTEND confirm folder contents/name

### Known limitations
- Some actions and screens are marked "in development" in the UI.
- Editing your own bio, display name or avatar is not implemented; the app uses the name and photo from your signed-in Google account.
- **Per-user names and avatars are limited by the backend API.** `/api/auth/me` returns only the current user's data (token-based, with no user-ID lookup), and posts carry only a `userId` - there is no endpoint to fetch another user's name or avatar by ID. So you see your own name and Google avatar throughout the app, but other users' posts appear as `User #<id>` with a default avatar.
- Following or messaging other users is not available: "Follow" shows an "in development" state, as there is no backend endpoint for follow requests.
- Tagging people and locations when creating a new post in the community section is not implemented.