# S-02b – Timer-API und JPA-Adapter

- **Status:** offen
- **Repo:** server
- **Ziel:** Genau eine Timer-Einstellung je angemeldetem Benutzer, abrufbar und speicherbar über die API.
- **Betroffene Bereiche:** `api.v1` (Endpunkte), `infrastructure` (JPA-Adapter), Flyway-Migration für die Einstellung.
- **Abnahmekriterien:**
  - `GET /v1/timer/einstellung` und `PUT /v1/timer/einstellung`; keine ID im Pfad (E10).
  - Nur authentifiziert erreichbar (S-05).
  - Speichern über JPA-Adapter (S-12); In-Memory-Adapter aus S-02a wird für Tests genutzt oder ersetzt.
  - Benutzer sehen nur ihre eigene Einstellung (Policy aus S-05; IDOR-Test).
  - OpenAPI-Schema für Dauern mit Min/Max (E11).
  - Integrationstests vorhanden.
- **Abhängigkeiten:** S-02a, S-02c, S-04, S-05, S-12.
- **Quelle:** ENTSCHEIDUNGEN.md E10, E11; server/README.md, "Muss-Kriterien" (Timer, Authentifizierung).
- **Hinweis:** Kein Dummy-Endpunkt vor S-04/S-05.
- **Aus S-02c (umgesetzt, Merge offen, Basis 003b2cc):** Port und Adapter unverändert. `GET` nutzt `TimerEinstellungService.leseOderStandard(BenutzerId)` (liefert `TimerEinstellungAnsicht(einstellung, gespeichert)`). `PUT` antwortet mit `gespeichert: true`. DTO mit `@Schema(readOnly = true)`. Test: ein mitgesendetes `gespeichert` wird ignoriert und löst keinen 400 aus.
- **E26:** Schreibende Aufrufe nur über `Transaktion` (Port `application.Transaktion`).
- **Entschieden (E20):** `GET` ohne gespeicherte Einstellung liefert 200 mit dem Standard aus `IntervallEinstellung.STANDARD` (Training 30 s, Pause 10 s). `TimerEinstellungV1.gespeichert` (boolean, `readOnly`, nur Antwort; bei `PUT` ignoriert).
- **Noch zu bauen:** `@Schema` und Bean Validation auf dem DTO; Zuordnung der Validierungsfehler zu HTTP 400. Der JPA-Adapter ersetzt den `@DefaultBean`-Adapter aus S-02a automatisch.
