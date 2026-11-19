# Task GC-05: Sichtbarkeit, Einladungen, Profile, DSGVO-UI & Gesamtabnahme

- **ID:** `GC-05`
- **Repo:** `client`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** `GC-04`, `GS-04`
- **Branch:** `gemini-task/GC-05-sichtbarkeit-dsgvo-ui-e2e`
- **Worktree:** `.worktrees/gemini-GC-05`

## Ziel

Abschließende Umsetzung der Workout-Sichtbarkeit (`PRIVAT`/`OEFFENTLICH`), Benutzer-Einladungen über exakte Namenssuche, Profil-Ansicht für öffentliche Workouts, vollständiger DSGVO-UI (Export, Kontolöschung, Datenschutzerklärung, PoC-Hinweis) sowie der finalen Cross-Browser-, Service-Worker- und Fullstack-E2E-Abnahme.

## Abnahmekriterien

1. **Sichtbarkeit, Einladungen & Profile:**
   - Sichtbarkeits-Steuerung (`PRIVAT` / `OEFFENTLICH`, Standard `PRIVAT`) direkt am Workout.
   - Einladungsdialog mit exakter Benutzernamenssuche (`GET /v1/benutzer/suche?name=...`), Anzeige des gefundenen Namens vor dem Einladen sowie Entfernen von Einladungen.
   - Profil-Route (`/profil/:benutzerId` via `react-router`) zeigt ausschließlich öffentliche Workouts des jeweiligen Nutzers (nur für angemeldete Nutzer zugänglich).
2. **DSGVO-UI & PoC-Hinweis:**
   - Sichtbarer PoC-Hinweis (E31) auf Startseite/Anmeldung, bei Registrierung (vor der Einwilligung), im Footer und in der Datenschutzerklärung.
   - Seite für Datenschutzerklärung & rechtliche Hinweise (mit klarem Platzhalter für den Verantwortlichen).
   - Synchroner JSON-Datenexport (`GET /v1/dsgvo/export`) als Datei-Download im Konto-Bereich.
   - Kontolöschung (`DELETE /v1/konto`) mit ausdrücklicher zweistufiger Bestätigung, anschließender Bereinigung lokaler Sitzungszustände und Weiterleitung.
3. **PWA, Sicherheit & Audit:**
   - Service-Worker-Cache-Test gegen `vite preview`: App-Shell/statische Assets gecacht, keine API-Antworten (`/v1/*`) im Cache, kein `galerie*` im Produktions-Build, keine externen Hosts/CDNs.
   - `npm audit --omit=dev` meldet 0 hohe oder kritische Befunde (Prüfung dokumentiert in `client/docs/dependency-audit.md`).
4. **Gesamtabnahme (alle Test-Suiten grün):**
   - `npm run typecheck` grün.
   - `npm test` (Vitest) 100 % grün.
   - `npm run test:e2e` (Playwright funktional in allen 4 Projekten `chromium`, `firefox`, `webkit`, `mobile` gegen Produktions-Build) 100 % grün.
   - `npm run test:e2e:visual` (Playwright visuell nur in `chromium` gegen Test-Build) 100 % grün.
   - `npm run test:e2e:integration` (Fullstack-E2E gegen laufenden Quarkus-Server inkl. 2-Nutzer-Sichtbarkeit/Einladung, Export und Kontolöschung) 100 % grün.
