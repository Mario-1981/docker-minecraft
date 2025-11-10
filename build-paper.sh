#!/bin/bash
set -e

# === Konfiguration ===
IMAGE_NAME="ghcr.io/<USERNAME>/minecraft-paper"   # <-- hier deinen GHCR Namen einsetzen
DOCKERFILE_PATH="./paper/Dockerfile"               # Pfad zum Dockerfile

# === Eingaben prüfen ===
if [ -z "$1" ]; then
    echo "Usage: $0 <version> [latest]"
    echo "Example: $0 1.21.8 latest"
    exit 1
fi

VERSION="$1"
TAG_LATEST="$2"

echo "------------------------------------------------------------"
echo " Building PaperMC image for version: $VERSION"
echo " Dockerfile: $DOCKERFILE_PATH"
echo " Target image: $IMAGE_NAME:$VERSION"
echo "------------------------------------------------------------"

# === Image bauen ===
docker build \
    -t "$IMAGE_NAME:$VERSION" \
    --build-arg PAPER_VERSION="$VERSION" \
    -f "$DOCKERFILE_PATH" .

# === Push mit Versionstag ===
echo "Pushing $IMAGE_NAME:$VERSION..."
docker push "$IMAGE_NAME:$VERSION"

# === Optional: latest-Tag erstellen und pushen ===
if [ "$TAG_LATEST" = "latest" ]; then
    echo "Tagging and pushing as latest..."
    docker tag "$IMAGE_NAME:$VERSION" "$IMAGE_NAME:latest"
    docker push "$IMAGE_NAME:latest"
fi

echo "------------------------------------------------------------"
echo "✅ Build & Push erfolgreich abgeschlossen!"
echo " Version: $VERSION"
if [ "$TAG_LATEST" = "latest" ]; then
    echo " Tag latest: gesetzt"
fi
echo "------------------------------------------------------------"
