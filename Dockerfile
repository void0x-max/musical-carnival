# Etapa de build
FROM dart:stable AS builder

WORKDIR /app

# Copiază și instalează dependințele
COPY pubspec.yaml ./
RUN dart pub get

# Copiază codul sursă
COPY . .

# Build executabil
RUN dart compile exe bin/main.dart -o /app/bin/discord_bot

# Etapa de runtime
FROM debian:bookworm-slim

# Instalează runtime-ul Dart
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian bookworm stable' | tee /etc/apt/sources.list.d/dart_stable.list \
    && apt-get update && apt-get install -y dart \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiază executabilul de la builder
COPY --from=builder /app/bin/discord_bot /app/bin/

# Copiază restul fișierelor necesare
COPY --from=builder /app/.env /app/
COPY --from=builder /app/.env.example /app/
COPY --from=builder /app/pubspec.yaml /app/

# Creează user non-root
RUN useradd -m -u 1000 discordbot && chown -R discordbot:discordbot /app
USER discordbot

CMD ["/app/bin/discord_bot"]
