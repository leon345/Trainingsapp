# S-11 – Weitere Benutzer zu einem Workout hinzufügen [Wunsch]

- **Repo:** server
- **Ziel:** Besitzer fügen Benutzer zu einem Workout hinzu, mit Leserecht und optional Schreibrecht, je Benutzer festlegbar.
- **Betroffene Dateien/Bereiche:** Berechtigungsmodell (Workout–Benutzer-Zuordnung mit Rechten), API, Zugriffsprüfung (S-05).
- **Abnahmekriterien:**
  - Besitzer kann Benutzer mit Lese- oder Schreibrecht hinzufügen und entfernen.
  - Schreibrecht ohne Leserecht ist nicht möglich; Tests für alle Fälle.
- **E26:** Schreibende Use-Cases (Einladen, Entfernen, Rechte ändern) nur über `application.Transaktion`.
- **Abhängigkeiten:** S-06.
- **Quelle:** server/README.md, „Wunsch-Kriterien“.
