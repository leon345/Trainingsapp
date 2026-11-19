# Task GS-04: Workout-Sichtbarkeit, Einladungen, DSGVO-Export/Löschung & Aufräumjob

- **ID:** `GS-04`
- **Repo:** `server`
- **Status:** `offen`
- **Abhängigkeiten:** `GS-03`
- **Branch:** `gemini-task/GS-04-sichtbarkeit-dsgvo-aufraeumen`
- **Worktree:** `.worktrees/gemini-GS-04`

## Ziel

Umsetzung von Workout-Sichtbarkeit (`PRIVAT` / `OEFFENTLICH`), Einladungen über exakte Benutzernamenssuche, benutzerspezifischen Profil-Endpunkten, DSGVO-Export und -Kontolöschung sowie dem täglichen `quarkus-scheduler`-Aufräumjob.

## Abnahmekriterien

1. **Sichtbarkeit, Einladungen & Profile:**
   - Flyway-Migration (`V4__einladungen_dsgvo.sql`) für `workout_einladung` (`workout_id`, `eingeladener_id`, `status`, `erstellt_am`).
   - Sichtbarkeit eines Workouts umschaltbar zwischen `PRIVAT` und `OEFFENTLICH` (Standard `PRIVAT`).
   - Exakte Suche nach `Benutzername` (`GET /v1/benutzer/suche?name=...` mit `@RateLimit`) zur Vorbereitung einer Einladung; Einladen/Entfernen eines Benutzers zu einem eigenen Workout (`POST`/`DELETE /v1/workouts/{id}/einladungen`).
   - Profil-Endpunkt (`GET /v1/profile/{benutzerId}/workouts` mit `@RateLimit`): zeigt ausschließlich `OEFFENTLICH`-Workouts (sowie für den Eingeladenen freigegebene Workouts in eigener Übersicht). Anonyme Anfragen liefern `401`; `ADMIN` erhält keinen Zugriff auf fremde Trainingsdaten (`ZugriffsPolicy`).
2. **DSGVO-Funktionen:**
   - Synchroner JSON-Datenexport (`GET /v1/dsgvo/export`): liefert sämtliche Daten des angemeldeten Benutzers (Profil, Passkey-Metadaten, Timer-Einstellung, eigene Workouts inkl. Übungen/Sätze, Einladungen).
   - Sofortige Kontolöschung (`DELETE /v1/konto`): löscht in einer `@Transactional`-Operation Konto, Passkeys, Timer-Einstellung, Workouts, Übungen, Sätze und Einladungen restlos und beendet die aktive Sitzung.
   - Logs enthalten keine personenbezogenen Daten oder Trainingsinhalte.
3. **Täglicher Aufräumjob (`quarkus-scheduler`):**
   - `@Scheduled`-Job in `infrastructure` nutzt `@Transactional`-Use-Case in `application` und `application.Uhr`.
   - Löscht abgelaufene ausstehende Registrierungen (TTL 10 Min.) und Konten ohne Passkey nach 14 Tagen; Konten mit mindestens einem Passkey werden unabhängig von Inaktivität **nicht** gelöscht. Protokolliert ausschließlich Zähler ohne Personenbezug.
4. **Tests:**
   - Vollständige ABAC-Matrix-Tests (Besitzer, Eingeladener, anderer angemeldeter Benutzer, `ADMIN`, Anonym).
   - DB-Integrationstests für Export, vollständige kaskadierende Kontolöschung und Aufräumjob mit Fake-`Uhr`.
   - `./mvnw clean verify` inkl. ArchUnit grün.
