# Task GC-03: Passkey-UI, Passkey-Verwaltung & Server-Timer-Sync (+ Fullstack-E2E)

- **ID:** `GC-03`
- **Repo:** `client`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** `GC-02`, `GS-02`, `GS-03`
- **Branch:** `gemini-task/GC-03-passkey-ui-timer-sync`
- **Worktree:** `.worktrees/gemini-GC-03`

## Ziel

Anbindung des Clients an das Quarkus-Backend über `openapi-typescript` + `openapi-fetch` (`src/api/schema.d.ts` aus dem aktuellen Server-OpenAPI-Artefakt): Registrierung und Anmeldung per Passkey (WebAuthn), Multi-Passkey-Verwaltung, Sitzungsverwaltung sowie Synchronisation der Timer-Einstellung (`GET`/`PUT /v1/timer/einstellung`), verifiziert durch einen Fullstack-E2E-Test gegen den laufenden Server.

## Abnahmekriterien

1. **OpenAPI-Typgenerierung & API-Client:**
   - `src/api/schema.d.ts` wird per `openapi-typescript` aus der aktuellen Server-OpenAPI-Spec generiert und im Repo committet.
   - Alle API-Aufrufe laufen typsicher über `openapi-fetch` (Cookie-Credentials aktiviert, einheitliche Fehlerauswertung für `FehlerV1`).
2. **Registrierung, Anmeldung & Sitzung:**
   - Offene Registrierung ohne Codefeld (Nutzerentscheid G), mit Pseudonym-Hinweis („keine E-Mail, kein Klarname“) und ausdrücklicher Art.-9-Einwilligung.
   - Anmeldung sowohl mit als auch ohne Benutzernamen (discoverable Credentials / WebAuthn JSON-APIs).
   - Abmelden (`/v1/abmelden`), Sitzungsstatus bleibt nach Neuladen erhalten (`/v1/ich`).
   - Nach erfolgreicher Registrierung wird der Nutzer aktiv zur Hinterlegung eines zweiten Passkeys aufgefordert.
3. **Passkey-Verwaltung:**
   - Auflisten eigener Passkeys mit Bezeichnung, `erstelltAm` und `zuletztVerwendetAm` (Wiedergabe ausschließlich als Text, nie als HTML).
   - Neuen Passkey hinzufügen (`POST /v1/passkeys/optionen` -> `POST /v1/passkeys`).
   - Passkey umbenennen (`PATCH /v1/passkeys/{id}`).
   - Passkey löschen (`DELETE /v1/passkeys/{id}`); der letzte verbleibende Passkey ist in der UI geschützt bzw. gibt eine klare Rückmeldung.
4. **Timer-Synchronisation:**
   - Angemeldete Nutzer laden ihre gespeicherte Timer-Einstellung via `GET /v1/timer/einstellung` (`gespeichert`-Flag berücksichtigt) und speichern Änderungen via `PUT /v1/timer/einstellung`.
   - Ohne Anmeldung bleibt der Timer lokal vollständig nutzbar.
5. **Tests:**
   - Vitest-Komponententests + funktionale Playwright-Tests (4 Browser-Projekte gegen gemockte API) + Chromium-Screenshot-Test grün.
   - Fullstack-Integrationstest (`npm run test:e2e:integration`) gegen den echten Quarkus-Server (Chromium mit CDP Virtual Authenticator): Registrierung, zweiter Passkey, Umbenennen, Timer-Sync, Abmelden, Anmeldung ohne Benutzernamen, Session nach Reload, Löschen (inkl. Schutz des letzten Passkeys) komplett grün.
