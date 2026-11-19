# Gemini-Architektur – Trainingsapp (Muss-Kriterien)

Stand: 19.11.2026 | Gültig für Branch `gemini` in `/home/user/trainingsapp`, `server/` und `client/`.  
Der frühere OpenCode-Stand liegt unverändert auf `main` bzw. `integration/server` sowie im Verzeichnis `tasks/` (Altbestand nicht löschen).

---

## 1. Verbindliche Leitregel & übernommene Nutzerentscheide (A–J)

### Verbindliche neue Grundregel
- **Standard-Packages vor Eigenentwicklung:** Für alles außerhalb der eigentlichen Business-Logik (Infrastruktur, Security-Plumbing, Transaktionen, Rate-Limiting, UI-Bibliothek, Routing, API-Client) werden vorrangig offizielle Framework-Bordmittel und Standard-Packages genutzt. **Jede geplante Eigenentwicklung außerhalb der Business-Logik MUSS vor der Umsetzung dem Nutzer vorgestellt und freigegeben werden.**

### Übernommene Nutzerentscheide (A–J)
- **Entscheid A (Auth-Erweiterbarkeit):** Vorerst keine native App, aber der Auth-Service nutzt einen dünnen Port (`Anmeldesitzung`) für spätere Native-/Token-Erweiterbarkeit.
- **Entscheid B (Erweiterungsschnittstelle):** Kein Apple Health in diesem Scope, aber ein interner Server-Port `application.erweiterung.WorkoutImport` (`herkunft`, `externeId`, idempotentes Upsert, immer `PRIVAT`).
- **Entscheid C (Visuelle Tests):** Visuelle Playwright-Tests (Screenshot-Vergleiche) laufen **nur in Chromium** gegen den Test-Build (`vite build --mode test` mit `galerie.html`). Funktionale E2E-Tests laufen in **allen 4 Browser-Projekten** (`chromium`, `firefox`, `webkit`, `mobile`) gegen den Produktions-Build (`vite preview`).
- **Entscheid D (Worker-Resilienz):** Klare Task-Abgrenzung und kleine Commits in eigenen Worktrees.
- **Entscheid E (Hosting, DB, TLS):** Hosting durch den Nutzer in Deutschland bei Strato; PostgreSQL-Datenbank und TLS-Zertifikate werden durch den Nutzer betrieben (erfüllt EU-Hosting nach E7).
- **Entscheid F (Manifeste & Artefakte):** Kubernetes-Manifeste, Container-Deployment und Betrieb liegen beim Nutzer. Im Client-Repo bleiben die aus `main` übernommenen Deployment-Dateien (`Dockerfile`, `nginx.conf`, `chart/`, `.github/workflows/build.yml`) kompatibel gepflegt.
- **Entscheid G (Offene Registrierung):** Offene Registrierung ohne Registrierungscode und ohne `max-benutzer`-Obergrenze (`S-15` entfällt). Rate-Limits je IP auf Auth-Endpunkten bleiben wirksam; PoC-Hinweis bleibt im Client sichtbar.
- **Entscheid H (Kein automatisches Council):** Keine automatischen Council-Runden; die Nutzerentscheide und geklärten Architekturvorgaben gelten unmittelbar.
- **Entscheid I (Nur Muss-Kriterien):** Wunsch-Tasks (`S-09`, `S-10`, `S-11`, `C-10`, `C-11`, `C-12`, `C-13`, `C-15`) werden **nicht** umgesetzt.
- **Entscheid J (Frische Neuentwicklung auf `gemini`):** Vollständige, saubere Umsetzung aller Muss-Kriterien für Server (`GS-01`–`GS-05`) und Client (`GC-01`–`GC-05`) auf Basis offizieller Standard-Packages.
- **Phasensignale (Antwort 16 / E33):** Ton (Web Audio Sinus-Oszillator, ohne externe Audiodateien) und Vibration (`navigator.vibrate`, Feature-Detection) beim Phasenwechsel, dazu sichtbares `aria-live="polite"`-Signal und zwei getrennte Schalter.
- **Aufräumjob (Antwort 18 / E32):** Täglicher `quarkus-scheduler`-Job löscht abgelaufene ausstehende Registrierungen (TTL 10 Min.) und Konten ohne Passkey nach 14 Tagen; inaktive Konten mit Passkey werden **nicht** gelöscht.

---

## 2. Server-Architektur (`server/`)

### Technologie-Stack
- **Framework:** Quarkus `3.40.1.2` (LTS), Java 21, Maven
- **Persistenz:** PostgreSQL + Hibernate ORM Panache + Flyway (ab `V1`, unveränderlich nach Merge) + Dev Services in `%dev`/`%test`
- **Datenbank-Tests:** Pflicht (`-Ddatenbank.tests=aus` darf für keine Abnahme genutzt werden; E19).

