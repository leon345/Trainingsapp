# S-03 – Workout- und Calisthenics-Tracking (Domain + API + Erweiterungsport)

- **Status:** offen, blockiert (S-04-Umsetzung). S-12 ist in `integration/server` gemergt. Die Erweiterungsschnittstelle ist entschieden (E22); der frühere Blocker entfällt.
- **Repo:** server
- **Ziel:** Workouts (KRAFT und CALISTHENICS) anlegen, lesen, ändern, löschen gemäß E5; zusätzlich Herkunft und Import-Port gemäß E22.
- **Betroffene Bereiche:** `domain` (Workout, Übung, Satz, Herkunft), `application` (Services, Repository-Port, `application.erweiterung.WorkoutImport`), `infrastructure` (JPA, Flyway-Migration), `api.v1` (Endpunkte), `docs/erweiterungen.md`, OpenAPI.

## Datenmodell (E5, verbindlich, erweitert um E22)
- **Workout:** id (UUID), ownerId, typ (KRAFT oder CALISTHENICS; später SCHWIMMEN), titel (max. 100), startZeit (UTC), dauerSekunden (optional), notiz (optional, max. 500), sichtbarkeit (Standard PRIVAT), erstelltAm, geaendertAm, version.
  - **E22:** `herkunft` (Enum `Herkunft`, Standard `MANUELL`), `externeId` (optional, max. 200 Zeichen, Pflicht außer bei `MANUELL`).
- **Übung:** id, workoutId, position, name (max. 100), variante (optional, Text, z. B. "Tuck").
- **Satz:** id, uebungId, position, wiederholungen oder dauerSekunden (eines davon Pflicht), gewichtKg (optional; bei Calisthenics Zusatzgewicht), pauseSekunden (optional).
- Index auf (ownerId, startZeit). E22: eindeutiger Teilindex auf (`owner_id`, `herkunft`, `externe_id`) mit `WHERE externe_id IS NOT NULL`.
- Keine Gesundheitsdaten (Puls, Körpergewicht). Intervalle bleiben bei S-02. Kein Übungskatalog.

## Enum `Herkunft` (E22)
- `MANUELL` und `APPLE_HEALTH`. `APPLE_HEALTH` ist reserviert, es gibt keinen Adapter. Neue Quellen ergänzen das Enum per Flyway-Migration.

## Erweiterungsport (E22)
- `application.erweiterung.WorkoutImport` mit `importiere(BenutzerId, Herkunft, externeId, WorkoutDaten)`.
- Idempotent: für denselben Schlüssel (Besitzer, Herkunft, externeId) wird aktualisiert statt doppelt angelegt.
- Dieselbe Validierung wie bei manueller Eingabe. Importierte Workouts sind immer PRIVAT.
- Implementierung in `application`, Unit-Tests für Idempotenz, Validierung und PRIVAT.
- Kein Export-Port (E22): Der Server exportiert über das JSON aus E7.
- `docs/erweiterungen.md`: was ein Adapter liefern muss; Regel "keine Anbindung ohne eigene Einwilligung" (Art. 9, siehe S-08).

## Transaktionen (E26)
- Schreibende Use-Cases nur über den Port `application.Transaktion`. Externe Aufrufe nie in der Transaktion. Schreibmethoden der JPA-Adapter mit `@Transactional(MANDATORY)`.

## Abnahmekriterien
- CRUD über versionierte Endpunkte unter `/v1`.
- Nur authentifiziert; Zugriff nur auf eigene Workouts über Policy-Service (S-05).
- Validierung gemäß Feldlängen und Pflichtfeldern; Dauern als Integer-Sekunden (E11).
- `herkunft`/`externeId`-Regeln gemäß E22 getestet.
- Index-Migration und Teilindex vorhanden.
- OpenAPI-Dokumentation aller Endpunkte.
- Unit- und Integrationstests.

## Abhängigkeiten
- S-01, S-12 (Persistenz; Merge), S-04 (Authentifizierung, `BenutzerId`), S-05 (Policy).
- Nicht mehr blockiert durch die Erweiterungsschnittstelle (E22). Frage 14 ist beantwortet: interne Server-Schnittstelle (Nutzer, 18.11.2026). S-03 ist an dieser Stelle nicht mehr offen.

## Quellen
- ENTSCHEIDUNGEN.md E5, E11, E22; Nutzerentscheid B (18.11.2026).
- server/README.md, "Muss-Kriterien" (Workouts tracken).
- Hinweis: Calisthenics-Felder sind über E5 festgelegt.
