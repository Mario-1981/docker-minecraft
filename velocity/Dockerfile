# Velocity Dockerfile
FROM debian:13-slim

# Build-Argument für Velocity-Version
ARG VELOCITY_VERSION=3.6.1

# Installiere Java & Hilfsprogramme
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis im Container
WORKDIR /velocity

# Standard-Dateien Verzeichnis im Image
RUN mkdir -p /velocity-default

# Velocity JAR herunterladen (neueste Build)
RUN echo "Downloading Velocity version ${VELOCITY_VERSION}..." && \
    BUILD=$(curl -fsSL https://api.papermc.io/v2/projects/velocity/versions/${VELOCITY_VERSION} | jq -r '.builds[-1]') && \
    curl -fsSL -o /velocity-default/velocity.jar https://api.papermc.io/v2/projects/velocity/versions/${VELOCITY_VERSION}/builds/${BUILD}/downloads/velocity-${VELOCITY_VERSION}-${BUILD}.jar

# Startscript ins Default-Verzeichnis kopieren
COPY start.sh /velocity-default/start.sh
RUN chmod +x /velocity-default/start.sh

# ENV für Java-Optionen
ENV JAVA_XMS=512M
ENV JAVA_XMX=1G
ENV JAVA_OPTS=""

# Standard CMD
CMD ["/velocity-default/start.sh"]
