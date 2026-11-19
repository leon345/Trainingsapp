# TODO – Trainingsapp (Gemini-Neuentwicklung)

> **Hinweis zum Altbestand:** Der frühere OpenCode-Prototyp liegt unverändert auf `main` bzw. `integration/server` (Server/Client) sowie im Verzeichnis `tasks/`. Auf dem Branch `gemini` erfolgt eine frische, saubere Neuentwicklung aller Muss-Kriterien auf Basis offizieller Standard-Packages.

Verbindliche Architektur- und Regel-Referenz: [tasks-gemini/ARCHITEKTUR.md](tasks-gemini/ARCHITEKTUR.md)  
Projektregeln & Rollen: [AGENTS.md](AGENTS.md)  
Historische Beschlüsse & Nutzerentscheide A–J: [tasks/ENTSCHEIDUNGEN.md](tasks/ENTSCHEIDUNGEN.md)

Status-Werte: `offen`, `in Arbeit`, `umgesetzt und geprüft`, `blockiert`, `erledigt`.

---

## Verbindliche Leitregel (19.11.2026)

- **Standard-Packages vor Eigenentwicklung:** Für alles außerhalb der eigentlichen Business-Logik (Infrastruktur, Security-Plumbing, Transaktionen, Rate-Limiting, UI-Bibliothek, Routing, API-Client) werden vorrangig offizielle Framework-Bordmittel und Standard-Packages genutzt. Jede geplante Eigenentwicklung außerhalb der Business-Logik **MUSS** vor der Umsetzung dem Nutzer vorgestellt und freigegeben werden.

---

## Wellenplan (Wellen 1–5)

1. **Welle 1 – Grundgerüste (parallel):**
   - `GS-01` (Server-Grundgerüst, Quarkus 3.40.1.2, DDD/ArchUnit, PostgreSQL/Flyway, OpenAPI, Health, Security-Header-Bordmittel) — **`erledigt`** (Fast-Forward in `server` `gemini` `2667e8e`, 15/15 Tests grün)
   - `GC-01` (Client-Grundgerüst, React 19, Vite, PWA, MUI + Material-3-Expressive-Theme, `react-router`, `openapi-typescript`/`openapi-fetch`, Vitest & Playwright) — **`in Arbeit`**
2. **Welle 2 – Authentifizierung/RBAC (Server) & Timer/Phasensignale (Client) (parallel):**
   - `GS-02` (Passkeys via `quarkus-security-webauthn`, dünner Auth-Port, RBAC/ABAC mit `@PermissionsAllowed` + `@PermissionChecker`, `@RateLimit`) — **`in Arbeit`** (nach `GS-01`)
   - `GC-02` (Intervalltimer mit Zeitstempel-Berechnung & Phasensignalen Ton/Vibration/aria-live) — **`offen`** (nach `GC-01`)
3. **Welle 3 – Timer-Sync-API, Workout-Tracking & Import-Port (Server):**
   - `GS-03` (`GET`/`PUT /v1/timer/einstellung`, Kraft- & Calisthenics-Workouts, interner Port `WorkoutImport`) — **`offen`** (nach `GS-02`)
4. **Welle 4 – Sichtbarkeit/DSGVO/Aufräumjob (Server) & Passkey-UI/Timer-Sync (Client) (parallel):**
   - `GS-04` (Workout-Sichtbarkeit, Einladungen, Profile, DSGVO-Export & -Löschung, `quarkus-scheduler`-Aufräumjob) — **`offen`** (nach `GS-03`)
   - `GC-03` (Passkey-Registrierung/Anmeldung/Verwaltung & Server-Timer-Sync + Fullstack-E2E) — **`offen`** (nach `GC-02`, `GS-02`, `GS-03`)
5. **Welle 5 – Workout-UI, Sichtbarkeit/DSGVO-UI, Sicherheitstests & Gesamtabnahme:**
   - `GS-05` (Vollständige Security-/IDOR-/ArchUnit-Testsuite, 401/404-Tabellen, DSGVO-/Betriebs-Doku & Smoke-Check) — **`offen`** (nach `GS-04`)
   - `GC-04` (Workout- & Calisthenics-Tracking-UI + Fullstack-E2E) — **`offen`** (nach `GC-03`, `GS-03`)
   - `GC-05` (Sichtbarkeit/Einladungen/Profile-UI, DSGVO-Export/Löschung/PoC-Hinweis, Cross-Browser- & Fullstack-E2E-Abnahme) — **`offen`** (nach `GC-04`, `GS-04`)

---

## Task-Tabelle (`GS-01`–`GS-05`, `GC-01`–`GC-05`)

