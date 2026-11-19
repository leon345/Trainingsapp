# C-14 – Client: Dependency-Audit und gezielte Aktualisierung

- **Status:** abgeschlossen (Bewertung), Merge offen. Branch `task/C-14-dependency-audit`, Worktree .worktrees/C-14, Commit e132a66 (`docs/dependency-audit.md`). `package.json` und Lockfile unverändert.
- **Repo:** client
- **Basis:** `task/C-06-material-design` (C-06 baut auf C-01a auf; nach Merge client main)
- **Ergebnis (Bewertung):**
  - `npm audit` gesamt weiterhin 14 (12 hoch, 2 moderat). `npm audit --omit=dev` ist 0. Am Build geprüft: keines der betroffenen Pakete liegt in `dist/`, im Bundle oder in `sw.js`.
  - Ursache: drei Meldungen, alle nur in Entwicklungs- und Build-Werkzeugen. picomatch <= 4.0.7 (hoch, ReDoS, 12 der 14 Meldungen, kein Fix verfügbar; laut Worker nicht erreichbar, da Glob-Muster nur aus eigener Konfiguration stammen und der Dev-Server nur auf localhost lauscht). glob 11.1.0 und minimatch 10.2.6 (moderat) über `workbox-build` 7.4.1.
  - Kein Update ohne Breaking Change. `npm audit fix --force` würde Major-Downgrades einspielen (vite 6, vitest 3, vite-plugin-pwa 1); nicht ausgeführt.
  - **Offene Entscheidung (Council):** Override `glob` auf ^14.0.2 würde die 2 moderaten Meldungen beseitigen. Build byte-identisch, aber Major-Sprung; Workbox damit nicht getestet; Fehler würden sich still als fehlende Einträge im Service-Worker-Cache zeigen; Vitest und E2E mit Override nicht gelaufen. Empfehlung des Workers: nicht übernehmen, auf neues `workbox-build` warten. **Bis zur Entscheidung gilt: kein Override.**
  - **Wiedervorlage:** Audit erneut prüfen, sobald neue Versionen von picomatch oder workbox-build erscheinen. **Entschieden (E27):** kein `glob`-Override; Restrisiko in `docs/dependency-audit.md`; Workbox-Upgrade als eigener Task C-16 mit Test des Service-Worker-Caches.
  - Geprüfter Stand: Typprüfung und Build grün; Vitest 61/61; Playwright Chromium 28/28 und Firefox 28/28; 40 Referenzbilder unverändert.
  - WebKit und Mobil starten weiterhin nicht (fehlen: libevent-2.1-7t64, libavif16, libmanette-0.2-0; root nötig). Nutzerfrage 9 offen. Für WebKit gibt es noch keine Referenzbilder.
  - Hinweis: `npm audit fix --dry-run` bricht mit npm 9.2.0 ab.
- **Folgetask:** C-06b (E24) auf Basis dieses Branches.
- **Ziel:** Die 14 Lücken aus `npm audit` (2 moderate, 12 hoch, u. a. glob, minimatch, picomatch) bewerten und gezielt beheben.
- **Vorgehen:**
  1. Jede Lücke einordnen: nur Entwicklungswerkzeug (devDependencies, nicht im Build-Output) oder ausgelieferter Code (im Bundle bzw. im Service Worker).
  2. Ausgelieferter Code: gezielt aktualisieren, mit Begründung je Paket.
  3. Nur Entwicklungswerkzeuge: Risiko dokumentieren; Aktualisierung, wenn ohne Aufwand möglich.
  4. Kein `npm audit fix --force`.
- **Abnahmekriterien:**
  - Tabelle je Lücke: Paket, Schweregrad, Pfad (dev oder prod), Entscheidung.
  - Keine Lücke im ausgelieferten Code offen, oder mit dokumentierter Begründung.
  - Typprüfung, Build, Vitest und E2E (Chromium, Firefox) bleiben grün.
- **Abhängigkeiten:** C-01a.
- **Quelle:** Meldung C-01a (npm audit), ENTSCHEIDUNGEN.md E1 (Stack).
