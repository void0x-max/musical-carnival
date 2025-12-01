FROM dart:stable AS build

WORKDIR /app

COPY pubspec.yaml ./
RUN dart pub get

COPY . .
RUN dart pub get --offline

FROM dart:slim

WORKDIR /app

COPY --from=build /app /app

# Instalează dependințe runtime necesare
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Creează utilizator non-root
RUN useradd -m -u 1000 discordbot
USER discordbot

CMD ["dart", "run", "bin/main.dart"]
