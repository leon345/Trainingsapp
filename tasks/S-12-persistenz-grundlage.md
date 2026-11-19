# S-12 – Persistenz-Grundlage

- **Status:** umgesetzt und geprüft, in `integration/server` gemergt (Spitze a8cc57d). Branch `task/S-12-persistenz-grundlage`, Spitze 87aecad; Commits fe87a85 (Konfiguration und Startprüfung), 107d744 (Tests), 87aecad (`docs/persistenz.md`). fe87a85 allein ist nicht grün, erst mit 107d744.
- **Repo:** server
- **Ziel:** PostgreSQL mit Hibernate ORM (Panache im Repository-Muster) und Flyway mit V1-Migration (E9).

## Nachweise (gegen PostgreSQL, Dev Services, `postgres:18`)
- Flyway wendet V1 an. Hibernate validiert das Schema (Gegenprobe mit falschem Spaltennamen schlägt fehl).
- Speichern, Ändern und Lesen über den Platzhalter mit Mapping auf die Domain.
- E19 umgesetzt: Datenbank-Tests sind Pflicht. `-Ddatenbank.tests=aus` überspringt mit WARN; jeder andere Wert ist ein Fehler.
- `mvn package` 20 grün, 0 übersprungen. Mit `aus`: 15 grün, 5 übersprungen.
- Prod-Profil: ohne `QUARKUS_DATASOURCE_*` Exit 1; mit Variablen läuft es gegen einen eigenen Container.
- Nach Merge (`integration/server`, a8cc57d): `mvn clean package` ohne Schalter, 46 Tests grün, keiner übersprungen.

## Befund und Korrektur
- Ohne URL startete die Anwendung im Prod-Profil ohne Datenbank und Migration (Quarkus schaltet die Datasource still ab).
- Behoben durch die Startprüfung `infrastructure.persistenz.DatenbankPflichtPruefung`. In `%test` per `trainingsapp.datenbank.pflicht=false` abgeschaltet; im Testprofil `MitDatenbank` wieder an.

## Ungeprüft
- Verhalten ganz ohne Docker (nicht nachstellbar).
- Dev-Modus ohne Container-Laufzeit (nur abgeleitet).
- Aufruf von `/v1/info` im Prod-Profil (Befehl wurde verweigert).

## Hinweise
- Warnung zu `quarkus-junit5` (in Quarkus 3.40 veraltet, umbenannt in `quarkus-junit`) besteht weiter; bei S-07 notiert.
- Testcontainers meldet, dass Container-Wiederverwendung nicht unterstützt wird (nur Hinweis).
- Ausrichtung: Schema `public`, snake_case, Tabellen im Singular; UUIDs von der Anwendung vergeben; Migrationen `V<n>__<beschreibung>.sql`; `timestamptz` in UTC; Hibernate validiert nur, Flyway legt an.
- Zusammenführung mit S-04 berührt `pom.xml` und `application.properties` (erledigt mit dem Merge; künftige Änderungen beachten).

## Abhängigkeiten
- S-01 (gemergt in `integration/server`).

## Blockiert durch S-12 (jetzt freigegeben)
- S-03, S-04 (Umsetzung), S-02b, S-08.

## Quellen
- ENTSCHEIDUNGEN.md E9, E18 (Reihenfolge), E19 (Datenbank-Tests).
- Nutzerfrage 4 und 8 (Docker/Podman, PostgreSQL): erledigt, Docker nutzbar nach Neustart.
