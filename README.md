> [!NOTE]
> **KI-Hinweis:** Dieses Projekt wurde vollständig mit KI-Agenten erstellt (Proof of Concept / „vibe-coded“). Keine Gewähr für Sicherheit, Vollständigkeit oder Verfügbarkeit.

# Trainingsapp

Gesamt-Repository der Trainingsapp (Intervalltimer, Passkey-Authentifizierung, Kraft- & Calisthenics-Workout-Tracking, Sichtbarkeit/Einladungen und DSGVO-Funktionen).

## Struktur & Branches

- **`gemini` (aktueller Entwicklungsstand):** Vollständige Neuentwicklung aller Muss-Kriterien mit Google Antigravity / Gemini-Agenten auf Basis offizieller Standard-Packages (Quarkus `3.40.1.2`, React 19, `@mui/material` M3 Expressive, `react-router`, `openapi-typescript`/`openapi-fetch`), inkl. gemeinsamem Helm-Chart (`chart/`) und GitHub Action (`.github/workflows/build.yml`).
- **`main`:** Früherer OpenCode-Prototyp (Passkeys + Timer).
- **Submodule:**
  - `server/` – [TrainingsappServer](https://github.com/leon345/TrainingsappServer) (Quarkus, Java 21, PostgreSQL/Flyway, WebAuthn)
  - `client/` – [TrainingsappClient](https://github.com/leon345/TrainingsappClient) (React 19, TypeScript, Vite, PWA)

## Lokal starten

```bash
# 1. Server (Port 8080, startet PostgreSQL via Docker Dev Services)
cd server && mvn quarkus:dev

# 2. Client (Port 5173, Proxy /v1 -> Port 8080)
cd client && npm ci && npm run dev
```

Anschließend `http://localhost:5173` im Browser öffnen. Weitere Details stehen in [TODO.md](TODO.md), [tasks-gemini/ARCHITEKTUR.md](tasks-gemini/ARCHITEKTUR.md) und `server/docs/prototyp-lokal.md`.
