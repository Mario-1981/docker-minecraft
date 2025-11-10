# 🪄 Minecraft Server – PaperMC, Folia & Velocity (Docker + Swarm)

Dieses Projekt enthält vollständig containerisierte Minecraft-Server-Images für:

- **PaperMC** – performanter Spigot-Fork für Vanilla-Server  
- **Folia** – experimenteller Multi-Threaded-Fork von Paper  
- **Velocity** – moderner Proxy für mehrere Minecraft-Server  

Alle Images basieren auf **Debian 13 (Trixie)** und **OpenJDK 21**,  
sind **GlusterFS-kompatibel**, **EULA-konform** und unterstützen  
**Docker Compose** & **Docker Swarm** Deployments.

---

## 📂 Projektstruktur

```bash
docker-minecraft/
├── paper/
│   ├── Dockerfile
│   └── start.sh
├── folia/
│   ├── Dockerfile
│   └── start.sh
├── velocity/
│   ├── Dockerfile
│   └── start.sh
├── docker-compose.yml.example          
└── docker-stack.yml.example             # für Docker Swarm Deployments
```

---

## ⚙️ Features

✅ EULA-Akzeptanz über Environment-Variable  
✅ Java-Konfiguration über `JAVA_XMS`, `JAVA_XMX`, `JAVA_OPTS`  
✅ Kompatibel mit Host-Mounts / GlusterFS  
✅ Automatischer Download der passenden JAR-Dateien beim Build  
✅ Restart-Policies  
✅ Swarm-fähiges Overlay-Netzwerk  

---

## 🧰 Build der Images

### PaperMC
```bash
docker build --build-arg PAPER_VERSION=1.21.8   -t ghcr.io/<USERNAME>/minecraft-paper:1.21.8   -f paper/Dockerfile .
```

### Folia
```bash
docker build --build-arg FOLIA_VERSION=1.21.8   -t ghcr.io/<USERNAME>/minecraft-folia:1.21.8   -f folia/Dockerfile .
```

### Velocity
```bash
docker build --build-arg VELOCITY_VERSION=3.6.1   -t ghcr.io/<USERNAME>/velocity:3.6.1   -f velocity/Dockerfile .
```

Optional zusätzlich taggen als `latest`:
```bash
docker tag ghcr.io/<USERNAME>/minecraft-paper:1.21.8 ghcr.io/<USERNAME>/minecraft-paper:latest
```

---

## 🚀 Docker Compose (lokaler Test)

```bash
docker-compose up -d
```

Standardports:
- **PaperMC:** 25565  
- **Folia:** 25566  
- **Velocity:** 25577  

EULA muss per ENV gesetzt werden (`EULA=TRUE`).

Logs ansehen:
```bash
docker-compose logs -f paper
```

---

## 🐳 Docker Swarm Deployment

### 1️⃣ Overlay-Netzwerk anlegen
```bash
docker network create --driver overlay minecraft
```

### 2️⃣ Stack deployen
```bash
docker stack deploy -c docker-stack.yml minecraft
```

### 3️⃣ Logs prüfen
```bash
docker service ls
docker service logs -f minecraft_paper
```

### 4️⃣ Stack entfernen
```bash
docker stack rm minecraft
```

---

## ⚙️ Umgebungsvariablen

| Variable | Beschreibung | Beispiel |
|-----------|---------------|----------|
| `EULA` | Muss `TRUE` sein, um Mojangs EULA zu akzeptieren | `EULA=TRUE` |
| `JAVA_XMS` | Initiale Speichergröße | `1G` |
| `JAVA_XMX` | Maximale Speichergröße | `2G` |
| `JAVA_OPTS` | Zusätzliche Java-Parameter | `-XX:+UseG1GC -XX:+ParallelRefProcEnabled` |

---

## 🧠 Hinweise

- Die Serverdateien werden im Container unter `/minecraft` (bzw. `/velocity`) gespeichert.  
- Verwende **Host-Verzeichnisse oder GlusterFS**, um persistente Weltdaten zu speichern.  
- Setze `PUID` und `PGID`, falls du den Container nicht als Root laufen lassen möchtest.  

---

## 🕹️ Beispiel: Verbindung zum Server

- Velocity Proxy: `minecraft.example.com:25577`  
- Paper/Folia Backend: Intern erreichbar über `paper:25565` im Overlay-Netzwerk.

---

## ❤️ Mitwirken

Fehler, Vorschläge oder neue Features?  
Erstelle bitte ein [Issue](../../issues) oder sende einen Pull Request.

---

## 📜 Lizenz

Dieses Projekt verwendet die offiziellen PaperMC-, Folia- und Velocity-APIs  
unter ihren jeweiligen Lizenzen.  
Die Dockerfiles und Skripte selbst stehen unter der **MIT License**.

---

> 🧩 *"One container to craft them all."*  
> — Maintained by [@Mario-1981](https://github.com/Mario-1981)
