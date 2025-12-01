#!/bin/bash

echo "🚀 Pornire Bot Discord..."

# Verifică dacă .env există
if [ ! -f ".env" ]; then
    echo "❌ Fișier .env nu a fost găsit!"
    echo "📋 Copiază .env.example în .env și adaugă token-ul botului"
    cp .env.example .env
    echo "✏️ Editează fișierul .env și adaugă token-ul tău"
    exit 1
fi

# Instalează dependențele
echo "📦 Instalare dependințe..."
dart pub get

# Rulează botul
echo "🤖 Pornire bot..."
dart run bin/main.dart