| ID | Titel | Repo | Status | Abhängigkeiten | Branch / Worktree | Task-Datei |
|---|---|---|---|---|---|---|
| `GS-01` | Server-Grundgerüst (Quarkus 3.40.1.2, DDD/ArchUnit, PostgreSQL/Flyway, OpenAPI, Bordmittel) | `server` | `erledigt` | – | `gemini-task/GS-01-server-grundgeruest` / `.worktrees/gemini-GS-01` (`2667e8e`, in `gemini`) | [GS-01](tasks-gemini/GS-01-server-grundgeruest.md) |
| `GS-02` | Passkeys (`quarkus-security-webauthn`), Auth-Port, RBAC/ABAC & `@RateLimit` | `server` | `in Arbeit` | `GS-01` | `gemini-task/GS-02-passkeys-rbac-abac` / `.worktrees/gemini-GS-02` | [GS-02](tasks-gemini/GS-02-passkeys-rbac-abac.md) |
| `GS-03` | Timer-API, Workout-/Calisthenics-Tracking & `WorkoutImport`-Port | `server` | `offen` | `GS-02` | `gemini-task/GS-03-timer-workouts-import` / `.worktrees/gemini-GS-03` | [GS-03](tasks-gemini/GS-03-timer-workouts-import.md) |
| `GS-04` | Workout-Sichtbarkeit, Einladungen, DSGVO-Export/Löschung & `quarkus-scheduler`-Aufräumjob | `server` | `offen` | `GS-03` | `gemini-task/GS-04-sichtbarkeit-dsgvo-aufraeumen` / `.worktrees/gemini-GS-04` | [GS-04](tasks-gemini/GS-04-sichtbarkeit-dsgvo-aufraeumen.md) |
| `GS-05` | Sicherheits-/Härtungstests, ArchUnit-Abnahme, DSGVO-/Betriebsdoku & Smoke-Check | `server` | `offen` | `GS-04` | `gemini-task/GS-05-sicherheitstests-doku` / `.worktrees/gemini-GS-05` | [GS-05](tasks-gemini/GS-05-sicherheitstests-doku.md) |
| `GC-01` | Client-Grundgerüst (React 19, Vite, PWA, MUI M3 Expressive, `react-router`, `openapi-fetch`, Tests) | `client` | `in Arbeit` | – | `gemini-task/GC-01-client-grundgeruest` / `.worktrees/gemini-GC-01` | [GC-01](tasks-gemini/GC-01-client-grundgeruest-design.md) |
| `GC-02` | Intervalltimer & Phasensignale (Ton, Vibration, `aria-live`, Zeitstempel) | `client` | `offen` | `GC-01` | `gemini-task/GC-02-timer-phasensignale` / `.worktrees/gemini-GC-02` | [GC-02](tasks-gemini/GC-02-timer-phasensignale.md) |
| `GC-03` | Passkey-UI, Passkey-Verwaltung & Server-Timer-Sync (+ Fullstack-E2E) | `client` | `offen` | `GC-02`, `GS-02`, `GS-03` | `gemini-task/GC-03-passkey-ui-timer-sync` / `.worktrees/gemini-GC-03` | [GC-03](tasks-gemini/GC-03-passkey-ui-timer-sync.md) |
| `GC-04` | Workout- & Calisthenics-Tracking-UI (+ Fullstack-E2E) | `client` | `offen` | `GC-03`, `GS-03` | `gemini-task/GC-04-workout-tracking-ui` / `.worktrees/gemini-GC-04` | [GC-04](tasks-gemini/GC-04-workout-tracking-ui.md) |
| `GC-05` | Sichtbarkeit, Einladungen, Profile, DSGVO-UI, PoC-Hinweis & Gesamtabnahme | `client` | `offen` | `GC-04`, `GS-04` | `gemini-task/GC-05-sichtbarkeit-dsgvo-ui-e2e` / `.worktrees/gemini-GC-05` | [GC-05](tasks-gemini/GC-05-sichtbarkeit-dsgvo-ui-e2e.md) |

### Nicht umgesetzter Wunsch-/Alt-Scope (Nutzerentscheide A, B, G, I)
- Zurückgestellt bzw. abgewählt: `S-09`/`C-12` (Schwimm-Workouts), `S-10`/`C-13` (Apple Health Adapter/Plugin), `S-11` (Mitnutzer-Rechte), `S-15` (Registrierungscode/`max-benutzer`), `C-10` (Desktop-Tastenkürzel/Shneiderman), `C-11` (Capacitor), `C-15` (Native Passkeys).

---

## Aktueller Git-Stand (Branch `gemini`)

- **Root (`/home/user/trainingsapp`):** Branch `gemini` (Basis `c608b66`, wird laufend aktualisiert). `main` bleibt auf `9be040d`.
- **Server (`server/`):**
  - Branch `gemini`: `2667e8e` (`docs: API-Konventionen und Build-/Test-Hinweise ergaenzen` — enthält `GS-01` per Fast-Forward).
  - Worktree `.worktrees/gemini-GS-01`: Branch `gemini-task/GS-01-server-grundgeruest` auf `2667e8e` (`GS-01` erledigt, 15/15 Tests grün inkl. PostgreSQL Dev Services, Flyway V1, ArchUnit 6/6, OpenAPI-Artefakt).
  - Worktree `.worktrees/gemini-GS-02`: Branch `gemini-task/GS-02-passkeys-rbac-abac` auf `2667e8e` (`GS-02` in Arbeit).
  - Altbestand: `main` (`e65d322`), `integration/server` (`9535788`) unverändert.
- **Client (`client/`):**
  - Branch `gemini`: `09b600e` (`chore: Deployment-Dateien (Dockerfile, nginx, Helm-Chart, Workflow) aus main uebernehmen`).
  - Worktree `.worktrees/gemini-GC-01`: Branch `gemini-task/GC-01-client-grundgeruest` auf `a3632e3` (`feat(app): Anwendungsrahmen mit react-router, MUI-Navigation und persistentem Timer-Bereich`, in Arbeit).
  - Altbestand: `main` (`149134c`) und alte `task/*`-Worktrees unverändert.

---

## Parallelitätsregeln (zwingend beachten)

- **Client / Playwright:** Nie zwei Client-Worker gleichzeitig Playwright ausführen lassen (feste Preview-Ports `4173`/`4174`, `reuseExistingServer`).
- **Server / Maven:** Nie zwei Maven-Läufe im Server-Repo gleichzeitig ausführen (fester Testport `8081`).
- **Datenbank-Tests (Server):** Immer mit PostgreSQL/Dev Services ausführen (`-Ddatenbank.tests=aus` ist für Abnahmen verboten).
