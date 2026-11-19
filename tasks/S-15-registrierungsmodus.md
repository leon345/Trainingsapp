# S-15 – Registrierungsmodus, Registrierungscode, Benutzerobergrenze (E31)

- **Status:** entfällt durch Nutzerentscheid G (18.11.2026). Nicht gelöscht; Registrierung bleibt offen ohne Code und Obergrenze.
- **Repo:** server
- **Ziel:** Öffentlicher Proof-of-Concept-Betrieb mit kontrollierter Registrierung.
- **Umfang:**
  - Konfiguration `trainingsapp.registrierung.modus` mit den Werten `GESCHLOSSEN`, `CODE`, `OFFEN`. In Prod ist `CODE` Standard.
  - Registrierungscode liegt gehasht im Secret; Vergleich in konstanter Zeit.
  - `max-benutzer` (Standard 20). Wenn erreicht, keine neuen Registrierungen.
  - Prüfung schon in `registrieren/optionen`, vor der 409-Antwort (verringert zugleich die Aufzählbarkeit aus E17).
  - Codefeld in der API für `registrieren` (Anfrage-Feld), in C-18 im Client.
- **Abnahmekriterien:**
  - Alle drei Modi getestet (GESCHLOSSEN, CODE, OFFEN).
  - Falscher oder fehlender Code wird abgewiesen; Vergleich in konstanter Zeit (Test).
  - Obergrenze greift; Test mit Grenzwert.
  - Prüfung in `registrieren/optionen` ist vor der 409-Antwort (Test).
  - Rate-Limit (E17) gilt weiter.
- **Abhängigkeiten:** S-04 (Registrierung, Phase B).
- **Quelle:** ENTSCHEIDUNGEN.md E31, E17, E26.
