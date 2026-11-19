# S-02c – Timer-Standard und Feld `gespeichert` (Folgepunkt zu S-02a)

- **Status:** umgesetzt und geprüft, Merge offen. Branch `task/S-02c-timer-standard`, Worktree .worktrees/S-02c, Basis 003b2cc, Commits e98e11b, 95de62c, 567b701. `mvn package` ohne Schalter: 118 Tests grün, 0 übersprungen. Neu: `IntervallEinstellung.STANDARD` (30/10), `TimerEinstellungService.leseOderStandard(BenutzerId)` liefert `TimerEinstellungAnsicht(einstellung, gespeichert)`; `lese` und `speichere` unverändert. Doku im Timer-Abschnitt von `docs/api-konventionen.md`. (Früherer Vermerk: zurückgestellt bis S-04 Phase A abgeschlossen (UUID-Umstellung von `BenutzerId` ändert Timer-Service und Tests, die S-02c ebenfalls anfasst)
- **Repo:** server
- **Basis:** `integration/server` (S-02a ist dort bereits gemergt; dieser Task ändert den abgeschlossenen Stand nicht, sondern ergänzt ihn).
- **Ziel:** Entscheidung E20 umsetzen.
- **Umfang:**
  - `IntervallEinstellung.STANDARD` = Training 30 s, Pause 10 s.
  - `TimerEinstellungV1` bekommt `gespeichert` (boolean, `readOnly`, nur in der Antwort; bei `PUT` ignoriert).
  - `docs/api-konventionen.md` um `gespeichert` (`readOnly`) und den Standard ergänzen.
  - Unit-Tests: Standardwerte; `gespeichert` wird bei `PUT` ignoriert.
- **Abnahmekriterien:** Standard stimmt mit E20 überein; Dokumentation und Schema gleich; Tests grün.
- **Abhängigkeiten:** S-02a. Vor S-02b.
- **Korrigiert: nicht parallel zu S-04 Phase A.** Früher: parallel startbar. Grund: S-04 ändert den Timer-Service und dessen Tests durch die UUID-Umstellung. Ursprünglicher Text:  Berührt nur `IntervallEinstellung`, `TimerEinstellungV1` und `docs/api-konventionen.md`. Keine `pom.xml`, keine `application.properties`, keine Auth-Klassen. Bei `docs/` kurz mit S-04 abstimmen.
- **Quelle:** ENTSCHEIDUNGEN.md E20.
