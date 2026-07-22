#!/usr/bin/env bash
# Build do catálogo Flutter web na Vercel (modelo CPF). buildCommand do
# vercel.json tem limite de 256 chars, então a lógica mora aqui.
set -euo pipefail

FLUTTER_VERSION="3.44.4"

if [ ! -x flutter/bin/flutter ]; then
  curl -sL -o flutter.tar.xz \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  tar xf flutter.tar.xz
  rm flutter.tar.xz
fi

git config --global --add safe.directory '*'
export PATH="$PWD/flutter/bin:$PATH"

flutter config --enable-web --no-analytics
flutter pub get
flutter build web --release
