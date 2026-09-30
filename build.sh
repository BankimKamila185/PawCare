#!/usr/bin/env bash
set -e

echo "=== Checking / Installing Flutter SDK ==="
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter
fi

export PATH="$PWD/flutter/bin:$PATH"

echo "=== Flutter Version ==="
flutter --version

echo "=== Getting Dependencies ==="
flutter config --enable-web
flutter pub get

echo "=== Building Flutter Web Release ==="
flutter build web --release

echo "=== Build Succeeded! Output in build/web ==="
