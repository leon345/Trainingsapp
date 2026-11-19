# S-01 – Quarkus-Grundgerüst, Layered/DDD, OpenAPI, /v1

- **Status:** umgesetzt, Merge offen (noch nicht in main)
- **Branch:** `task/S-01-quarkus-grundgeruest`, Commits b98b02c, ee3a8d4, 58d3f09
- **Worktree:** /home/user/trainingsapp/.worktrees/S-01
- **Nachweis (Worker-Angabe):** `mvn package` mit 3 grünen Tests, Jar gestartet, `/v1/info` und `/q/openapi` erreichbar. `mvn quarkus:dev` nicht getestet.
- **Festlegungen für Folgetasks:** Quarkus 3.40.1.2, Maven ohne Wrapper, Java 21, Paket `de.trainingsapp` mit Schichten domain/application/infrastructure/api.v1, `ApiVersion.V1`, Konventionen in `docs/api-konventionen.md`, keine Datenbank.
- **Offen vor Merge:** Git-Autor ist nicht konfiguriert; Commits tragen `Agent S-01 <agent-s01@localhost>`. Entscheiden, ob umgeschrieben wird.
- **Repo:** server
- **Ziel:** Lauffähiges Quarkus-3.40-Backend mit Layered-Architecture nach DDD als Basis für alle weiteren Server-Tasks.
- **Betroffene Dateien/Bereiche (voraussichtlich):** Projektgerüst (pom.xml/build), Paketstruktur (Domain, Application, Infrastructure, API-Schicht), Konfiguration, erster versionierter Beispielendpunkt unter `/v1`, OpenAPI-Konfiguration.
- **Abnahmekriterien:**
  - Quarkus 3.40 (LTS), kein anderes Backend-Framework.
  - Layered-Struktur nach DDD ist im Code erkennbar.
  - Mindestens ein Endpunkt unter `/v1/...` ist erreichbar.
  - OpenAPI-Dokumentation wird generiert und ist abrufbar; Konvention für neue Endpunkte ist dokumentiert.
  - Build und Start laufen ohne Fehler.
- **Abhängigkeiten:** keine.
- **Quelle:** server/README.md, Abschnitt „Technik“ und „Muss-Kriterien“ (versionierte Endpunkte, OpenAPI).