### DDD & Layered Architecture (`domain`, `application`, `infrastructure`, `api.v1`)
Die Schichtentrennung wird durch **ArchUnit** erzwungen:
1. `domain`: **100 % framework-frei.** Fachliche Entitäten, Value Objects (`BenutzerId` UUID / 16-Byte User-Handle, `Benutzername`, `IntervallEinstellung`, `Workout`, `Uebung`, `Satz`, `Herkunft`, `Sichtbarkeit`), Domain-Services (`ZugriffsPolicy`) und Repository-Interfaces/Ports. **Kein** JPA, JAX-RS, Vert.x, `jakarta.transaction`, WebAuthn oder `SecurityIdentity`.
2. `application`: Use-Cases und Application-Ports (`Anmeldesitzung`, `PasskeyZeremonie`, `Uhr`, `WorkoutImport`). Darf Jakarta CDI und `@Transactional` (`jakarta.transaction.Transactional`) direkt nutzen (kein eigener `Transaktion`-Port-Wrapper). **Kein** JPA, Vert.x, WebAuthn oder `SecurityIdentity`.
3. `infrastructure`: Panache-Repositories & JPA-Entities (Mapping auf Domain-Objekte), Flyway-Migrationen, `quarkus-security-webauthn` (`WebAuthnSecurity`, `WebAuthnUserProvider`) hinter dünnem Auth-Port, `@PermissionChecker` (`@Blocking`) auf Basis von `ZugriffsPolicy`, `quarkus-scheduler` für den täglichen Aufräumjob.
4. `api.v1`: Versionierte REST-Ressourcen unter `/v1/*`, DTOs (`*V1`, `FehlerV1`), Jakarta REST / MicroProfile OpenAPI / Bean Validation / Quarkus-Security-Annotationen (`@Authenticated`, `@RolesAllowed`, `@PermissionsAllowed`) sowie `@RateLimit` (`quarkus-smallrye-fault-tolerance`). **Kein** JPA, Vert.x, WebAuthn oder `SecurityIdentity`.

