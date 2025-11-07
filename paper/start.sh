#!/bin/bash
set -e

# Minecraft Server herunterladen, wenn noch nicht vorhanden
if [ ! -f paper.jar ]; then
    echo "Downloading PaperMC version $PAPER_VERSION..."
    curl -o paper.jar https://papermc.io/api/v2/projects/paper/versions/$PAPER_VERSION/builds/1/downloads/paper-$PAPER_VERSION-1.jar
fi

# EULA automatisch akzeptieren
echo "eula=${EULA}" > eula.txt

# Server starten und Logs an stdout/stderr weiterleiten
exec java -Xms1G -Xmx1G -jar paper.jar nogui
