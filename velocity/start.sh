#!/bin/bash
set -e

# Init: Prüfen ob gemountetes Verzeichnis existiert und JAR fehlt
if [ ! -f /velocity/velocity.jar ]; then
    echo "Kopiere Standarddateien ins gemountete Verzeichnis..."
    cp /velocity-default/* /velocity/
fi

# Server starten
echo "Starting Velocity proxy..."
echo "  Xms = $JAVA_XMS"
echo "  Xmx = $JAVA_XMX"
echo "  Options = $JAVA_OPTS"

exec java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} $JAVA_OPTS -jar /velocity/velocity.jar
