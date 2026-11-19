# C-09 – Funktionstests (Client)

- **Repo:** client
- **Status:** umgesetzt und geprüft, soweit ohne C-03 bis C-05 möglich; Merge offen. Branch `task/C-09-tests-client`, Worktree .worktrees/C-09, Basis d132c60, Commits c8fdb79, 619c5f6. Vitest 179/179; Playwright 180/180 (chromium, firefox, webkit, mobile je 36; galerie-* je 2; visuell-chromium 28); 29 Referenzbilder unverändert; keine neuen Abhängigkeiten; `npm audit --omit=dev` 0. Neue Tests: Einstellung im angehaltenen Zustand gesperrt, Neustart nach Zurücksetzen, Fortschrittsanzeige, Screenreader-Ansage nur beim Phasenwechsel, Einstellung per Tastatur, Neuladen während des Laufs, `localStorage` gesperrt oder voll; jeweils mit Stichprobe (Fehler eingebaut, Test rot). Keine Fehler im bestehenden Code gefunden. Offen: Tests für Passkeys, Workouts, Sichtbarkeit (erst mit C-03 bis C-05); CI-Konfiguration (keine CI vorhanden, Architekturentscheidung, siehe "Nächste Council-Runde"). Formatierer aus C-02 bereits vorhanden.
- **Ziel:** Automatisierte clientseitige Funktionstests für alle Muss-Funktionen.
- **Betroffene Dateien/Bereiche:** Test-Setup, Test-Suites (Timer, Auth, Workouts, Sichtbarkeit), CI-Konfiguration.
- **Abnahmekriterien:**
  - Tests für Timer, Passkey-Flows, Workout-Tracking und Sichtbarkeit vorhanden.
  - Tests laufen per dokumentiertem Befehl lokal.
- **Zentraler Formatierer (E11, E21):** Unter 3600 s `mm:ss` (z. B. `00:30`, `59:59`), ab 3600 s `h:mm:ss` (z. B. `1:00:00`, bis `24:00:00`). Zentrale Funktion mit Grenzwert-Tests; zusätzlich `aria-label` in Worten.
- **Erledigter Teil (C-02, Spitze 88c13f2):** Zentraler Dauer-Formatierer `formatiereDauer` mit Grenzwert-Tests (E21) und `aria-label` ist vorhanden. Bei C-09 nur die übrigen Funktionstests ergänzen.
- **Abhängigkeiten:** C-01a, C-02 (Formatierer bereits vorhanden); wächst mit C-03 bis C-05.
- **Quelle:** client/README.md, „Muss-Kriterien“ (Funktionstests clientseitig).
