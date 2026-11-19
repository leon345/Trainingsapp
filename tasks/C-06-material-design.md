# C-06 – Design Material Design 3 Expressive (ohne @material/web)

- **Status:** umgesetzt, teilweise geprüft, Merge offen.
- **Repo:** client
- **Branch:** `task/C-06-material-design` (Basis 4bb90b4 = C-01a), Worktree `.worktrees/C-06`, Commits 2bce60e, 818d423, 1f0b315, fa3e320, e3edbf5.
- **Ziel:** Oberfläche folgt Material Design 3 Expressive über eigenes Token-Paket (E2).

## Ergebnis (Worker-Angabe)
- **Grün:** `npm run typecheck`, `npm run build`, `npm test` (61/61), Playwright Chromium 28/28 und Firefox 28/28, 40 Referenzbilder unter `e2e/visuell.spec.ts-snapshots/` (nur Chromium und Firefox unter Linux).
- **WebKit und Mobil (Stand e132a66):** Nutzerfrage 9 erledigt. Je 9 funktionale Tests grün (Startseite, Layout ohne horizontales Scrollen, Manifest, Service Worker, keine fremden Hosts, Roboto selbst gehostet, dunkles Schema); keine inhaltlichen Fehler. Keine Referenzbilder für WebKit oder Mobil (Nutzerentscheid C).
- **Barrierefreiheit:** nur automatisch geprüft (Kontraste, Feldnamen, Tastatur). Nicht mit Screenreader oder axe.
- **Gebaut:** Token-Paket (Farbe hell/dunkel je normaler und hoher Kontrast, Form, Typografie, Höhen, Zustände, Fokusring, Bewegung); Komponenten Button, IconButton, Icon, Card, TextField auf React Aria; `galerie.html` als Vorlage für die visuellen Tests.
- **Schrift und Icons:** Roboto variabel (`@fontsource-variable/roboto`, OFL 1.1); Icons Material Symbols Rounded als SVG (`@material-symbols/svg-400`, Apache 2.0). Beides selbst gehostet, gebündelt.
- **Herkunft der Tokens** (`docs/design-tokens.md` im Branch):
  - Farbe: `material-color-utilities` 0.4.
  - Form, Typografie, Höhen, Zustände: Werte aus den Token-Dateien von material-web (nur Werte, nicht das Paket).
  - Bewegung: aus dem Compose-Quellcode und einer Tabelle von m3.material.io. Die Tabelle war NICHT direkt abrufbar; aus dem Suchindex, mit zwei Abschriften auf GitHub gegengeprüft.
  - Theme Builder: liefert nichts Expressive-Spezifisches exportierbar.
- **Eigene Festlegungen des Workers:** Quellfarbe `#6750a4` (Frage 13); Schatten; Verhalten bei reduzierter Bewegung; einige Maße von Textfeld und Card; 48-px-Zielfläche.

## Abnahme offen
- Visuelle Tests nur in Chromium (Nutzerentscheid C); Firefox-Referenzbilder werden in C-06b entfernt.
- Quellfarbe bestätigt oder ersetzt (Frage 13).
- `galerie.html` nur im Test-Build (E24), Umsetzung in C-06b vor dem Merge von C-06. C-06b wartet auf C-14.
- Barrierefreiheit mit Screenreader oder axe prüfen (eigener Punkt, nicht blockierend für Merge).

## Komponentenumfang für Folgetasks (Vorschlag des Workers, übernommen als Notiz)
- **C-02 Timer:** Zahlenfeld, großer Start-Button bzw. FAB, Fortschrittsanzeige, Segmented Button bzw. Schalter.
- **C-03 Passkey-UI:** Liste, Dialog, Snackbar.
- **C-04 Workouts:** Select bzw. Menü, Chips, Datumswahl, Navigation Bar und Rail, Top App Bar, Dialog.
- Jede Komponente auf React Aria, mit Token-Paket, mit Visual-Test (Playwright).

## Abhängigkeiten
- C-01a (Basis). Nachfolger: C-02, C-03, C-04, C-14 (Basis ist jetzt dieser Branch).

## Quellen
- ENTSCHEIDUNGEN.md E2.
- Spike-Notiz: `docs/design-tokens.md` im Branch.