### Standard-Quarkus Infrastruktur, Security & Betrieb
- **Transaktionen:** Direkt `@Transactional` (`jakarta.transaction.Transactional`) in `application`.
- **HTTP Security-Header:** Über `quarkus.http.header.*` in `application.properties` (`X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `CSP`), **kein** eigener Vert.x-Header-Filter.
- **OpenAPI & `/q/*`-Schutz in `%prod`:** Über Quarkus-Bordmittel (`%prod.quarkus.smallrye-openapi.enable=false`, `%prod.quarkus.swagger-ui.enable=false`, `quarkus.management.enabled=true` für `/q/health/live` und `/q/health/ready` auf eigenem Management-Port). OpenAPI-Schema für `/v1` wird beim Build exportiert (`store-schema-directory`). **Ausdrücklich vom Nutzer freigegebene Sonderlösung (19.11.2026):** Minimaler Vert.x-`@RouteFilter` (~10 Zeilen in `infrastructure.passkey`), um `/q/webauthn/*` sauber mit `404` (ohne Body und ohne `Set-Cookie`) zu sperren. Bei jeder ggf. weiteren Sonderlösung erst dem Nutzer vorstellen!
- **Passkeys & Auth:** `quarkus-security-webauthn` (`WebAuthnSecurity`, `WebAuthnUserProvider`) + dünner Auth-Port für spätere Native-Erweiterbarkeit (Nutzerentscheid A); eigene `/v1`-Endpunkte für Registrierung, Anmeldung, Abmeldung und Multi-Passkey-Verwaltung (`bezeichnung`, `erstelltAm`, `zuletztVerwendetAm`, `PATCH /v1/passkeys/{id}`, Löschen außer letztem Passkey). **Nutzerentscheid zu `HttpOnly` bei `quarkus-security-webauthn:3.40.1.2` (19.11.2026):** Bewusst **keine** Eigenentwicklung (kein eigener Cookie-Patch-Filter); fehlendes `HttpOnly` wird als bekannte Quarkus-3.40.1.2-Limitierung dokumentiert (kompensiert durch `SameSite=Strict`, `Secure` in Prod via `proxy-address-forwarding=true` und strikte CSP `default-src 'self'`). **Nutzerentscheid zu EdDSA (`quarkus-security-webauthn:3.40.1.2` / `webauthn4j-core:0.30.3.RELEASE`, 19.11.2026):** Bewusst **kein** Workaround für den Upstream-Bug (`EdDSACOSEKey.create` prüft Referenzgleichheit gegen `COSEAlgorithmIdentifier.EdDSA`). Per reiner Config werden `ES256` und `RS256` aktiviert; EdDSA entfällt bis zum Upstream-Fix und wird in `server/docs/auth-erweiterung.md` dokumentiert.
- **RBAC & ABAC:** Rollen `USER` und `ADMIN` (`@RolesAllowed`; `ADMIN` nur für Betrieb, darf keine fremden Trainingsdaten lesen) sowie `@PermissionsAllowed` + `@PermissionChecker` (`@Blocking`) delegierend an die testbare DDD-`ZugriffsPolicy`. Unauthentifizierte Requests auf `/v1/*` (außer `anmelden*`/`registrieren*`) liefern `401` als `FehlerV1`-JSON (kein `302`-Redirect).
- **Rate-Limiting:** `quarkus-smallrye-fault-tolerance` (`@RateLimit`) an Auth-/Profil-Endpunkten + `RateLimitException` -> `429` `FehlerV1`.
- **Zeitdauern:** Projektweit ganze Sekunden (`integer`), Einheit im Feldnamen (`trainingSekunden`, `pauseSekunden`, `dauerSekunden`), kein ISO-8601 (E11, E21).

---

## 3. Client-Architektur (`client/`)

### Technologie-Stack & Standard-Packages
- **Basis:** React 19, TypeScript, Vite, PWA via `vite-plugin-pwa` (Workbox).
- **Deployment-Kompatibilität:** Vollständig kompatibel mit bestehenden Dateien auf `gemini`:
  - `Dockerfile` (`node:24-alpine`, `npm ci`, `npm run build` -> `/app/dist` in `nginx:alpine`)
  - `nginx.conf` (`/sw.js`, `/index.html` no-cache, SPA-Fallback `try_files $uri /index.html`)
  - `chart/` (Helm Chart)
  - `.github/workflows/build.yml` (`node-version: 24`, `npm ci`, `npm run typecheck`, `npm test`)
- **UI-Bibliothek & Material 3 Expressive:** `@mui/material`, `@emotion/react`, `@emotion/styled`, `@mui/icons-material` mit einem **Material-3-Expressive-Theme** (Farbpaletten generiert via `@material/material-color-utilities`, Hell-/Dunkel-Modus, Expressive-Shapes/Typografie, selbst gehostetes `@fontsource-variable/roboto`, **keine** fremden CDNs, **kein** eigener 12-Komponenten-UI-Bau).
- **Routing:** `react-router` (`BrowserRouter`, passend zu `nginx.conf` `try_files $uri /index.html`).
- **API-Client:** `openapi-typescript` + `openapi-fetch`. Typen werden aus der Quarkus-OpenAPI-Spec nach `src/api/schema.d.ts` generiert und im Client-Repo mitcommittet, damit Docker-/CI-Builds eigenständig laufen.

### Fachliche Client-Bausteine
- **Zentraler Dauer-Formatierer (E21):** Unter `3600` s `mm:ss` (z. B. `00:30`, `59:59`), ab `3600` s `h:mm:ss` (z. B. `1:00:00` bis `24:00:00`), ergänzt um `aria-label` in Worten.
- **Intervalltimer & Phasensignale (E1, E33):** Zeitstempel-basierte Restzeitberechnung, lokale Persistenz + Server-Sync nach Login (`GET`/`PUT /v1/timer/einstellung`), `PhasenSignal`-Port mit Web Audio Sinus-Oszillator (ohne Audiodateien), `navigator.vibrate` (Feature-Detection), sichtbarem `aria-live="polite"`-Signal und getrennten Schaltern für Ton & Vibration.
- **Teststrategie:**
  - **Vitest + Testing Library** (`npm test`, kompatibel mit Node `22.22.1` lokal und Node `24` in Docker/CI).
  - **Playwright (`@playwright/test@1.65.1`):**
    - Funktionale E2E-Tests in allen **4 Browser-Projekten** (`chromium`, `firefox`, `webkit`, `mobile`) gegen den **Produktions-Build** (`vite preview`).
    - Visuelle Screenshot-Tests **nur in Chromium** (Nutzerentscheid C) gegen den **Test-Build** (`vite build --mode test` mit `galerie.html`; Produktions-Build enthält keine `galerie*`-Dateien).
    - Fullstack-Integrationstests (`npm run test:e2e:integration`) gegen den laufenden Quarkus-Server (Chromium mit CDP Virtual Authenticator).

---

## 4. Branch- & Worktree-Konvention

- **Basis-Branch:** `gemini` in `/home/user/trainingsapp`, `server/` und `client/`.
- **Feature-Branches:** `gemini-task/<ID>-<slug>` (z. B. `gemini-task/GS-01-server-grundgeruest`, `gemini-task/GC-01-client-grundgeruest`).
- **Worktrees:** `.worktrees/gemini-<ID>` (z. B. `.worktrees/gemini-GS-01`, `.worktrees/gemini-GC-01`).
- **Parallelitätsregeln:**
  - Nie zwei Maven-Läufe im Server-Repo gleichzeitig (fester Testport `8081`).
  - Nie zwei Playwright-Läufe im Client-Repo gleichzeitig (feste Preview-Ports `4173`/`4174`).
