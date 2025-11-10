#!/bin/bash
set -e

MINECRAFT_DIR=/minecraft
DEFAULT_DIR=/minecraft-default
FOLIA_JAR="$MINECRAFT_DIR/folia-${IMAGE_TAG}.jar"

# --- Prüfen ob gemountetes Verzeichnis existiert ---
if [ ! -d "$MINECRAFT_DIR" ]; then
    echo "Fehler: gemountetes Verzeichnis $MINECRAFT_DIR existiert nicht!"
    exit 1
fi

# --- Prüfen ob Folia-JAR existiert und Version passt ---
UPDATE_NEEDED=0
if [ ! -f "$FOLIA_JAR" ]; then
    echo "FOLIA JAR fehlt."
    UPDATE_NEEDED=1
else
    # Prüfen ob bereits eine andere version existiert
    CURRENT_JAR=$(ls $MINECRAFT_DIR/folia-*.jar 2>/dev/null | head -n 1)
    if [ "$CURRENT_JAR" != "$FOLIA_JAR" ]; then
        echo "Version stimmt nicht überein ($CURRENT_JAR != $FOLIA_JAR). Update nötig."
        UPDATE_NEEDED=1
    fi
fi

# --- Update durchführen falls nötig ---
if [ $UPDATE_NEEDED -eq 1 ]; then
    echo "Update: Alte Folia-JAR und Libraries löschen..."
    rm -f $MINECRAFT_DIR/folia-*.jar
    rm -rf $MINECRAFT_DIR/libraries
    echo "Kopiere Standarddateien ins gemountete Verzeichnis..."
    cp $DEFAULT_DIR/folia-${IMAGE_TAG}.jar $MINECRAFT_DIR/
    cp $DEFAULT_DIR/start.sh $MINECRAFT_DIR/
fi

# --- EULA prüfen und schreiben ---
if [ "$EULA" != "TRUE" ]; then
    echo "EULA nicht akzeptiert! Setze EULA=TRUE im Environment."
    exit 1
fi
echo "eula=TRUE" > $MINECRAFT_DIR/eula.txt

# --- Server starten ---
echo "Starting Folia server..."
echo "  Xms = ${JAVA_XMS:-1G}"
echo "  Xmx = ${JAVA_XMX:-2G}"
echo "  Options = ${JAVA_OPTS:-"-XX:+UseG1GC -XX:+ParallelRefProcEnabled"}"

cd $MINECRAFT_DIR
exec java -Xms${JAVA_XMS:-1G} -Xmx${JAVA_XMX:-2G} ${JAVA_OPTS:-"-XX:+UseG1GC -XX:+ParallelRefProcEnabled"} -jar $FOLIA_JAR nogui
