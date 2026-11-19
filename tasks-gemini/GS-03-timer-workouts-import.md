# Task GS-03: Timer-API, Workout-/Calisthenics-Tracking & `WorkoutImport`-Port

- **ID:** `GS-03`
- **Repo:** `server`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** `GS-02`
- **Branch:** `gemini-task/GS-03-timer-workouts-import`
- **Worktree:** `.worktrees/gemini-GS-03`

## Ziel

Umsetzung der serverseitigen Timer-Einstellung (`GET`/`PUT /v1/timer/einstellung`), des vollständigen Workout- und Calisthenics-Trackings (`/v1/workouts`) inkl. ABAC-Eigentümerschutz sowie des internen Erweiterungsports `application.erweiterung.WorkoutImport` (Nutzerentscheid B / E22).

## Abnahmekriterien

1. **Timer-API (`/v1/timer/einstellung`):**
   - `GET /v1/timer/einstellung`: liefert `200` mit `{ trainingSekunden, pauseSekunden, gespeichert }`. Ohne gespeicherten Eintrag liefert der Endpunkt den Standard `30` / `10` und `gespeichert: false` (E20).
   - `PUT /v1/timer/einstellung`: validiert `trainingSekunden` und `pauseSekunden` als ganze Sekunden (`integer`, sinnvolle Min/Max-Grenzen per Bean Validation + `@Schema`) und speichert genau eine Einstellung je Benutzer in PostgreSQL.
2. **Workout- & Calisthenics-Domäne + Flyway-Migration:**
   - Flyway-Migration (`V3__timer_workouts.sql`) für `timer_einstellung`, `workout`, `uebung`, `satz`.
   - `Workout`: `id` (UUID), `ownerId`, `typ` (`KRAFT` | `CALISTHENICS`), `titel` (max. 100), `startZeit` (UTC), `dauerSekunden` (optional, integer), `notiz` (optional, max. 500), `sichtbarkeit` (Standard `PRIVAT`), `herkunft` (`MANUELL` | `APPLE_HEALTH`, Standard `MANUELL`), `externeId` (optional, max. 200), `erstelltAm`, `geaendertAm`, `version` (optimistische Sperre).
   - `Uebung`: `id`, `workoutId`, `position`, `name` (max. 100), `variante` (optional, Progressionsstufe z. B. `"Tuck"`).
   - `Satz`: `id`, `uebungId`, `position`, `wiederholungen` oder `dauerSekunden` (mind. eines Pflicht), `gewichtKg` (optional), `pauseSekunden` (optional).
   - Index auf `(owner_id, start_zeit)` sowie eindeutiger Teilindex auf `(owner_id, herkunft, externe_id) WHERE externe_id IS NOT NULL`.
3. **Workout-Endpunkte & ABAC-Schutz:**
   - CRUD-Endpunkte unter `/v1/workouts` (Liste eigener Workouts, Detail, Anlegen, Aktualisieren, Löschen) mit `@Authenticated` und `@PermissionsAllowed` + `@PermissionChecker` (`@Blocking`) auf Basis von `ZugriffsPolicy`.
   - Fremde private Workouts sind nicht abruf-, änder- oder löschbar (IDOR-Schutz, liefert `403`/`404` ohne Datenleck).
4. **Interner Erweiterungsport `WorkoutImport` (Nutzerentscheid B):**
   - Port `application.erweiterung.WorkoutImport` (`importiere(BenutzerId, Herkunft, externeId, WorkoutDaten)`), idempotentes Upsert über `(ownerId, herkunft, externeId)`, gleiche Validierung wie manuelle Eingabe, immer `PRIVAT` (kein öffentlicher Endpunkt, kein Apple-Health-Adapter).
   - Dokumentation `server/docs/erweiterungen.md` beschreibt Vertrag und Einwilligungspflicht.
5. **Tests & OpenAPI:**
   - Unit-Tests für Workout-Validierung, `WorkoutImport`-Idempotenz und `ZugriffsPolicy`.
   - PostgreSQL-Integrationstests für Timer-Sync, Kraft-/Calisthenics-CRUD, optimistische Sperre und IDOR-Schutz.
   - OpenAPI-Schema exportiert und aktuell; `./mvnw clean verify` grün.
