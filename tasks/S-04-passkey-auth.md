# S-04 – Passkey-Authentifizierung (Umsetzung nach Spike)

- **Status:** umgesetzt und geprüft (ohne unabhängiges Gutachten), in `integration/server` gemergt. Branch `task/S-04-passkeys`, Spitze e708fb4. Alle zwölf Abnahmekriterien laut Worker erfüllt; `mvn clean package` ohne Schalter 308 Tests grün (Branch), 0 übersprungen; E2E mit virtuellem Authenticator von Chromium als Pflicht (Schalter `-De2e.tests=aus`, analog E19); Start des Jars im Prod-Profil mit `scripts/prod-start-pruefung.sh` belegt. Doku: `docs/auth-erweiterung.md`, `docs/auth-annahmen.md`, `docs/auth-betrieb.md`. Vorheriger Stand: Phase A abgeschlossen (Spitze 003b2cc, 110 Tests grün gegen PostgreSQL, keiner übersprungen; Migrationen V2, V3). Phase B läuft in kleinen Runden; die Worker-Sitzung ist erneut technisch abgebrochen und wurde wieder angestoßen. Zwischenstand: committet und grün E28 (50f8fec), E26 (d7e9fbe), E29 (d73e2d0), B1-Lücken (4429988), B2 Port, ArchUnit, Allowlist, Abmelden (777c17c), Austauschtest (2dbece9), E25 Pfad-Policy mit 401 (c935191), E14 Cookie-Härtung, CSP, Proxy (3bf6f7c); `mvn clean package` ohne Schalter: 248 Tests grün, 0 übersprungen. Offen: E16 404-Filter und E15 Origin-Prüfung (in Arbeit), E17 Rate-Limit, Nachweise B4, Doku B5. Branch `task/S-04-passkeys`, Worktree `.worktrees/S-04`, Basis `integration/server` a8cc57d. Phase B (Härtung, Nachweise, Erweiterbarkeit) folgt in derselben Worker-Sitzung. S-02c wartet auf Abschluss von Phase A (UUID-Umstellung von `BenutzerId` ändert Timer-Service und Tests).
- **Repo:** server
- **Spike:** Branch `spike/S-04-passkeys` (Commits 01a76ae, e23817c, 15c672f), Worktree `.worktrees/S-04-spike`, Basis `integration/server`, Ergebnisdokument `docs/spike-s04-passkeys.md`. Nicht in `integration/server`. Übernahme als `task/S-04-passkeys` per Rebase (E18), nicht Neuaufsatz.
- **Spike-Ergebnis:** Eingebaute Endpunkte der Quarkus-WebAuthn-Extension können einem angemeldeten Benutzer keinen weiteren Passkey anlegen. Umweg: programmatische API `WebAuthnSecurity` mit eigenen `/v1`-Endpunkten (E13). E3-Akzeptanztest automatisiert grün mit Software-Authenticator. `mvn package`: 39 Tests grün.
- **Aufräumen:** Uncommittete Datei `src/test/java/de/trainingsapp/spike/ProbeTest.java` im Spike-Worktree. Nicht löschen ohne Entscheidung.

## Reihenfolge (E18, verbindlich)
1. S-12-Abnahme (Docker-Gruppe) abschließen und mergen.
2. `spike/S-04-passkeys` auf `integration/server` rebasen und als `task/S-04-passkeys` übernehmen und ausbauen.
3. `BenutzerId` als `record BenutzerId(UUID wert)` umstellen; User-Handle sind die 16 Rohbytes. Erster Commit der Umsetzung.
4. JPA-Adapter für Benutzer, Passkey und ausstehende Registrierung (mit TTL) plus Flyway-Migration.
5. Härtung nach E14 bis E17 und Abnahme nach E23.

## Architektur (E13, E15, E23)
- Nur `WebAuthnSecurity`; `register` und `login` unter `/q/webauthn` aus (E13). Befund-Tests des Spikes bleiben dauerhaft.
- Eigene `/v1`-Endpunkte: Registrierung (Optionen und Abschluss), zweiten Passkey hinzufügen, Passkeys listen, Passkey löschen (letzter nicht löschbar), Anmelden (Optionen und Abschluss), Abmelden.
- Port `Anmeldesitzung` (aus Sicht der Use-Cases): `aktuellerBenutzer()`, `anmelden(BenutzerId)`, `beenden()`; neutrales Ergebnis.
- Port `PasskeyZeremonie`; erlaubte Origins und rpId als Konfiguration mit Allowlist.
- Schichtgrenze (E23): `SecurityIdentity`, Cookie-, Vert.x- und Extension-Typen nur in `infrastructure`. `application` kennt nur `BenutzerId`. `@Authenticated` und `@RolesAllowed` bleiben in `api.v1` erlaubt.
- Sitzung per Cookie (E15): `HttpOnly`, `Secure` (Prod), `SameSite=Strict` per Vert.x-Filter auf `quarkus-credential` und `_quarkus_webauthn_challenge` (E14); strikte CSP; Origin-Prüfung für schreibende Requests.

