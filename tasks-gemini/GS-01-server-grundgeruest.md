# Task GS-01: Server-Grundgerüst (Quarkus 3.40.1.2, DDD/ArchUnit, PostgreSQL/Flyway, OpenAPI)

- **ID:** `GS-01`
- **Repo:** `server`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** keine
- **Branch:** `gemini-task/GS-01-server-grundgeruest`
- **Worktree:** `.worktrees/gemini-GS-01`

## Ziel

Aufbau des frischen Server-Grundgerüsts mit Quarkus `3.40.1.2` (Java 21, Maven) auf Basis einer strengen DDD-Schichtenarchitektur (`domain`, `application`, `infrastructure`, `api.v1`), PostgreSQL-Persistenz (Hibernate ORM Panache + Flyway + Dev Services), OpenAPI-Export unter `/v1`, Management-Health-Interface und Quarkus-Standard-Bordmitteln für Transaktionen (`@Transactional`), Security-Header (`quarkus.http.header.*`) sowie `/q/*`-Konfiguration in `%prod`.

## Abnahmekriterien

1. **Quarkus & Build:**
   - Quarkus `3.40.1.2`, Java 21, Maven-Build (`./mvnw clean verify` bzw. `mvn clean package`) läuft mit Datenbank-Tests (PostgreSQL über Dev Services/Docker) grün durch (`-Ddatenbank.tests=aus` wird nicht genutzt).
2. **DDD-Schichten & ArchUnit:**
   - Paketstruktur unter `de.trainingsapp`: `domain`, `application`, `infrastructure`, `api.v1`.
   - ArchUnit-Tests prüfen verbindlich:
     - `domain`: 100 % framework-frei (kein JPA, JAX-RS, Vert.x, `jakarta.transaction`, WebAuthn, `SecurityIdentity`).
     - `application`: darf Jakarta CDI und `@Transactional` (`jakarta.transaction.Transactional`) direkt nutzen (kein eigener `Transaktion`-Port-Wrapper), aber **kein** JPA, Vert.x, WebAuthn oder `SecurityIdentity`.
     - `api.v1`: darf Jakarta REST, OpenAPI, Bean Validation und Quarkus Security-Annotationen (`@Authenticated`, `@RolesAllowed`, `@PermissionsAllowed`) nutzen, aber **kein** JPA, Vert.x, WebAuthn oder `SecurityIdentity`.
3. **Persistenz & Uhr:**
   - PostgreSQL + Hibernate ORM Panache + Flyway ab `V1__init.sql` (`hibernate-orm.database.generation=validate` bzw. Flyway `migrate-at-start`), Zugangsdaten nur für `%dev`/`%test` (Prod per Env-Variablen).
   - Port `application.Uhr` (System-Uhr in `infrastructure`, Fake-Uhr für Tests).
4. **API, Fehlerformat, OpenAPI & Quarkus-Bordmittel:**
   - Versionierter Einstiegs-Endpunkt `GET /v1/info` und einheitliches Fehlerformat `FehlerV1` (`code`, `nachricht`, `details`, `zeitstempel`) via ExceptionMapper.
   - OpenAPI-Spezifikation für `/v1` wird beim Build exportiert (`store-schema-directory`).
   - Management-Interface aktiviert (`quarkus.management.enabled=true`) für Health (`/q/health/live`, `/q/health/ready`) auf eigenem Management-Port.
   - `%prod`-Abschaltung über Quarkus-Bordmittel: `%prod.quarkus.smallrye-openapi.enable=false`, `%prod.quarkus.swagger-ui.enable=false`.
   - HTTP-Security-Header (`X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `CSP`) über `quarkus.http.header.*` in `application.properties` (kein eigener Vert.x-Header-Filter).
5. **Dokumentation:**
   - `server/docs/api-konventionen.md` beschreibt Schichten, `FehlerV1`, Sekunden-Konvention (`integer`, z. B. `dauerSekunden`) und OpenAPI-Regeln.
   - `server/README.md` enthält keine toten Verweise auf `goals/`.
