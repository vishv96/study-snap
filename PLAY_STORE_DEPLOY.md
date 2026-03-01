# Study Snap — Play Store Deployment Guide

## What's already done

- Application ID changed to `com.studysnap.app`
- App label set to "Study Snap"
- Release build config with ProGuard (minify + shrink)
- Signing config reads from `android/key.properties`
- ProGuard rules added
- App icons generated for all densities

---

## Step 1: Create a Google Play Developer Account

Go to [play.google.com/console](https://play.google.com/console) and pay the one-time $25 fee. Use your Google account to sign up.

---

## Step 2: Generate an Upload Keystore

Run this in your Mac terminal:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias studysnap
```

You'll be prompted for a password and your details. **Save this keystore file and password — you can never recover them.**

---

## Step 3: Create key.properties

Create the file `android/key.properties` (NOT the .example file) with your actual values:

```
storePassword=YOUR_PASSWORD_FROM_STEP_2
keyPassword=YOUR_PASSWORD_FROM_STEP_2
keyAlias=studysnap
storeFile=/Users/YOUR_USERNAME/upload-keystore.jks
```

**Never commit this file to git** (it's already in .gitignore).

---

## Step 4: Build the App Bundle

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

The output AAB file will be at:
`build/app/outputs/bundle/release/app-release.aab`

---

## Step 5: Create Your Play Store Listing

In the Google Play Console:

1. **Create app** → Enter "Study Snap", select language, app type (App), free/paid
2. **Store listing**:
   - Short description (80 chars max)
   - Full description (4000 chars max)
   - App icon (512x512) — already generated at `android/app/src/main/ic_launcher-playstore.png`
   - Feature graphic (1024x500) — you'll need to create this
   - At least 2 screenshots (phone) — take from your app
3. **Content rating** → Fill out the questionnaire
4. **Target audience** → Select age groups
5. **Privacy policy** → You need a URL (can host on GitHub Pages for free)

---

## Step 6: Upload and Release

1. Go to **Production** → **Create new release**
2. Let Google manage your signing (recommended)
3. Upload the `.aab` file from Step 4
4. Add release notes
5. **Review and roll out**

---

## Review Timeline

Google typically reviews new apps within 1-7 days. First-time developers may take longer.

---

## Quick Checklist

- [ ] Google Play Developer account ($25)
- [ ] Upload keystore generated
- [ ] key.properties created
- [ ] App bundle built successfully
- [ ] Privacy policy URL ready
- [ ] Store listing completed (icon, screenshots, descriptions)
- [ ] Content rating questionnaire done
- [ ] App uploaded and submitted for review
