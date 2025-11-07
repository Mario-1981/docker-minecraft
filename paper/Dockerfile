# Basis-Image
FROM debian:13

# Installiere OpenJDK und curl/wget
RUN apt-get update && apt-get install -y openjdk-17-jdk-headless curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis
WORKDIR /minecraft

# Environment-Variable für Paper-Version
ENV PAPER_VERSION=latest

# EULA akzeptieren
ENV EULA=TRUE

# Kopiere Startscript
COPY start.sh /minecraft/start.sh
RUN chmod +x /minecraft/start.sh

# Expose Standard-Minecraft-Port
EXPOSE 25565

# Startbefehl
CMD ["/minecraft/start.sh"]
