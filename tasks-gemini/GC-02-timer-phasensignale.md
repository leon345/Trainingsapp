# Task GC-02: Intervalltimer & Phasensignale (Ton, Vibration, `aria-live`)

- **ID:** `GC-02`
- **Repo:** `client`
- **Status:** `erledigt` (per Fast-Forward in `client` Branch `gemini`, Commit `6381298`: Vitest 70/70 grün, Playwright 41/41 grün inkl. 4 Browser + 5 `visuell-chromium`-Snapshots, `typecheck` & `lint` 0 Fehler)
- **Abhängigkeiten:** `GC-01`
- **Branch:** `gemini-task/GC-02-timer-phasensignale`
- **Worktree:** `.worktrees/gemini-GC-02`

## Ziel

Umsetzung des mobil bedienbaren Intervalltimers mit einstellbarer Trainings- und Pausenzeit (ganze Sekunden, Standard `30` s / `10` s), zeitstempel-basierter Restzeitberechnung, lokaler Persistenz und barrierefreien Phasensignalen (Web Audio Sinus-Oszillator, `navigator.vibrate` mit Feature-Detection, sichtbares `aria-live="polite"`-Signal und zwei getrennte Schalter).

## Abnahmekriterien

1. **Timer-Funktionalität & Bedienbarkeit:**
   - Einstellbare Trainingsphase und Pause in ganzen Sekunden (Min/Max-Validierung, Tastatur- & Touch-Bedienung über `@mui/material`, Standard `30` s / `10` s).
   - Zeitstempel-basierte Restzeitberechnung (bleibt exakt bei Tab-Hintergrund, Drosselung und Neuladen der Seite).
   - Zustände: Bereit, Training, Pause, Pausiert; Aktionen Start, Pause, Fortsetzen, Zurücksetzen.
   - Formatierung aller Dauern ausschließlich über den zentralen Formatierer aus `GC-01` (inkl. `aria-label`).
   - Robuste lokale Persistenz im `localStorage` (funktioniert auch bei blockiertem oder vollem `localStorage` ohne Absturz).
2. **Phasensignale (Antwort 16 / E33):**
   - Port `PhasenSignal` mit Web-Audio-Sinus-Oszillator (ohne externe Audiodateien; `AudioContext` beim Tippen auf „Start“ entsperrt, Hüllkurve gegen Knacken; Training: zwei kurze Töne 880 Hz / 120 ms; Pause: ein Ton 440 Hz / 200 ms).
   - Vibration über `navigator.vibrate` mit Feature-Detection (`[200]` bei Training, `[100, 100, 100]` bei Pause).
   - Sichtbares Phasensignal mit Text, Theme-Farbe und `aria-live="polite"`.
   - Pro Phasenübergang genau ein Signal; nach Rückkehr aus dem Hintergrund wird nur der letzte Wechsel signalisiert (verpasste werden nicht nachgeholt).
   - Zwei getrennte Schalter (Ton, Vibration), lokal gespeichert, Standard an; Vibrationsschalter deaktiviert mit Hinweis, wenn der Browser keine Vibration unterstützt.
3. **Tests:**
   - Vitest-Tests (Phasenwechsel, Zeitstempel-Genauigkeit, Einmaligkeit, Hintergrund-Sprung, Schalter, `localStorage`-Fehlerfälle) grün.
   - Funktionale Playwright-Tests in allen 4 Browser-Projekten (`chromium`, `firefox`, `webkit`, `mobile`) gegen Produktions-Build (inkl. gemocktem `AudioContext` & `navigator.vibrate`, Reload im Lauf, Tastaturbedienung) grün.
   - Visueller Chromium-Test grün.
