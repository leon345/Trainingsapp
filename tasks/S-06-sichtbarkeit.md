# S-06 – Workout-Sichtbarkeit und Profil

- **Status:** offen
- **Repo:** server
- **Ziel:** Workouts sind privat oder öffentlich; öffentliche Workouts sind im Profil des Besitzers sichtbar, für angemeldete Benutzer (E6).
- **Regeln (E6, verbindlich):**
  - Öffentliche Workouts sehen alle angemeldeten Benutzer im Profil des Besitzers.
  - Anonyme Besucher sehen nie etwas.
  - Kein globaler Feed.
  - Profil nur über eine nicht erratbare UUID; Profil-Endpunkt nur für angemeldete Benutzer.
  - Rate-Limit gegen Durchprobieren von Profilen.
  - Private Workouts: nur Besitzer und eingeladene Benutzer (E4, Einladung).
- **Abnahmekriterien:**
  - Sichtbarkeitsfälle getestet: Besitzer, angemeldet fremd, eingeladen, anonym, privat.
  - Rate-Limit greift bei wiederholten Profilabfragen (Test).
  - Keine Liste aller Profile oder Workouts.
- **E26:** Schreibende Use-Cases (Sichtbarkeit ändern) nur über `application.Transaktion`.
- **Abhängigkeiten:** S-03, S-05.
- **Blockiert:** C-05, S-11.
- **Quelle:** ENTSCHEIDUNGEN.md E4, E6; server/README.md, "Muss-Kriterien".
