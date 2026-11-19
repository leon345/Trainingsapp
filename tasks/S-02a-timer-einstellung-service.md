# S-02a – Timer-Einstellung: Service + In-Memory-Adapter

- **Status:** umgesetzt, Merge offen
- **Repo:** server
- **Branch:** `task/S-02-timer-intervall` (abgezweigt von `task/S-01-quarkus-grundgeruest`), Commits 822cd41 (Domain), 67493f5 (Service, Port, Adapter), baf8601 (Doku)
- **Ergebnis (Worker-Angabe):** `mvn -o package` mit 29 Tests grün; die 3 Tests aus S-01 grün; Jar nicht gestartet; pom.xml unverändert.
- **Gebaut:** `TimerEinstellungService` (`lese(BenutzerId)`, `speichere(BenutzerId, trainingSekunden, pauseSekunden)`), Port `domain.timer.IntervallEinstellungRepository`, Adapter `infrastructure.timer.InMemoryIntervallEinstellungRepository` als `@DefaultBean`, Schema `TimerEinstellungV1` in `docs/api-konventionen.md` (`trainingSekunden` 1–86400, `pauseSekunden` 0–86400).
- **Notiz für S-04:** `domain.benutzer.BenutzerId` ist ein Record mit opakem, nicht leerem String (Annahme des Workers). E5 sieht UUIDs vor; S-04 übernimmt den Typ oder stellt auf UUID um.
- **Worktree:** /home/user/trainingsapp/.worktrees/S-02
- **Ziel:** Application-Service "Einstellung lesen/speichern" für die Timer-Einstellung eines Benutzers, ohne Persistenz (In-Memory).
- **Betroffene Bereiche:** `application` (Service, Port), `domain` (Einstellung mit Validierung), `infrastructure` (In-Memory-Adapter), `docs/api-konventionen.md` (DTO-Schema).
- **Abnahmekriterien:**
  - Trainingssekunden und Pausensekunden als Integer; Feldnamen `trainingSekunden`, `pauseSekunden` (E11). Min/Max per Bean Validation und `@Schema` dokumentiert.
  - Repository-Port in `application`/`domain`; In-Memory-Adapter in `infrastructure`.
  - Unit-Tests für Validierung und Service.
  - DTO-Schema in `docs/api-konventionen.md` beschrieben.
  - Kein HTTP-Endpunkt in diesem Task (kommt mit S-02b).
- **Abhängigkeiten:** S-01 (Branch). Keine Abhängigkeit zu S-12, da In-Memory.
- **Quelle:** ENTSCHEIDUNGEN.md E10, E11; server/README.md, "Muss-Kriterien" (Timer).
- **Prüfpunkt für den Orchestrator:** Der Worker muss die Feldnamen aus E11 prüfen. Falls Commit 822cd41 andere Namen nutzt, nachziehen.
