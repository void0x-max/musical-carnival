FROM dart:stable AS build

WORKDIR /app

COPY pubspec.yaml ./
RUN dart pub get

COPY . .
RUN dart pub get --offline

# Folosește aceeași imagine pentru runtime
FROM dart:stable

WORKDIR /app

# Copiază aplicația compilată
COPY --from=build /app /app

# Creează utilizator non-root
RUN useradd -m -u 1000 discordbot
USER discordbot

CMD ["dart", "run", "bin/main.dart"]
