#!/bin/bash

# Configuration
FLUTTER_CHANNEL="stable"
FLUTTER_VERSION="3.22.0" # You can adjust this to your needs

echo "--- Installing Flutter ($FLUTTER_CHANNEL) ---"

# Clone Flutter if it doesn't exist
if [ ! -d "flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL --depth 1
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Disable analytics and precache web artifacts
flutter config --no-analytics
flutter precache --web

echo "--- Flutter Version ---"
flutter --version

echo "--- Building Web App ---"
# Run the build from the task_test_app directory if we are at the root
# or just run it if we are already in the directory.
if [ -f "pubspec.yaml" ]; then
    flutter build web --release
elif [ -d "task_test_app" ]; then
    cd task_test_app
    flutter build web --release
else
    echo "Error: Could not find pubspec.yaml or task_test_app directory."
    exit 1
fi

echo "--- Build Complete ---"
