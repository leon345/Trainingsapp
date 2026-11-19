# Task GC-04: Workout- & Calisthenics-Tracking-UI (+ Fullstack-E2E)

- **ID:** `GC-04`
- **Repo:** `client`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** `GC-03`, `GS-03`
- **Branch:** `gemini-task/GC-04-workout-tracking-ui`
- **Worktree:** `.worktrees/gemini-GC-04`

## Ziel

Implementierung der Benutzeroberfläche für das Tracken von Kraft- und Calisthenics-Workouts (`/v1/workouts`) im Material-3-Expressive-Design mit `@mui/material` und `react-router`, inkl. mobiler Bedienbarkeit und Fullstack-E2E-Verifikation gegen den Server.

## Abnahmekriterien

1. **OpenAPI-Schema & Routen:**
   - `src/api/schema.d.ts` aktuell zur Server-OpenAPI-Spec (`GS-03`).
   - Eigene Routen über `react-router` (`BrowserRouter`) für Workout-Übersicht, Workout-Detail/Bearbeitung und Neues Workout.
2. **Workout-, Übungs- & Satz-Verwaltung:**
   - Erstellen, Anzeigen, Bearbeiten und Löschen von Workouts (`typ`: `KRAFT` | `CALISTHENICS`, `titel`, `startZeit`, optionale `dauerSekunden`, optionale `notiz`).
   - Dynamisches Hinzufügen, Sortieren/Positionieren und Entfernen von Übungen (`name`, optionale Progressions-`variante` z. B. `"Tuck"` bei Calisthenics) und Sätzen (`wiederholungen` oder `dauerSekunden`, optional `gewichtKg`, optional `pauseSekunden`).
   - Alle Zeitdauern werden über den zentralen Formatierer (`mm:ss` / `h:mm:ss` + `aria-label`) dargestellt und als ganze Sekunden an die API gesendet.
   - Saubere Formularvalidierung und Anzeige von `FehlerV1`-Fehlermeldungen (inkl. Konflikt/Version).
3. **Mobile Usability & Barrierefreiheit:**
   - Auf Smartphone-Viewports ohne horizontales Scrollen komfortabel bedienbar; vollständige Tastaturbedienung und korrekte Labels.
4. **Tests:**
   - Vitest-Tests (Formularvalidierung, Übungs-/Satz-Logik, API-Mapping) grün.
   - Funktionale Playwright-Tests in allen 4 Browser-Projekten (`chromium`, `firefox`, `webkit`, `mobile`) gegen Produktions-Build grün.
   - Visueller Chromium-Test grün.
   - Fullstack-Integrationstest (`npm run test:e2e:integration`) gegen den laufenden Server (Kraft- & Calisthenics-Workout anlegen, bearbeiten, Reload prüfen, löschen) grün.
