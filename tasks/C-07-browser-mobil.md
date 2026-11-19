# C-07 – Lauffähigkeit in Safari, Firefox und Chrome auf Mobilgeräten

- **Repo:** client
- **Ziel:** Frontend läuft fehlerfrei auf Mobilgeräten in Safari, Firefox und Chrome.
- **Betroffene Dateien/Bereiche:** Build-/Polyfill-Konfiguration, CSS/Layout, Browser-spezifische Stellen (WebAuthn, Timer).
- **Abnahmekriterien:**
  - Testmatrix (Safari iOS, Firefox Android, Chrome Android) ist definiert und dokumentiert.
  - Kernfunktionen (Timer, Anmeldung, Workouts) laufen in allen drei Browsern.
- **Handtest (E-Beschluss, vor erstem Release):** Passkeys mit echten Plattform-Authenticatoren (iCloud, Google, Windows Hello) auf echten Geräten. Nicht automatisierbar; Nutzer führt aus.
- **Folge Nutzerentscheid C (18.11.2026):** Das Aussehen in Safari und Firefox wird nicht automatisch geprüft (keine visuellen Tests dort), sondern nur beim Handtest in diesem Task. Funktionale E2E-Tests laufen dort weiterhin.
- **Abhängigkeiten:** C-01a.
- **Quelle:** client/README.md, „Muss-Kriterien“ (Lauffähig in Safari, Firefox und Chrome auf Mobilgeräten).
