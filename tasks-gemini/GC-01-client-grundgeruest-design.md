# Task GC-01: Client-Grundgerüst & Material-3-Expressive-Theme

- **ID:** `GC-01`
- **Repo:** `client`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** keine
- **Branch:** `gemini-task/GC-01-client-grundgeruest`
- **Worktree:** `.worktrees/gemini-GC-01`

## Ziel

Aufbau des frischen Client-Grundgerüsts mit React 19, TypeScript, Vite und PWA (`vite-plugin-pwa`), vollständig kompatibel mit den übernommenen Deployment-Dateien (`Dockerfile`, `nginx.conf`, `chart/`, `.github/workflows/build.yml`). UI auf Basis von `@mui/material` (+ `@emotion/react`, `@emotion/styled`, `@mui/icons-material`) mit einem Material-3-Expressive-Theme (`@material/material-color-utilities`, selbst gehostetes `@fontsource-variable/roboto`), `react-router` (`BrowserRouter`), `openapi-typescript` + `openapi-fetch` sowie der Test-Infrastruktur (Vitest + Testing Library, `@playwright/test@1.65.1`) und dem zentralen Dauer-Formatierer.

## Abnahmekriterien

1. **Setup & Deployment-Kompatibilität:**
   - `package.json` definiert `dev`, `build`, `preview`, `typecheck`, `test`, `test:e2e`, `test:e2e:visual` und unterstützt lokal Node `22.22.1` sowie in Docker/CI Node `24` (`Dockerfile`, `.github/workflows/build.yml`).
   - `npm run build` erzeugt ein PWA-Artefakt in `dist/` inkl. `sw.js` und `index.html` passend zu `nginx.conf` (`try_files $uri /index.html`).
   - `Dockerfile`-Build (oder kompatible Build-Prüfung) und `.github/workflows/build.yml`-Schritte (`npm run typecheck`, `npm test`) funktionieren ohne Anpassung der Workflow-Logik.
2. **Material 3 Expressive & Standard-Packages:**
   - UI-Bibliothek: `@mui/material`, `@emotion/react`, `@emotion/styled`, `@mui/icons-material` (kein eigener UI-Komponenten-Baukasten, kein `@material/web`).
   - Material-3-Expressive-Theme erzeugt Farbpaletten (Hell-/Dunkel-Modus) über `@material/material-color-utilities`, Expressive-Shapes und Typografie.
   - Schriften ausschließlich lokal über `@fontsource-variable/roboto` gebündelt (keine fremden CDNs); automatischer Playwright-Test prüft, dass keine externen Requests abgesetzt werden.
   - Routing über `react-router` (`BrowserRouter`) mit App-Navigation.
   - API-Client-Grundlage mit `openapi-typescript` + `openapi-fetch` eingerichtet (`src/api/schema.d.ts` generierbar und im Repo committet).
3. **Zentraler Dauer-Formatierer (E21):**
   - Formatiert ganze Sekunden: `< 3600` s als `mm:ss` (z. B. `00:30`, `59:59`), `>= 3600` s als `h:mm:ss` (z. B. `1:00:00` bis `24:00:00`), inkl. `aria-label` in Worten.
   - Vollständige Grenzwert-Unit-Tests in Vitest grün.
4. **Test-Infrastruktur & `galerie.html`:**
   - Vitest + Testing Library (`npm test`) grün.
   - `galerie.html` existiert ausschließlich im Test-Build (`vite build --mode test`); der Produktions-Build (`npm run build`) enthält keine `galerie*`-Dateien (durch automatischen Test belegt).
   - Funktionale Playwright-Tests (`@playwright/test@1.65.1`) laufen gegen `vite preview` (Produktions-Build) in allen **4 Browser-Projekten** (`chromium`, `firefox`, `webkit`, `mobile`) grün.
   - Visuelle Screenshot-Tests laufen **nur in Chromium** gegen den Test-Build (`galerie.html`) grün.
   - `client/docs/design-tokens.md` dokumentiert Theme, Palette, Typografie und Standard-Package-Nutzung.
