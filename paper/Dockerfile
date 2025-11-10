# PaperMC Dockerfile
FROM debian:13-slim

# Build-Argument für Paper-Version
ARG PAPER_VERSION=1.21.8

# Installiere Java und Hilfsprogramme
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis im Container
WORKDIR /minecraft

# Standard-Dateien Verzeichnis im Image
RUN mkdir -p /minecraft-default

# Paper JAR herunterladen (neueste Build)
RUN echo "Downloading PaperMC version ${PAPER_VERSION}..." && \
    BUILD=$(curl -fsSL https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION} | jq -r '.builds[-1]') && \
    curl -fsSL -o /minecraft-default/paper.jar https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${BUILD}/downloads/paper-${PAPER_VERSION}-${BUILD}.jar

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