## Funktionale Anforderungen
- Rate-Limit je IP auf `registrieren/optionen`, `registrieren` und `anmelden/optionen` (E17).
- Ausstehende Registrierung mit TTL in der Datenbank (E18, Schritt 4).
- Benutzername: Validierung ohne `@`; UI-Hinweis "keine E-Mail, kein Klarname" (E17).
- Wiederherstellung nur über Passkeys; keine anderen Verfahren (README).
- Einwilligung bei der Registrierung (Art.-9-Arbeitsannahme, E7).
- Nach Registrierung fordert die App aktiv einen zweiten Passkey an.
- Nur `/v1/registrieren` und `/v1/anmelden` (inkl. Optionen-Endpunkte) sind ohne Anmeldung erreichbar. Alle anderen `/v1/*` ohne Anmeldung: 401 als JSON (E25).
- Pfad-Policy für `/v1/*`: 401 statt 302, auch für nicht vorhandene Pfade (E25). Zu verifizieren: eigene Challenge bzw. Weiterleitung auf `login-page` abschalten.
- Quarkus-Update-Regel: grüne Befund-Tests und Blick auf quarkus#44292 (E13).

## Abnahme (E23, verbindlich)
1. Akzeptanztest E3 gegen PostgreSQL grün; Flyway-Migration; ausstehende Registrierungen mit TTL; `BenutzerId` als UUID.
2. Härtungstests aus E14 bis E17 grün (`HttpOnly`/`Secure`/`SameSite`, CSP, 404 für `/q/*`, nie 302, Origin-Prüfung, Rate-Limit).
3. Nachweise: E2E mit dem virtuellen Authenticator von Chromium (CDP) gegen eine Testseite, die nur in den Tests existiert (JSON-Format der Optionen und Credentials, zwei Passkeys mit `excludeCredentials`, Anmeldung ohne Benutzernamen); Unit-Tests für RS256, EdDSA und Signaturzähler 0; Prod-Konfiguration für `origins`, `rpId`, `Secure` und `encryption-key` per Umgebungsvariable, mit Test.
4. Port `Anmeldesitzung` mit Methoden `aktuellerBenutzer()`, `anmelden(BenutzerId)`, `beenden()`, neutrales Ergebnis.
5. ArchUnit-Test: In `domain`, `application` und `api.v1` keine Typen aus `io.vertx`, `io.quarkus.security.webauthn` und `SecurityIdentity`.
6. Austauschtest: Eine zweite Sitzungs-Implementierung (Header) existiert nur in den Testquellen. Mit ihr laufen die geschützten Endpunkte unverändert; Ablauf und Widerruf sind getestet.
7. Origins und rpId sind nur über Konfiguration mit Allowlist einstellbar und im Test überschreibbar.
8. `docs/auth-erweiterung.md` beschreibt den Erweiterungspunkt und die bekannte Grenze: Die Challenge liegt beim Cookie-Modell im Cookie; eine Token-Anmeldung braucht dafür einen Server-Speicher. Die Header-Variante kommt nie in die Hauptquellen.
9. `mvn package` grün, mit Datenbank-Tests (nicht mit `aus`).
10. (E26) Port `application.Transaktion` mit Implementierung in `infrastructure` (`QuarkusTransaction.joiningExisting()`) und Fake für Unit-Tests. Registrierung, Passkey-Hinzufügen und `loescheWennNichtLetzter` nach den Phasen in E26; externe Aufrufe nie in der Transaktion. Schreibmethoden der JPA-Adapter mit `@Transactional(MANDATORY)`. ArchUnit-Test verbietet `jakarta.transaction` in `domain`, `application`, `api.v1`. Tests für Rollback (Registrierung, Passkey-Hinzufügen).
11. (E28) `domain.benutzer.Benutzername` mit den sechs Regeln aus E28 (Kleinschreibung mit `Locale.ROOT`, nicht trimmen, Leerraum ist Fehler, Regex, keine Normalisierung, gesperrte Namen aus Konfiguration, UNIQUE und CHECK in der Datenbank). Tests für jede Regel, einschließlich Grenzfälle 2 und 3 Zeichen, 32 und 33 Zeichen, doppelte Sonderzeichen, Leerraum.
12. (E29) V2 anpassen: `bezeichnung` VARCHAR(50) NOT NULL, `erstellt_am` DATE, `zuletzt_verwendet_am` DATE (NULL erlaubt, nur bei Anmeldung, höchstens einmal pro Tag). Automatische Bezeichnung "Passkey n" ohne Wiederverwendung gelöschter Nummern. `PATCH /v1/passkeys/{id}` mit `{bezeichnung}` (NFC, 1 bis 50 Zeichen nach Trim, keine Steuer- oder Formatzeichen, fremd ergibt 404). Tests für Rollback, Namensregeln und `zuletzt_verwendet_am`. Keine IP, kein User-Agent. Vor Änderung von V2 prüfen, dass keine dauerhafte Dev-Datenbank V2 angewendet hat (E29). Migrationen V2 und V3 bleiben bis zum ersten Merge nach `integration/server` änderbar.

