FROM debian:13-slim

ARG VELOCITY_VERSION=3.6.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-21-jdk-headless curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /velocity

# Velocity JAR via PaperMC API herunterladen
RUN echo "Downloading Velocity version ${VELOCITY_VERSION}..." && \
    BUILD=$(curl -fsSL https://api.papermc.io/v2/projects/velocity/versions/${VELOCITY_VERSION} | jq -r '.builds[-1]') && \
    curl -fsSL -o velocity.jar https://api.papermc.io/v2/projects/velocity/versions/${VELOCITY_VERSION}/builds/${BUILD}/downloads/velocity-${VELOCITY_VERSION}-${BUILD}.jar

COPY start.sh /velocity/start.sh
RUN chmod +x /velocity/start.sh

ENV JAVA_XMS=512M
ENV JAVA_XMX=1G
ENV JAVA_OPTS=""

CMD ["/velocity/start.sh"]
