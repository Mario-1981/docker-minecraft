#!/bin/bash
set -e

# Init: Prüfen ob gemountetes Verzeichnis existiert und JAR fehlt
if [ ! -f /minecraft/paper.jar ]; then
    echo "Kopiere Standarddateien ins gemountete Verzeichnis..."
    cp /minecraft-default/* /minecraft/
fi

# EULA automatisch schreiben
echo "eula=${EULA}" > /minecraft/eula.txt
if [ "$EULA" != "TRUE" ]; then
    echo "EULA nicht akzeptiert. Setze EULA=TRUE im ENV."
fi

# Server starten
echo "Starting PaperMC server..."
echo "  Xms = $JAVA_XMS"
echo "  Xmx = $JAVA_XMX"
echo "  Options = $JAVA_OPTS"

exec java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} $JAVA_OPTS -jar /minecraft/paper.jar nogui
