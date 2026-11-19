# Trainingsapp – Projektregeln & Agenten-Anweisungen (Antigravity)

Diese Datei übernimmt die bisherigen OpenCode-Regeln (`.opencode/agents/*` und `opencode.jsonc`) für Google Antigravity (`agy`) und passt Rollen sowie KI-Modelle an Antigravity an.

---

## 1. Projektstruktur & verbindliche Quellen

- Dieser Wurzelordner (`/home/user/trainingsapp`) ist das Gesamt-Git-Repository (Arbeitsbranch: `gemini`) mit den Git-Submodulen `server/` und `client/` (ebenfalls Arbeitsbranch `gemini`; der frühere OpenCode-Stand liegt unverändert auf `main` bzw. `integration/server`).
  - **Server (`server/`):** Quarkus 3.40.1.2 (Java 21, Maven), Layered Architecture / DDD (`domain`, `application`, `infrastructure`, `api.v1`), PostgreSQL + Hibernate ORM Panache + Flyway, `quarkus-security-webauthn`, `quarkus-smallrye-fault-tolerance`, OpenAPI unter `/v1`.
  - **Client (`client/`):** React 19, TypeScript, Vite, PWA (`vite-plugin-pwa`), `@mui/material` mit Material-3-Expressive-Theme (`@material/material-color-utilities`, `@fontsource-variable/roboto`), `react-router`, `openapi-typescript` + `openapi-fetch`, Vitest & Playwright.
- **Verbindliche Referenzen** (vor jeder Umsetzung prüfen):
  - `TODO.md` – Gesamtübersicht, Wellenplan 1–5, Task-Tabelle (`GS-01`–`GS-05`, `GC-01`–`GC-05`), Git-Stand
  - `tasks-gemini/ARCHITEKTUR.md` – Verbindliche Gemini-Architektur inkl. übernommener Nutzerentscheide (`A`–`J`) und Standard-Package-Vorgaben
  - `tasks-gemini/<ID>-*.md` – Konkrete Zielbeschreibung und Abnahmekriterien je Task
  - `tasks/ENTSCHEIDUNGEN.md` – Historische Beschlüsse (`E1`–`E33`) und Nutzerentscheide (`A`–`J`) als Hintergrundreferenz
  - `server/docs/api-konventionen.md` – Schichten, OpenAPI- und Fehlerformat-Regeln (`FehlerV1`)
  - `client/docs/design-tokens.md` – Material-3-Expressive-Theme und Design-Vorgaben

---

## 2. Entwicklungs- und Qualitätsregeln

Übernommen aus `.opencode/agents/AGENTS.md` und den Projektkonventionen:

