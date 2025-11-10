# Folia Dockerfile
FROM debian:13-slim

# Standard ARG für Folia Version
ARG FOLIA_VERSION=1.21.8

# Install Java und Hilfsprogramme
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis
WORKDIR /minecraft

# Folia JAR herunterladen
RUN curl -L -o folia.jar https://api.papermc.io/v2/projects/folia/versions/${FOLIA_VERSION}/builds/1/downloads/folia-${FOLIA_VERSION}-1.jar

# Startscript kopieren
COPY start.sh /minecraft/start.sh
RUN chmod +x /minecraft/start.sh

# EULA als ENV
ENV EULA=FALSE
# Java-Options
ENV JAVA_XMS=1G
ENV JAVA_XMX=2G

# Default CMD
CMD ["/minecraft/start.sh"]
