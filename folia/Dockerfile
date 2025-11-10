# Folia Dockerfile
FROM debian:13-slim

# Build-Argument für Folia-Version
ARG FOLIA_VERSION=1.21.8
ENV IMAGE_TAG=${FOLIA_VERSION}

# Installiere Java & Hilfsprogramme
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis im Container
WORKDIR /minecraft

# Standard-Dateien Verzeichnis im Image
RUN mkdir -p /minecraft-default

# Folia JAR herunterladen (neueste Build)
RUN echo "Downloading Folia version ${FOLIA_VERSION}..." && \
    BUILD=$(curl -fsSL https://api.papermc.io/v2/projects/folia/versions/${FOLIA_VERSION} | jq -r '.builds[-1]') && \
    curl -fsSL -o /minecraft-default/folia-${FOLIA_VERSION}.jar https://api.papermc.io/v2/projects/folia/versions/${FOLIA_VERSION}/builds/${BUILD}/downloads/folia-${FOLIA_VERSION}-${BUILD}.jar

# Startscript ins Default-Verzeichnis kopieren
COPY start.sh /minecraft-default/start.sh
RUN chmod +x /minecraft-default/start.sh

# ENV für EULA & Java
ENV EULA=FALSE
ENV JAVA_XMS=1G
ENV JAVA_XMX=2G
ENV JAVA_OPTS=""

# Standard CMD
CMD ["/minecraft-default/start.sh"]
