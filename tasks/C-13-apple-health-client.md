# C-13 – Teilen der Trainingsdaten mit Apple Health (iOS) [Wunsch]

- **Repo:** client
- **Status:** zurückgestellt (Nutzerentscheid 18.11.2026: kein Apple Health vorerst; keine native App). Nicht gelöscht.
- **Ziel:** Trainingsdaten werden aus der nativen iOS-App an Apple Health übergeben.
- **Betroffene Dateien/Bereiche:** Native iOS-Anbindung (HealthKit), Berechtigungsdialog, Datenmapping.
- **Abnahmekriterien:**
  - Setzt eine native iOS-App voraus (C-11).
  - Nutzer erteilt Berechtigung; Daten werden übergeben.
- **Pruefschritt (vor Umsetzung):** Prüfen, ob ein natives HealthKit-Plugin für Capacitor verfügbar und gepflegt ist. Ergebnis dokumentieren. Falls nicht: eigenes Capacitor-Plugin als Entscheidung dem Nutzer vorlegen.
- **Abhängigkeiten:** C-11, C-15, S-10.
- **Quelle:** client/README.md, „Wunsch-Kriterien“.
