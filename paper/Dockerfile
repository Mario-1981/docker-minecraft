FROM debian:13

# PaperMC Version beim Build festlegen
ARG PAPER_VERSION=1.21.8

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /minecraft

# Paper JAR beim Build herunterladen
RUN echo "Downloading PaperMC version ${PAPER_VERSION}..." && \
    BUILD=$(curl -fsSL https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION} | jq -r '.builds[-1]') && \
    curl -fsSL -o paper.jar https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${BUILD}/downloads/paper-${PAPER_VERSION}-${BUILD}.jar

# Startscript kopieren
COPY start.sh /minecraft/start.sh
RUN chmod +x /minecraft/start.sh

EXPOSE 25565

CMD ["/minecraft/start.sh"]
