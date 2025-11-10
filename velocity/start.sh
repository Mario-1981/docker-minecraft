#!/bin/bash
set -e

echo "Starting Velocity proxy with:"
echo "  Xms = $JAVA_XMS"
echo "  Xmx = $JAVA_XMX"
echo "  Options = $JAVA_OPTS"

exec java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} $JAVA_OPTS -jar velocity.jar
