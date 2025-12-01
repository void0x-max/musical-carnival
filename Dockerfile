FROM dart:stable AS build

WORKDIR /app

COPY pubspec.yaml ./
RUN dart pub get

COPY . .
RUN dart pub get --offline

FROM dart:stable-slim

WORKDIR /app

COPY --from=build /app /app

# Create non-root user
RUN useradd -m -u 1000 discordbot
USER discordbot

CMD ["dart", "run", "bin/main.dart"]