0. **Standard-Packages vor Eigenentwicklung (verbindlich):** Für alles außerhalb der eigentlichen Business-Logik (Infrastruktur, Security-Plumbing, Transaktionen, Rate-Limiting, UI-Bibliothek, Routing, API-Client) werden vorrangig offizielle Framework-Bordmittel und Standard-Packages genutzt. Jede geplante Eigenentwicklung außerhalb der Business-Logik **MUSS** vor der Umsetzung dem Nutzer vorgestellt und freigegeben werden.
1. **Keine ungenehmigten Abhängigkeiten** außerhalb der in `tasks-gemini/ARCHITEKTUR.md` festgelegten Standard-Packages ohne vorherige Rückfrage beim Nutzer/Orchestrator.
2. **Vor einem neuen Helper per Suche prüfen**, ob es bereits eine passende Funktion im Code gibt.
3. **Keine Abstraktion für nur einen Aufrufer.**
4. **Tests prüfen Verhalten, nicht die Implementierung.**
5. **Abnahmekriterium:** Ein Task gilt erst als fertig, wenn alle zugehörigen Tests/Prüfungen grün sind (und – sofern vorhanden – `scripts/verify/<ID>.sh` Exit 0 liefert).
6. **Zeitdauern** projektweit als ganze Sekunden (`integer`), Einheit im Feldnamen (`trainingSekunden`, `pauseSekunden`, `dauerSekunden`), kein ISO-8601 (`E11`, `E21`).
7. **Client-Vorgaben:** Keine fremden CDNs (Schriften via `@fontsource-variable/roboto` und Icons via `@mui/icons-material` selbst gehostet), `@mui/material` mit Material-3-Expressive-Theme (kein `@material/web`, kein eigener 12-Komponenten-UI-Bau), `react-router` (`BrowserRouter`), `openapi-typescript` + `openapi-fetch`, visuelle Playwright-Tests nur in Chromium (`Nutzerentscheid C`), funktionale E2E-Tests in allen 4 Browser-Projekten gegen den Produktions-Build (`E24`).
8. **Server-Vorgaben:** Datenbank-Tests sind Pflicht – `-Ddatenbank.tests=aus` darf für Abnahmen nicht genutzt werden (`E19`). Transaktionen direkt über `@Transactional` (`jakarta.transaction.Transactional`) in `application`. Security-Header über `quarkus.http.header.*`, Rate-Limiting über `@RateLimit` (`quarkus-smallrye-fault-tolerance`), `/q/*`-Schutz über Quarkus-Bordmittel. ArchUnit erzwingt: `domain` 100 % framework-frei; kein JPA, `io.vertx`, `io.quarkus.security.webauthn` oder `SecurityIdentity` in `application` und `api.v1`.
9. **Kein Scope-Creep:** Zurückgestellte (`C-11`, `C-13`, `C-15`, `S-10`) und abgewählte Wunsch-Tasks (`S-09`, `S-11`, `C-10`, `C-12`, `S-15`) nicht eigenmächtig umsetzen (`Nutzerentscheide A, B, G, I`).

---

## 3. Sicherheits- und Schutzregeln

Übernommen aus `opencode.jsonc` (gelten für Hauptagent und alle Subagents):

- **Verboten (nicht ausführen):**
  - Dateien/Ordner zerstörerisch löschen: `rm`, `rmdir`, `find ... -delete`, `shred`, `dd`, `mkfs`, `sudo`
  - Destruktive Git-Befehle: `git clean`, `git reset --hard`, `git push --force`, `git push -f`, `git push --delete`, `git branch -D`, `git worktree remove --force`
  - Destruktive DB-/Docker-Befehle: `DROP`, `TRUNCATE`, `dropdb`, `schema:drop`, `schema:fresh`, `docker volume rm`, `docker system prune`
- **Nur nach ausdrücklicher Freigabe durch den Nutzer:**
  - `git push`
- **Nicht bearbeiten:**
  - `.git/*`
  - `opencode.jsonc` und `.opencode/*` (Altbestand nur als Referenz lesen)
- **Workspace-Grenze:** Keine Schreibzugriffe außerhalb von `/home/user/trainingsapp` ohne expliziten Auftrag.
- **Unnötige Dateien aufräumen:** Da `rm` vermieden wird, keine Wegwerf-Dateien in produktiven Worktrees/Branches liegen lassen; falls doch etwas anfällt, in `TODO.md` unter „Aufräumen durch den Nutzer“ notieren.

---

## 4. Rollen, Orchestrierung & Parallelität

### Hauptagent (Orchestrator)
- Plant und verteilt Aufgaben, hält den eigenen Kontext klein und startet bis zu **drei parallele Worker** für unabhängige Tasks (über `invoke_subagent` oder `swarm`).
- Anders als im alten OpenCode-Setup darf der Orchestrator in Antigravity **selbst Shell-Befehle ausführen** (z. B. Statusprüfungen, Tests, Builds, gezielte Koordination), delegiert aber umfangreiche Task-Umsetzungen an Worker.
- Trifft bei offenen **Architekturentscheidungen** keine Alleingänge: Fragt immer zuerst den Nutzer – und klärt, ob ggf. eine Council-Runde gewünscht ist.

