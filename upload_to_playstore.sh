#!/bin/bash

# Play Store Upload Script
# Usage: ./upload_to_playstore.sh [internal|alpha|beta|build-only]

set -e

TRACK=${1:-internal}

echo "📦 Study Snap - Play Store Upload"
echo "=================================="
echo ""

# Check if credentials exist
if [ ! -f "android/fastlane/play-store-credentials.json" ]; then
    echo "❌ Error: Play Store credentials not found!"
    echo ""
    echo "Please follow these steps to set up credentials:"
    echo "1. Go to https://console.cloud.google.com/"
    echo "2. Create a service account with Play Store access"
    echo "3. Download the JSON key"
    echo "4. Save it as: android/fastlane/play-store-credentials.json"
    echo ""
    echo "See PLAYSTORE_SETUP.md for detailed instructions"
    exit 1
fi

echo "✅ Credentials found"
echo "🎯 Target track: $TRACK"
echo ""

cd android

case $TRACK in
    internal)
        echo "🚀 Building and uploading to Internal Testing..."
        fastlane internal
        ;;
    alpha)
        echo "🚀 Building and uploading to Alpha..."
        fastlane alpha
        ;;
    beta)
        echo "🚀 Building and uploading to Beta..."
        fastlane beta
        ;;
    promote-alpha)
        echo "🚀 Promoting Internal → Alpha..."
        fastlane promote_to_alpha
        ;;
    build-only)
        echo "🔨 Building AAB only (no upload)..."
        fastlane build_only
        ;;
    *)
        echo "❌ Invalid track: $TRACK"
        echo ""
        echo "Usage: ./upload_to_playstore.sh [internal|alpha|beta|build-only|promote-alpha]"
        exit 1
        ;;
esac

echo ""
echo "✅ Done!"
