#!/bin/bash
set -euo pipefail

: "${PAPER_VERSION:=latest}"
: "${EULA:=FALSE}"
DOWNLOAD_API="https://api.papermc.io"

cd /minecraft

# Hilfsfunktion: lade URL atomar herunter
download_atomic() {
  local url="$1"
  local out="$2"
  tmp="${out}.tmp.$$"
  curl -fsSL "$url" -o "$tmp"
  mv "$tmp" "$out"
}

# Ermittele die gewünschte PAPER_VERSION (wenn "latest" -> neueste Version)
if [ "$PAPER_VERSION" = "latest" ]; then
  echo "Resolving latest PaperMC version..."
  PAPER_VERSION=$(curl -fsSL "$DOWNLOAD_API/v2/projects/paper" | jq -r '.versions | .[-1]')
  echo "Latest PaperMC version is: $PAPER_VERSION"
fi

# Ermittle neueste Build-Nummer für die Version
echo "Querying latest build for Paper $PAPER_VERSION..."
BUILD=$(curl -fsSL "$DOWNLOAD_API/v2/projects/paper/versions/$PAPER_VERSION/builds" | jq -r '.builds | .[-1].build')

if [ -z "$BUILD" ] || [ "$BUILD" = "null" ]; then
  echo "Fehler: konnte keinen Build für Version $PAPER_VERSION finden" >&2
  exit 1
fi

JAR_NAME="paper-${PAPER_VERSION}-${BUILD}.jar"
MARKER_FILE=".paper_version"

# Prüfe, ob gewünschte jar bereits vorhanden oder bereits als current markiert ist
if [ -f "$JAR_NAME" ]; then
  echo "Jar $JAR_NAME bereits vorhanden."
elif [ -f paper.jar ] && [ -f "$MARKER_FILE" ]; then
  current=$(cat "$MARKER_FILE" || true)
  if [ "$current" = "${PAPER_VERSION}:${BUILD}" ]; then
    echo "paper.jar entspricht bereits $PAPER_VERSION build $BUILD (keine Aktion)."
    JAR_NAME="paper.jar"
  else
    echo "Vorhandene paper.jar gehört zu $current — lade $PAPER_VERSION:$BUILD herunter."
    download_atomic "$DOWNLOAD_API/v2/projects/paper/versions/$PAPER_VERSION/builds/$BUILD/downloads/paper-$PAPER_VERSION-$BUILD.jar" "$JAR_NAME"
  fi
else
  echo "Lade Paper $PAPER_VERSION build $BUILD herunter..."
  download_atomic "$DOWNLOAD_API/v2/projects/paper/versions/$PAPER_VERSION/builds/$BUILD/downloads/paper-$PAPER_VERSION-$BUILD.jar" "$JAR_NAME"
fi

# Wenn wir eine spezifische jar-Datei haben, setze paper.jar (Symlink oder Kopie)
if [ "$JAR_NAME" != "paper.jar" ]; then
  # sichere Kopie/Link: ersetze atomar paper.jar
  ln -sf "$JAR_NAME" paper.jar
fi

# Marker schreiben (Version:Build)
echo "${PAPER_VERSION}:${BUILD}" > "$MARKER_FILE"

# EULA schreiben
echo "eula=${EULA}" > eula.txt

# Optional: JAVA_OPTS über ENV setzen (z.B. -Xms/-Xmx)
JAVA_OPTS="${JAVA_OPTS:--Xms1G -Xmx1G}"

# Server starten (exec = PID 1 -> logs an docker logs)
echo "Starting Paper $PAPER_VERSION (build $BUILD)..."
exec java ${JAVA_OPTS} -jar paper.jar nogui