### Worker (Task-Umsetzung)
- Setzt **genau einen Task** um (`GS-01`..`GS-05` bzw. `GC-01`..`GC-05`).
- Arbeitet nach dem Gemini-Worktree-Schema: Basis-Branch ist `gemini`, Feature-Branches heißen `gemini-task/<ID>-<slug>`, Worktrees liegen unter `.worktrees/gemini-<ID>` (`git worktree add`).
- Committet in kleinen, nachvollziehbaren Schritten.
- Meldet Unklarheiten sowie jede geplante Eigenentwicklung außerhalb der Business-Logik vorab an den Orchestrator/Nutzer und trifft keine eigenen Architekturentscheidungen.

### Todo-Manager
- Pflegt `TODO.md` und `tasks-gemini/*.md` (jeder Task hat ID, Repo, Ziel, Abhängigkeiten, Branch/Worktree, Abnahmekriterien und Status).
- Prüft den tatsächlichen Git-Stand von Root, `server/` und `client/` gegen `TODO.md` und meldet Abweichungen.

### Council (nur nach ausdrücklicher Freigabe des Nutzers)
Hinweis: Laut `Nutzerentscheid H` finden **keine automatischen Council-Runden** statt. Falls der Nutzer ein Council anfordert:
- Fünf unabhängige Berater liefern knapp Wahl, 3 Gründe und größtes Risiko aus ihrer Perspektive:
  1. `council-1`: Sicherheit und Datenschutz
  2. `council-2`: Wartbarkeit und Testbarkeit
  3. `council-3`: Einfachheit und geringster Aufwand
  4. `council-4`: Performance und Betrieb
  5. `council-5`: Nutzerperspektive und Usability
- Danach bewertet `council-chair` alle fünf Antworten ohne Namen nach Praktikabilität, Langlebigkeit und Projektziel, begründet die Entscheidung und nennt abweichende Meinungen.

### Parallelitätsregeln (zwingend beachten)
- **Client / Playwright:** Nie zwei Client-Worker gleichzeitig Playwright ausführen lassen (feste Ports `4173`/`4174`, `reuseExistingServer`).
- **Server / Maven:** Nie zwei Maven-Läufe im Server-Repo gleichzeitig ausführen (fester Testport `8081`).

---

## 5. KI-Modell-Zuordnung (Antigravity)

Die früheren OpenCode-Modelle (`anthropic/claude-fable-5-2#high`, `anthropic/claude-haiku-5-5`) existieren in Antigravity nicht unter diesen Namen. Es gelten folgende Zuordnungen:

| Rolle | Alt (OpenCode) | `invoke_subagent` (`Model`) | Swarm / CLI (`agy --model`) |
| --- | --- | --- | --- |
| **Orchestrator (Hauptagent)** | `claude-fable-5-2#high` | Sitzungsmodell | `gemini-4-neon-high` *(oder `claude-opus-5-5-high`)* |
| **Worker (Implementierung)** | `claude-opus-5-5#medium` | `inherit` *(oder `pro`)* | `claude-opus-5-5-medium` *(oder `claude-sonnet-5-5-medium` / `gemini-4-neon-medium`)* |
| **Council-Vorsitz (`council-chair`)** | `claude-opus-5-5#medium` | `inherit` *(oder `pro`)* | `claude-opus-5-5-medium` |
| **Todo-Manager** | `claude-haiku-5-5` | `flash` | `gemini-3.8-flash-medium` |
| **Council-Berater (`council-1`..`5`)** | `claude-haiku-5-5` | `flash` | `gemini-3.8-flash-medium` |

*(Standardmäßig erben Subagents das Sitzungsmodell via `inherit`, außer für leichte Verwaltungs-/Beratungsrollen wie `todo-manager` oder `council-1..5`, für die `flash` vorgesehen ist.)*