## Befunde aus dem Spike (unverändert gültig)
- Routen unter `/q/webauthn` nicht konfigurierbar; per Deny-Policy gesperrt ergibt 302 (E16: nicht als Sperre akzeptiert).
- Sitzung zustandslos, ohne Widerruf, `SameSite=Strict`, nicht `HttpOnly` (E14 behebt das).
- Benutzernamen über 409 bei Registrierung aufzählbar (E17: hingenommen, mit Rate-Limit).
- Unverifiziert: JSON-Format von `navigator.credentials` (E2E klärt), Plattform-Authenticatoren mit stabilem User-Handle und `excludeCredentials`, Anmeldung ohne Benutzernamen (E2E), andere Schlüsseltypen als ES256 (Unit-Tests RS256, EdDSA), Reverse Proxy und HTTPS (S-14).

## Spätere Nachweise (nicht Teil von S-04)
- C-03: derselbe E2E-Test gegen die echte PWA.
- C-07: Handtest mit echten Plattform-Authenticatoren (iCloud, Google, Windows Hello).
- S-14: Proxy und HTTPS im Betrieb.
- C-15: native Passkeys und Token (zurückgestellt).

## Abhängigkeiten und Blockierungen
- Abhängig von: S-01, S-02a, S-12 (Abnahme und Merge).
- Blockiert: S-05, S-02b, S-08, C-03.
- Zusammenführung S-12 mit `integration/server` berührt `pom.xml` und `application.properties`.

## Lücken und Abweichungen (Worker, Stand e708fb4; Nutzerentscheid H: keine unabhängige Nachprüfung)
- Kein Test, dass Benutzernamen NICHT Unicode-normalisiert werden.
- Gesperrte Namen nur im Unit-Test, nicht über die echte Konfiguration.
- Tageswechsel von `zuletzt_verwendet_am` nicht mit gestellter Uhr über den Service getestet.
- Kopiertes Sitzungs-Cookie bleibt nach dem Abmelden bis zum Ablauf gültig (Bauart, kein Test).
- Zusätzliche Tabelle `verbrauchte_challenge`; V3 umbenannt in `V3__registrierung_und_challenge.sql`. Migrationsregel E29: V2 und V3 sind mit dem Merge unveränderlich.
- Zähler `letzte_passkey_nummer` liegt in `benutzer`.
- AAGUID wird nicht gespeichert.
- EdDSA-Fehler im Zusammenspiel Quarkus/webauthn4j: Umgehung und Befund-Test vorhanden.
- Upstream-Issue zu `HttpOnly` (E14) nicht angelegt.
- Health und Management-Port (E12) fehlen im Repo ganz (eigener Task S-17, "offen, nicht Teil des Prototyps"). `/q/openapi` ist in Prod nur durch den Filter gesperrt; die Extension ist nicht abgeschaltet.
- Für S-14 notieren: Proxy muss `X-Forwarded-For` überschreiben statt anhängen; Anwendung nur über den Proxy erreichbar; `TRAININGSAPP_TRUSTED_PROXIES`; genau eine Instanz (Rate-Limit im Speicher).

## Quellen
- ENTSCHEIDUNGEN.md E3, E7, E13–E18, E23, E25.
- server/README.md, "Muss-Kriterien" (Passkeys, keine anderen Verfahren).
- Offene Nutzerfrage 3: Konto ohne Passkey endgültig verloren – akzeptabel?
