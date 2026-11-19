# S-10 – Teilen der Trainingsdaten mit Apple Health (Server-Teil) [Wunsch]

- **Repo:** server
- **Status:** zurückgestellt (Nutzerentscheid 18.11.2026: kein Apple Health vorerst; keine native App). Nicht gelöscht. Künftige Anbindung: nur ein Adapter auf `WorkoutImport` (E22, S-03). Kein Export-Port nötig (E22).
- **Ziel:** Serverseitige Bereitstellung der Trainingsdaten für die Übergabe an Apple Health.
- **Betroffene Dateien/Bereiche:** Export-Endpunkte oder Datenformat, Berechtigungen (nur eigene Daten).
- **Abnahmekriterien:**
  - Trainingsdaten sind exportierbar, nur für den Besitzer.
  - Schnittstelle ist dokumentiert.
- **Abhängigkeiten:** S-03. Gegenstück: C-13.
- **Quelle:** server/README.md, „Wunsch-Kriterien“; client/README.md (setzt native iOS-App voraus).
- **Hinweis:** Art der Übergabe (Export-Datei, API, direkte Integration) ist nicht festgelegt.
