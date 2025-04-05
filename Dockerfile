# syntax=docker/dockerfile:1.4

FROM alpine AS fetcher

# Instalacja git oraz openssh do pobrania repozytorium przez SSH
RUN apk add --no-cache git openssh

# Tworzenie katalogu .ssh w celu przechowywania klucza i skonfigurowania połączeń SSH
RUN mkdir -p -m 0700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

# Skopiowanie repozytorium z GitHub za pomocą SSH
RUN --mount=type=ssh git clone git@github.com:sczupryn/pawcho6.git /src

# Użycie obrazu bazowego z pythonem
FROM python:3.11-alpine AS flask-app

# Ustawienie katalogu roboczego
WORKDIR /app

# Kopiowanie zawartości repozytorium
COPY --from=fetcher /src /app

# Instalacja wymaganych pakietów systemowych
RUN apk add --no-cache gcc musl-dev libffi-dev

# Instalacja zależności aplikacji Flask na podstawie pliku requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Ustawienie komendy, która zostanie uruchomiona przy starcie kontenera
CMD ["python3", "-u", "app.py"]