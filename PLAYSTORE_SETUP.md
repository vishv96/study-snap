# Play Store Automated Upload Setup

This guide will help you set up automated uploads to Google Play Store.

## Prerequisites

- [x] Flutter project ready
- [x] App already created in Google Play Console
- [x] Fastlane installed (`brew install fastlane`)
- [ ] Google Cloud service account with Play Store API access

---

## Step 1: Create Google Cloud Service Account

### 1.1 Enable Google Play Android Developer API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Go to **APIs & Services** → **Library**
4. Search for **"Google Play Android Developer API"**
5. Click **Enable**

### 1.2 Create Service Account

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **Service Account**
3. Fill in details:
   - **Name**: `play-store-uploader`
   - **Description**: `Service account for automated Play Store uploads`
4. Click **Create and Continue**
5. Skip role assignment (we'll set permissions in Play Console)
6. Click **Done**

### 1.3 Generate JSON Key

1. Click on the service account you just created
2. Go to **Keys** tab
3. Click **Add Key** → **Create new key**
4. Choose **JSON** format
5. Click **Create**
6. **Save the downloaded JSON file** as:
   ```
   android/fastlane/play-store-credentials.json
   ```

---

## Step 2: Grant Play Console Access

### 2.1 Add Service Account to Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Navigate to **Users and permissions**
3. Click **Invite new users**
4. Enter the service account email (looks like `play-store-uploader@YOUR-PROJECT.iam.gserviceaccount.com`)
5. Set permissions:
   - ✅ **View app information and download bulk reports (read-only)**
   - ✅ **Manage production releases**
   - ✅ **Manage testing track releases** (Internal, Alpha, Beta)
6. Click **Invite user**
7. The service account doesn't need to accept the invitation

---

## Step 3: Install Ruby Dependencies

```bash
cd android
bundle install
```

If you don't have Bundler:
```bash
gem install bundler
bundle install
```

---

## Step 4: Usage

### Quick Upload to Internal Testing
```bash
./upload_to_playstore.sh internal
```

### Upload to Other Tracks
```bash
# Alpha track
./upload_to_playstore.sh alpha

# Beta track
./upload_to_playstore.sh beta

# Just build, don't upload
./upload_to_playstore.sh build-only

# Promote from Internal to Alpha
./upload_to_playstore.sh promote-alpha
```

### Manual Fastlane Commands
```bash
cd android

# Internal testing
bundle exec fastlane internal

# Alpha
bundle exec fastlane alpha

# Beta
bundle exec fastlane beta
```

---

## What the Script Does

1. ✅ Cleans Flutter build cache
2. ✅ Gets latest dependencies
3. ✅ Builds release AAB
4. ✅ Uploads to specified Play Store track
5. ✅ Updates version automatically

---

## Troubleshooting

### Error: "play-store-credentials.json not found"
- Make sure you saved the JSON file in: `android/fastlane/play-store-credentials.json`
- Check the file path is correct

### Error: "Service account does not have permissions"
- Go to Play Console → Users and permissions
- Make sure the service account has "Manage testing track releases" permission
- Wait 5-10 minutes after granting permissions

### Error: "This release is not compliant"
- Your app doesn't meet Play Store requirements
- Check the error message in Play Console for specific issues
- Common issues: missing privacy policy, target API level too old

### Error: "Version code has already been used"
- Increment version code in `pubspec.yaml`:
  ```yaml
  version: 1.0.1+2  # Increment the number after +
  ```

---

## Security Notes

⚠️ **IMPORTANT**:
- **NEVER** commit `play-store-credentials.json` to git
- Add it to `.gitignore` (already done)
- Keep it secure - it has full access to your Play Store app

---

## CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Play Store

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.2'
      - name: Decode credentials
        run: echo "${{ secrets.PLAY_STORE_CREDENTIALS }}" | base64 -d > android/fastlane/play-store-credentials.json
      - name: Install Fastlane
        run: |
          cd android
          bundle install
      - name: Deploy to Internal
        run: ./upload_to_playstore.sh internal
```

Store `play-store-credentials.json` as base64 in GitHub Secrets:
```bash
base64 -i android/fastlane/play-store-credentials.json | pbcopy
# Paste in GitHub → Settings → Secrets → PLAY_STORE_CREDENTIALS
```

---

## Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Release Guide](https://docs.flutter.dev/deployment/android)
