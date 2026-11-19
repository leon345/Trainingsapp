# Entscheidungen des Council – Trainingsapp

Datum: 18.11.2026
Beschluss durch den Council-Vorsitz. Der Nutzer hat dem Council alle Entscheidungen übertragen.
Worker lesen diese Datei als verbindliche Referenz. Abweichende Meinungen sind festgehalten, aber nicht bindend.

---

## E1 (C-01) Frontend
- **Beschluss:** React 19 mit TypeScript und Vite, PWA, eine Codebasis für Mobil und Desktop. Bedienelemente auf React Aria Components (liefert Barrierefreiheit, kein eigenes Aussehen). Tests mit Vitest und Playwright (WebKit, Firefox, Chromium, Mobil-Emulation). Native Hülle später per Capacitor. Kein Flutter, kein Kotlin Multiplatform.
- **Grund:** breitestes Ökosystem, meiste Stimmen (B2, B5).
- **Noch zu verifizieren (Spike C-01b, max. 2 Tage, braucht iOS-Gerät):**
  - Läuft der Timer unter iOS-Safari bei gesperrtem Bildschirm genau genug (Wake Lock, Zeit aus Zeitstempeln statt setInterval)?
  - Funktionieren Passkeys im Capacitor-WebView unter iOS?
- **Arbeitsannahme:** Timer berechnet die Restzeit aus Zeitstempeln, nicht aus setInterval-Zählung.
- **Abweichende Meinungen:** B4 wollte Preact oder Svelte; B5 hielt Svelte für gleichwertig.
- **Nachtrag (E15):** Capacitor (C-11, C-13) braucht vorher einen eigenen Task für native Passkeys und Token-Sitzung (C-15). Capacitor ist nicht Teil der S-04-Umsetzung.

## E2 (C-06) Material Design 3 Expressive
- **Beschluss:** `@material/web` wird NICHT die Basis. Eigenes Token-Paket mit CSS-Variablen (Farbe, Form, Motion, Typografie). Farbschemata über `@material/material-color-utilities`. Komponenten auf React Aria. Schriften und Icons selbst gehostet, keine fremden CDNs.
- **Grund:** Der Vorsitz hat geprüft (m3.material.io/develop/web), dass Material Web seit Juni 2024 im Wartungsmodus ist. Expressive ist dort nicht umgesetzt und laut Maintainer (Mai 2025) nicht geplant.
- **Noch zu verifizieren:** Welche Expressive-Tokens lassen sich aus Material Theme Builder bzw. der Spezifikation exportieren? Der Komponentenumfang wird in C-06 festgelegt.
- **Arbeitsannahme:** Token werden aus Spezifikation/Theme Builder manuell in CSS-Variablen übernommen.
- **Abweichende Meinungen:** Alle fünf Berater wollten `@material/web`. Durch die Prüfung überholt.
- **Nachtrag (Nutzerentscheid C, 18.11.2026):** Visuelle Tests nur in Chromium, gegen den Test-Build. Keine Referenzbilder für Firefox, WebKit oder Mobil. Siehe Abschnitt "Nutzerentscheid C".

## E3 (S-04) Passkeys
- **Beschluss:** Spike mit hartem Limit 1 Tag, mit In-Memory-Ablage. Akzeptanz: Ein Benutzer registriert zwei Passkeys, meldet sich mit jedem an, listet sie, löscht einen. Den letzten Passkey kann er nicht löschen. Bei Erfolg Quarkus-WebAuthn-Extension, sonst webauthn4j. Beides hinter eigenem Port-Interface. Wiederherstellung nur über Passkeys (README verbietet andere Verfahren). Die App fordert nach der Registrierung aktiv einen zweiten Passkey an.
- **Noch zu verifizieren im Spike:** Der Ablauf, mit dem ein angemeldeter Benutzer einen weiteren Passkey hinzufügt.
- **Arbeitsannahme:** Die Registrierung eines zweiten Passkeys geschieht im angemeldeten Zustand.
- **Abweichende Meinungen:** keine genannt.

## E4 (S-05) RBAC/ABAC
- **Beschluss:** Rollen USER und ADMIN. ADMIN nur für Betrieb, darf keine fremden Trainingsdaten lesen. Deny-by-default. Jeder Objektzugriff wird in der Application-Schicht über einen Policy-Service geprüft (Schutz vor IDOR). Keine externe Policy-Engine. Attribute: `ownerId`, `sichtbarkeit`, Einladung (`workoutId`, `eingeladenerId`, `status`). Das Recht `recht` (LESEN/SCHREIBEN) kommt erst mit S-11.
- **Grund:** Keine externe Abhängigkeit, Schutz vor IDOR an einer zentralen Stelle.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** B2, B3, B5 hielten ADMIN für überflüssig.

## E5 (S-03) Datenmodell
- **Beschluss:** Ein gemeinsames, normalisiertes Modell mit Typ-Feld, vorerst ohne Übungskatalog.
  - **Workout:** id (UUID), ownerId, typ (KRAFT oder CALISTHENICS, später SCHWIMMEN), titel (max. 100), startZeit (UTC), dauerSekunden (optional), notiz (optional, max. 500), sichtbarkeit (Standard PRIVAT), erstelltAm, geaendertAm, version.
  - **Übung:** id, workoutId, position, name (max. 100), variante (optional, Progressionsstufe als Text, z. B. "Tuck").
  - **Satz:** id, uebungId, position, wiederholungen oder dauerSekunden (eines davon Pflicht), gewichtKg (optional, bei Calisthenics Zusatzgewicht), pauseSekunden (optional).
  - Index auf (ownerId, startZeit). Keine Gesundheitsdaten (Puls, Körpergewicht). Intervalle bleiben bei S-02.
- **Grund:** Ein Modell mit Typ-Feld vermeidet Doppelpflege; Übungskatalog wird erst gebraucht, wenn er konkret ist.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** Felder aus diesem Beschluss sind vollständig für KRAFT und CALISTHENICS.
- **Abweichende Meinungen:** B2 wollte getrennte Modelle je Typ. B2, B4, B5 wollten den Übungskatalog sofort.
- **Erweiterung durch E22 (Council, 18.11.2026):** Workout-Felder `herkunft` und `externeId`, Teilindex und Port `WorkoutImport` ergänzen dieses Modell. Teil desselben Beschlusses E22, keine erneute Bestätigung nötig.

## E6 (S-06) Sichtbarkeit
- **Beschluss:** Öffentliche Workouts sehen alle angemeldeten Benutzer im Profil des Besitzers. Anonyme Besucher sehen nie etwas. Kein globaler Feed. Profil nur über eine nicht erratbare UUID, dazu Rate-Limit gegen Durchprobieren.
- **Grund:** Entscheidet die offene Frage aus dem README.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.

## E7 (S-08, C-08) DSGVO-Scope
- **Beschluss:**
  - Export als JSON (synchron).
  - Kontolöschung sofort mit allen abhängigen Daten.
  - Datenminimierung, Standard-Sichtbarkeit privat.
  - Logs ohne Personenbezug, 14 Tage aufbewahrt.
  - Backups verfallen nach 30 Tagen.
  - TLS und Security-Header, Hosting in der EU.
  - Kein Tracking, keine Drittdienste, kein Cookie-Banner.
  - Verarbeitungsverzeichnis und TOM-Beschreibung.
  - Datenschutzerklärung im Client.
  - Ziel WCAG 2.1 AA.
- **ARBEITSANNAHME (rechtlich nicht geklärt, kein Beschluss):** Trainingsdaten gelten vorsorglich als Gesundheitsdaten nach Art. 9 DSGVO. Deshalb ausdrückliche, gesonderte Einwilligung bei der Registrierung. Widerruf löst die Kontolöschung aus.
- **Noch zu verifizieren:** Rechtliche Prüfung, ob Trainingsdaten Gesundheitsdaten nach Art. 9 sind (offene Frage 2). Verantwortlicher (offene Frage 1).
- **Abweichende Meinungen:** B4, B5 wollten Einwilligung nur bei Tracking. B4 wollte Export und Löschung als asynchrone Jobs.

## E8 goals/-Verweis
- **Beschluss:** Im Server-README wird der Verweis auf `goals/` durch "werden als prüfbare Tasks umgesetzt" ersetzt. Akzeptanzkriterien stehen in `docs/` des jeweiligen Repos. Es gibt keinen `goals/`-Ordner.
- **Grund:** `tasks/` liegt außerhalb der Repos. Ein getrennt geklontes Repo darf keine toten Verweise enthalten.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.
- **Hinweis:** Die Änderung am Server-README macht ein Worker (Task S-13). Der Vorsitz hat nichts in den Repos geändert.

## E9 Persistenz
- **Beschluss:** PostgreSQL mit Hibernate ORM (Panache im Repository-Muster) und Flyway ab der ersten Migration. Einbau in neuem Task S-12 "Persistenz-Grundlage", nach S-01 und vor S-03 und S-04. Ports (Repository-Interfaces) in `domain` bzw. `application`. Datenbank-Klassen nur in `infrastructure`, mit Mapping auf die Domain-Objekte. Bis S-12 fertig ist, nutzen S-02a und der S-04-Spike In-Memory-Adapter. Zugangsdaten nur in `%dev` und `%test`, Prod per Umgebungsvariablen.
- **Noch zu verifizieren zu Beginn von S-12:** Laufen Docker oder Podman auf dem Dev-Rechner (CI ist nicht definiert)? Falls nicht: lokale PostgreSQL-Instanz über `%dev`-Datasource.
- **Arbeitsannahme:** Lokale Entwicklung läuft mit einer Datenbank, die der Worker über `%dev` anbinden kann.
- **Abweichende Meinungen:** B3 wollte In-Memory und spätere Wahl.

## E10 Timer-Besitzer
- **Beschluss:** S-02 wird geteilt.
  - **S-02a (jetzt):** Application-Service "Einstellung lesen/speichern" mit Repository-Port und In-Memory-Adapter, Unit-Tests, DTO-Schema in `docs/api-konventionen.md`.
  - **S-02b:** `GET` und `PUT /v1/timer/einstellung`, genau eine Einstellung je angemeldetem Benutzer, ohne ID im Pfad, dazu JPA-Adapter. Hängt ab von S-04, S-05, S-12.
  - C-02 startet nach C-01a und speichert zunächst lokal. Nur der Server-Abgleich wartet auf S-02b. Kein Dummy-Endpunkt.
- **Arbeitsannahme:** Eine Einstellung pro Benutzer reicht.
- **Abweichende Meinungen:** B3 wollte eine globale Einstellung.

## E11 Dauern
- **Beschluss:** Projektweit ganze Sekunden als Integer, Einheit im Feldnamen (`trainingSekunden`, `pauseSekunden`, `dauerSekunden`). Minimum und Maximum per `@Schema` und Bean Validation im OpenAPI-Schema. Kein ISO-8601. Im Client ein zentraler Formatierer (mm:ss) mit Tests in C-09.
- **Nachtrag (E21, präzisiert E11):** Unter 3600 s `mm:ss` (z. B. `00:30`, `59:59`), ab 3600 s `h:mm:ss` (z. B. `1:00:00`, bis `24:00:00`). Eine zentrale Funktion mit Grenzwert-Tests liefert zusätzlich ein `aria-label` in Worten.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.

## E12 Öffentliche Endpunkte und Betrieb
- **Beschluss:**
  - `/q/openapi` und Swagger-UI im Prod-Profil abgeschaltet, in Dev und Test aktiv.
  - Spezifikation bei jedem Build als Artefakt (`store-schema-directory`). Der Client generiert daraus seine Typen.
  - `/v1/info` bleibt. Ab S-05 nur mit Anmeldung. Bis dahin im Prod-Profil per Deny-Policy gesperrt. Dient S-07 als Testziel.
  - Health über das Management-Interface auf eigenem, nicht öffentlichem Port.
  - Ein Test prüft, dass im Prod-Profil kein `/q/*` erreichbar ist.
- **Noch zu verifizieren:** Genaue Property-Namen in Quarkus 3.40 (v. a. `quarkus.smallrye-openapi.enable`, `quarkus.management.enabled`).
- **Arbeitsannahme:** Betrieb als Container hinter Reverse Proxy.
- **Nachtrag (E16):** 302 gilt NICHT als Sperre. Drei Schichten: (1) Vert.x-Route-Filter antwortet im Prod-Profil mit 404 für alle `/q/*` und `/.well-known/webauthn`; (2) Deny-Policy als zweite Schicht; (3) Betriebsvorgabe: Der Proxy leitet nur `/v1/*` und PWA-Dateien weiter, alles andere 404 (S-14).
- **Nachtrag (E25, präzisiert E12):** `/v1/info` ohne Anmeldung ist 401 als JSON, ab S-04 mit `@Authenticated`; die Deny-Policy für diesen Pfad entfällt. Der Widerspruch E16 gegen E12 ist aufgelöst. Lücke bis S-04 siehe E25.
- **Abweichende Meinungen:** B3 wollte `/v1/info` entfernen.

---

## E13 Passkey-Lösung
- **Beschluss:** Die Quarkus-WebAuthn-Extension wird nur über `WebAuthnSecurity` genutzt, mit eigenen `/v1`-Endpunkten. `register` und `login` unter `/q/webauthn` bleiben aus. Die Befund-Tests des Spikes bleiben dauerhaft im Repo. Jedes Quarkus-Update braucht grüne Befund-Tests und einen Blick auf quarkus#44292.
- **Grund:** Der Umweg auf eine Adapter-Klasse beschränkt die Abhängigkeit. Ein Wechsel auf webauthn4j beträfe nur `infrastructure`.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.

## E14 HttpOnly und CSP
- **Beschluss:** Ein Vert.x-Filter setzt `HttpOnly` auf `quarkus-credential` und `_quarkus_webauthn_challenge`. Pflichttest: genau ein `Set-Cookie` je Cookie mit `HttpOnly`, `Secure` (Prod) und `SameSite=Strict`. Dazu strikte CSP (`default-src 'self'`, kein Inline-Skript). Upstream-Issue anlegen.
- **Grund:** Schutz des Sitzungs-Cookies vor Auslesen durch Skripte.
- **Noch zu verifizieren:** `Secure` hinter dem Proxy: `quarkus.http.proxy.proxy-address-forwarding` setzen, Test mit `X-Forwarded-Proto: https`.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.

## E15 Sitzungsmodell und Capacitor
- **Beschluss:** Sitzung per Cookie. PWA und API liegen unter derselben Origin: Der Proxy liefert die PWA unter `/` und leitet `/v1` an Quarkus weiter; CORS entfällt. Gegen CSRF neben `SameSite=Strict` eine Origin-Prüfung (Allowlist) für alle schreibenden Requests. Capacitor ist nicht Teil der S-04-Umsetzung; ein späteres Token-Modell steckt hinter dem Port `Anmeldesitzung`.
- **Änderung an E1:** Capacitor (C-11, C-13) braucht vorher einen eigenen Task für native Passkeys und Token-Sitzung (C-15).
- **Grund:** Vermeidung von CORS und Cross-Site-Cookies.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** Hosting unter derselben Origin (nicht vom Nutzer bestätigt, siehe Frage 11).
- **Abweichende Meinungen:** keine genannt.

## E16 Sperre von `/q/*`
- **Beschluss:** 302 gilt NICHT als gesperrt. Drei Schichten: (1) Vert.x-Route-Filter antwortet im Prod-Profil mit 404 für alle `/q/*` und `/.well-known/webauthn`; (2) Deny-Policy bleibt als zweite Schicht; (3) Betriebsvorgabe: Der Proxy leitet nur `/v1/*` und die PWA-Dateien weiter, alles andere 404. Test im Repo (Prod-Profil): 404 ohne Body und ohne `Set-Cookie` für `/q/openapi`, `/q/swagger-ui`, `/q/health` (Hauptport), `/q/webauthn/{register-options-challenge, login-options-challenge, webauthn.js, logout}` und `/.well-known/webauthn`; 401 als JSON für `/v1/*` ohne Anmeldung, nie 302.
- **Grund:** 302 verrät Routen und setzt ggf. Cookies.
- **Noch zu verifizieren:** Greift der Route-Filter vor dem Permission-Check? Falls nicht, Priorität anheben. Gelingt auch das nicht, akzeptiert der Test hilfsweise "kein 2xx, kein Body, kein `Set-Cookie`".
- **Hinweis:** Die Proxy-Regel ist im Repo nicht testbar und wird dokumentiert (S-14).
- **Nachtrag (E25, präzisiert E16):** Für alle Pfade unter `/v1/*` außer `anmelden*` und `registrieren*` gilt ohne Anmeldung 401, auch für nicht vorhandene Pfade. Test: 401 als JSON, nie 302.
- **Abweichende Meinungen:** B3 hielt 302 für ausreichend. B1, B4, B5 sahen die Sperre hauptsächlich am Proxy.

## E17 Aufzählbarkeit von Benutzernamen
- **Beschluss:** Wird hingenommen. Rate-Limit je IP auf `registrieren/optionen`, `registrieren` und `anmelden/optionen`. Restrisiko in den TOM dokumentiert. Benutzernamen sind Pseudonyme: Validierung ohne `@`, UI-Hinweis "keine E-Mail, kein Klarname".
- **Grund:** Einladen von Benutzern (C-05) macht Namen ohnehin auffindbar. Ohne Passwort gibt es nichts zu erraten.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** B1 und B2 wollten gleichförmige Antworten.

## E18 BenutzerId als UUID
- **Beschluss:** `record BenutzerId(UUID wert)`. User-Handle sind die 16 Rohbytes. Die Umstellung ist der erste Commit der S-04-Umsetzung.
- **Reihenfolge:** (1) S-12-Abnahme nach neuer Anmeldung (Docker-Gruppe) abschließen und mergen; (2) Spike-Branch auf `integration/server` rebasen und als `task/S-04-passkeys` übernehmen und ausbauen, nicht neu aufsetzen; (3) UUID umstellen; (4) JPA-Adapter für Benutzer, Passkey und ausstehende Registrierung (mit TTL) plus Flyway-Migration; (5) Härtung nach E14 bis E17.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.

## E19 Datenbank-Tests
- **Beschluss:** Standard ist Pflicht; ohne Docker schlagen sie fehl. Überspringen nur mit `-Ddatenbank.tests=aus`; das loggt WARN und zeigt die Tests als "skipped". Das bisherige `pflicht` wird zum Standard und als Schalter überflüssig. Eine künftige CI darf `aus` nie setzen.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** B3 wollte immer fehlschlagen. B4 und B5 wollten lokal mit Warnung überspringen.

## E20 GET ohne gespeicherte Timer-Einstellung
- **Beschluss:** 200 mit dem Standard aus `IntervallEinstellung.STANDARD`: Training 30 s, Pause 10 s. `TimerEinstellungV1` bekommt `gespeichert` (boolean, `readOnly`, nur in der Antwort; bei `PUT` ignoriert).
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** B4 wollte 60 s / 30 s.

## E21 Dauer-Format ab einer Stunde
- **Beschluss:** Unter 3600 s `mm:ss` (z. B. `00:30`, `59:59`), ab 3600 s `h:mm:ss` (z. B. `1:00:00`, bis `24:00:00`). Zentrale Funktion mit Grenzwert-Tests; zusätzlich `aria-label` in Worten. Präzisiert E11.
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme:** keine genannt.
- **Abweichende Meinungen:** keine genannt.

## Nachweise vor Abschluss von S-04 (Beschluss E13–E18, Zusammenfassung)
- E2E-Test mit Playwright und dem virtuellen Authenticator von Chromium (CDP) gegen eine Testseite, die nur in den Tests existiert: JSON-Format der Optionen und Credentials, zwei Passkeys mit `excludeCredentials`, Anmeldung ohne Benutzernamen.
- Unit-Tests für RS256, EdDSA und Signaturzähler 0.
- Prod-Konfiguration für `origins`, `rpId`, `Secure` und `encryption-key` per Umgebungsvariable, mit Test.
- Spätere Nachweise: C-03 derselbe E2E-Test gegen die echte PWA; C-07 Handtest mit echten Plattform-Authenticatoren (iCloud, Google, Windows Hello) vor dem ersten Release; S-14 Proxy und HTTPS im echten Betrieb; Capacitor in neuem Task C-15.

---

## E22 Erweiterungsschnittstelle für externe Datenquellen (Council, 18.11.2026)
- **Beschluss:** Umsetzung in S-03, jetzt MIT Port, weil der Nutzer ausdrücklich eine Schnittstelle verlangt.
  - Felder am Workout: `herkunft` (Enum `Herkunft`, Standard `MANUELL`) und `externeId` (optional, max. 200 Zeichen, Pflicht außer bei `MANUELL`).
  - Enum-Werte: `MANUELL` und `APPLE_HEALTH`. `APPLE_HEALTH` ist reserviert; es gibt keinen Adapter. Neue Quellen ergänzen das Enum per Flyway-Migration.
  - Index: eindeutiger Teilindex auf (`owner_id`, `herkunft`, `externe_id`) mit `WHERE externe_id IS NOT NULL`.
  - Port: `application.erweiterung.WorkoutImport` mit `importiere(BenutzerId, Herkunft, externeId, WorkoutDaten)`. Idempotent: für denselben Schlüssel wird aktualisiert statt doppelt angelegt. Dieselbe Validierung wie bei manueller Eingabe; importierte Workouts sind immer PRIVAT.
  - Kein Export-Port: HealthKit läuft auf dem Gerät; der Server exportiert über das JSON aus E7.
  - Doku: `docs/erweiterungen.md` beschreibt, was ein Adapter liefern muss, und die Regel "keine Anbindung ohne eigene Einwilligung" (Art. 9).
- **Grund:** Ein eingehender Port mit Implementierung in `application` ist heute mit Unit-Tests prüfbar (Idempotenz, Validierung, PRIVAT).
- **Noch zu verifizieren:** keine genannt.
- **Arbeitsannahme, vom Nutzer BESTÄTIGT (18.11.2026, Frage 14):** interner Erweiterungspunkt, keine öffentliche Plugin-API ("Ich will eine interne Server-Schnittstelle.").
- **Abweichende Meinungen:** B2 und B3 wollten keinen Port auf Vorrat. B1 und B4 wollten zusätzlich `WorkoutSenke`. B3 wollte den Namen `quelle`. B5 wollte den Index ohne `ownerId`.

## E23 Erweiterbarkeit des Auth-Service (Council, 18.11.2026)
- **Beschluss:** Der Vorschlag des Orchestrators gilt, mit Abwägung: `@Authenticated` und `@RolesAllowed` bleiben in `api.v1` erlaubt (gehören zu Quarkus Security, nicht zum Cookie-Mechanismus). `SecurityIdentity` sowie Cookie-, Vert.x- und Extension-Typen gibt es nur in `infrastructure`. `application` kennt nur `BenutzerId`.
- **Abnahme S-04** (ersetzt das bisherige Kriterium, das als Konkretisierung des Orchestrators gekennzeichnet war):
  1. Akzeptanztest E3 gegen PostgreSQL grün; Flyway-Migration; ausstehende Registrierungen mit TTL; `BenutzerId` als UUID.
  2. Härtungstests aus E14 bis E17 grün (`HttpOnly`/`Secure`/`SameSite`, CSP, 404 für `/q/*`, nie 302, Origin-Prüfung, Rate-Limit).
  3. Nachweise: E2E mit dem virtuellen Authenticator von Chromium; Unit-Tests für RS256, EdDSA und Signaturzähler 0; Prod-Konfiguration per Umgebungsvariable.
  4. Der Port `Anmeldesitzung` ist aus Sicht der Use-Cases benannt (`aktuellerBenutzer()`, `anmelden(BenutzerId)`, `beenden()`) und liefert ein neutrales Ergebnis.
  5. Ein ArchUnit-Test verbietet in `domain`, `application` und `api.v1` Typen aus `io.vertx`, `io.quarkus.security.webauthn` und `SecurityIdentity`.
  6. Austauschtest: Eine zweite Sitzungs-Implementierung (Header) existiert nur in den Testquellen. Mit ihr laufen die geschützten Endpunkte unverändert; Ablauf und Widerruf sind getestet.
  7. Origins und rpId sind nur über Konfiguration mit Allowlist einstellbar und im Test überschreibbar.
  8. `docs/auth-erweiterung.md` beschreibt den Erweiterungspunkt und die bekannte Grenze: Die Challenge liegt beim Cookie-Modell im Cookie; eine Token-Anmeldung braucht dafür einen Server-Speicher. Die Header-Variante kommt nie in die Hauptquellen.
  9. `mvn package` grün, mit Datenbank-Tests (nicht mit `aus`).
- **Noch zu verifizieren:** keine genannt.
- **Abweichende Meinungen:** B2 wollte `@Authenticated` aus `api.v1` verbannen; abgelehnt.
- **Status:** Nutzerentscheid A (Erweiterbarkeit) ist damit vom Council bestätigt.

## E24 `galerie.html` (Council, 18.11.2026)
- **Beschluss:** Umsetzung in C-06, vor dessen Merge. `galerie.html` ist nur im Build `vite build --mode test` enthalten. Dieselbe `vite.config`; der Mode fügt ausschließlich den Einstieg hinzu, keine anderen Plugins oder Defines. Gegen den Produktions-Build (`vite preview`) laufen alle funktionalen E2E-Tests, der Test gegen fremde Hosts und der Service-Worker-Test. Gegen den Test-Build laufen nur die visuellen Tests der Galerie. Gegen Auseinanderlaufen: ein Test prüft, dass der Produktions-Build keine `galerie*`-Dateien enthält; eine ESLint-Regel (`no-restricted-imports`) erlaubt der Galerie nur Importe aus den Produktionskomponenten.
- **Reihenfolge (Orchestrator):** Die Änderung bringt ESLint als neue Abhängigkeit und ändert `package.json`. Weil C-14 dieselbe Datei bearbeitet, wird E24 erst NACH Abschluss von C-14 umgesetzt, als Folgetask **C-06b** auf Basis des C-14-Branches.
- **Noch zu verifizieren:** keine genannt.
- **Abweichende Meinungen:** B4 wollte ein Entry-Flag statt eines Vite-Modes.
- **Nachtrag (Nutzerentscheid C, 18.11.2026):** Visuelle Tests nur in Chromium gegen den Test-Build; funktionale E2E-Tests in allen vier Projekten gegen den Produktions-Build. Siehe Abschnitt "Nutzerentscheid C".

## E25 `/v1/info` ohne Anmeldung (Council, 18.11.2026)
- **Beschluss:** `/v1/info` ohne Anmeldung liefert 401 als JSON über denselben Mapper wie alle `/v1`-Endpunkte; ab S-04 mit `@Authenticated`. Die Deny-Policy für diesen Pfad entfällt.
- **Präzisiert E12:** "ab S-04" statt "ab S-05 nur mit Anmeldung".
- **Präzisiert E16:** Für alle Pfade unter `/v1/*` außer `anmelden*` und `registrieren*` gilt ohne Anmeldung 401, auch für nicht vorhandene Pfade (Pfad-Policy "authenticated", damit nichts über vorhandene Routen verraten wird).
- **Auflösung:** Der Widerspruch E16 gegen E12 (401 oder 403 für `/v1/info`) ist damit aufgelöst.
- **Noch zu verifizieren in S-04:** Wie die Pfad-Policy statt 302 ein 401 liefert (eigene Challenge bzw. Weiterleitung auf `login-page` abschalten).
- **Lücke (Orchestrator, zur Prüfung durch den Council):** Zwischen Merge S-01 und S-04 ist `/v1/info` im Prod-Profil ohne Schutz, weil die Deny-Policy aus E12 entfällt und 401 erst ab S-04 gilt. E12 verlangte die Sperre bis dahin. Vorschlag wäre eine 401-Pfad-Policy schon vor S-04 oder ein Hinweis, dass der Prod-Betrieb bis S-04 nicht stattfindet.
- **Abweichende Meinungen:** B1, B2 und B4 wollten bis S-05 eine 404-Ausnahme.

## E26 Transaktionen (Council, 18.11.2026, gültig für alle Tasks)
- **Beschluss (Variante b):** Port `application.Transaktion` mit `<T> T ausfuehren(Supplier<T>)` und `void ausfuehren(Runnable)`. Implementierung in `infrastructure` mit `QuarkusTransaction.joiningExisting()`. Fake für Unit-Tests.
- **Registrierung:** außerhalb: Rate-Limit, WebAuthn-Prüfung, Challenge-Verbrauch. Innerhalb: ausstehende Registrierung lesen und löschen, Name prüfen, Benutzer anlegen, Passkey speichern. Sitzung erst nach dem Commit.
- **Passkey hinzufügen:** außerhalb: `aktuellerBenutzer()` und Prüfung. Innerhalb: Eindeutigkeit der Credential-ID prüfen und speichern.
- **Löschen** (`loescheWennNichtLetzter`): innerhalb.
- **Grundsatz:** Externe Aufrufe nie in der Transaktion.
- **Gegen Umgehen:** Schreibmethoden der JPA-Adapter mit `@Transactional(MANDATORY)`. ArchUnit-Test verbietet `jakarta.transaction` in `domain`, `application`, `api.v1`.
- **Arbeitsannahme:** Verbrauchte Challenge bei Rollback ist unkritisch.
- **Abweichende Meinungen:** B3 wollte `@Transactional` an den Services.

## E27 Kein `glob`-Override (Council, 18.11.2026)
- **Beschluss:** Die zwei Meldungen bleiben in `docs/dependency-audit.md` als Restrisiko (nur Build-Werkzeug; `--omit=dev` ergibt 0). Workbox-Upgrade als eigener Client-Task (C-16) mit Test des Service-Worker-Caches.

## E28 Benutzernamen (Council, 18.11.2026)
- **Beschluss:** Value Object `domain.benutzer.Benutzername`.
  1. Eingabe mit `toLowerCase(Locale.ROOT)` umwandeln, nicht trimmen. Leerraum ist ein Fehler.
  2. Regex nach der Umwandlung: `^[a-z0-9](?:[a-z0-9]|[._-](?=[a-z0-9])){2,31}$` (3 bis 32 Zeichen, nur ASCII, Anfang und Ende alphanumerisch, keine zwei Sonderzeichen hintereinander).
  3. Keine Unicode-Normalisierung.
  4. Gesperrte Namen aus einer Konfigurationsliste, mindestens `admin`, `root`, `system`, `support`, `trainingsapp`.
  5. Gespeichert und angezeigt wird nur die Kleinschreibung. Spalte UNIQUE mit CHECK derselben Regex.
  6. Beim Einladen (C-05) nur exakte Suche und Anzeige vor dem Einladen.
- **Bewusst akzeptiert:** keine Umlaute, keine Emojis. Verwechslungen wie l/1/i und o/0 bleiben Restrisiko.
- **Abweichende Meinungen:** B1 und B5 wollten Unicode mit NFKC; B4 wollte keinen Punkt.

## E29 Passkeys in der Verwaltung (Council, 18.11.2026)
- **Beschluss:**
  - Felder: `bezeichnung` VARCHAR(50) NOT NULL; `erstellt_am` DATE in UTC; `zuletzt_verwendet_am` DATE in UTC (NULL erlaubt; nur bei Anmeldung geschrieben und nur bei Tageswechsel, höchstens einmal pro Tag).
  - Keine IP, kein User-Agent, keine Geräte- oder Attestierungsdaten.
  - Automatische Bezeichnung "Passkey n" (n = höchstes n des Benutzers plus 1; gelöschte Nummern nicht wiederverwenden).
  - Umbenennen: `PATCH /v1/passkeys/{id}` mit `{bezeichnung}`. Unicode erlaubt, NFC, 1 bis 50 Zeichen nach Trim, keine Steuer- oder Formatzeichen. Nur für den Besitzer (fremd ergibt 404).
  - Im Client nur als Text, nie als HTML.
  - Felder kommen direkt in V2, ebenso die Änderungen aus E28.
  - Regel: V2 und V3 dürfen nur bis zum ersten Merge nach `integration/server` geändert werden; danach sind Migrationen unveränderlich.
- **Noch zu verifizieren:** Dass keine dauerhafte Dev-Datenbank V2 schon angewendet hat.
- **Abweichende Meinungen:** B2 wollte Umbenennen später; B3 keine Bezeichnung; B4 "Passkey vom <Datum>" und Zeitstempel statt reinem Datum.

**Fragen an den Nutzer:** keine.

## Nutzerentscheide G bis J (18.11.2026, Entscheidungen des NUTZERS, keine Council-Beschlüsse)

**G (Registrierung), wörtlich:** "Jeder soll sich jetzt erstmal anmelden können. Es soll erstmal keine Beschränkungen geben. Das löse ich sonst über einen Proxy"
- Registrierung bleibt offen, ohne Code und ohne Obergrenze. Ersetzt den Teil "Registrierung" von E31.
- S-15 wird NICHT gebaut (Status "entfällt durch Nutzerentscheid G"; nicht gelöscht).
- C-18 schrumpft auf den PoC-Hinweis, ohne Codefeld.
- Freigabekriterium 4 lautet nur noch "Rate-Limits wirksam".
- Das vorhandene Rate-Limit aus S-04 (10 Anfragen je 10 Minuten je IP und Endpunkt, konfigurierbar) bleibt bestehen. Der Orchestrator hat das dem Nutzer so mitgeteilt.

**H (Budget), Wortlaut nicht übermittelt; Inhalt laut Orchestrator-Mitteilung:** Der Nutzer hat ein Kostenlimit gesetzt (180 $ gesamt; bei seiner Meldung 110 $ verbraucht).
- Folge: keine weiteren Council-Runden, keine unabhängige Nachprüfung von S-04, todo-manager nur noch gebündelt.

**I, wörtlich:** "Mache das so und setzte nur noch Musskriteiren um"
- Wunsch-Tasks S-09, S-11, C-10, C-12 werden nicht umgesetzt (Status "nicht umsetzen, Nutzerentscheid I").

**J, wörtlich:** "Setzte nur das um damit ein minimaler nutzbarer PRototyp eentsteht"
- **Auslegung des Orchestrators (dem Nutzer so mitgeteilt, vom Nutzer korrigierbar):** Zielumfang ist Registrieren und Anmelden per Passkey plus Timer mit Ton und Vibration, lokal startbar.
- Nicht mehr in dieser Sitzung: S-05, S-03, S-02b, S-06, S-08, S-16, S-14, S-07, Health, C-04, C-05, C-08, C-18, Server-Abgleich der Timer-Einstellung. Diese bleiben als "offen (nicht Teil des Prototyps)" stehen, nicht gelöscht.

**Vermerk zu E31 und E30:** E31 (Registrierung) gilt nur, soweit G ihn nicht ersetzt. E30 und die Folgen aus E/F bleiben in ihrem Umfang wie beschrieben.

## Nutzerentscheid F (18.11.2026, geht E30 vor)
**Wörtlich (mit Tippfehlern übernommen, Antwort auf Frage 21):** "Manifeste und Artifakte werde sleber später erstellen"
- **Entscheidung des NUTZERS, nicht des Council.**
- **Auslegung des Orchestrators (vom Nutzer korrigierbar):** "Manifeste" sind die Kubernetes-Manifeste (Deployment, Service, Ingress für k3s). "Artefakte" sind die Container-Images und alles, was zu ihrem Bau gehört (Dockerfiles, `nginx.conf`). Der Nutzer erstellt beides später selbst.
- **Folgen für S-14:** Entfallen zusätzlich: Dockerfile des Servers, Dockerfile des Clients, `nginx.conf`, alle Kubernetes-Manifeste. Diese sind nicht mehr "zurückgestellt", sondern Sache des Nutzers.
- **Was im Repo bleibt:** Betriebsdokumentation, Anforderungen an die Umgebung, Smoke-Check-Skript, Prüfbarkeit lokal (siehe S-14).

## Nutzerentscheid E (18.11.2026, geht E30 vor)
**Wörtlich (mit Tippfehlern übernommen):** "Das Hosting werde ich später übernehmen mit einer ProgressQL DB und SSL Zeritfertifkten. Mein Server wird bei einm Hosting Anbietr in Deutschland Strato stehen"
- **Entscheidung des NUTZERS, nicht des Council.** Geht dem Council-Beschluss E30 vor, soweit er sich überschneidet.
- **Auslegung des Orchestrators (vom Nutzer korrigierbar):** "ProgressQL DB" ist PostgreSQL. Der Nutzer stellt die Datenbank und die TLS-Zertifikate selbst bereit und richtet das Hosting später selbst ein.
- **Standort:** Deutschland; Hoster: Strato. Damit ist "Hosting in der EU" aus E7 erfüllt.
- **Folgen für S-14 (Auslegung des Orchestrators):** entfallen aus dem Umfang: PostgreSQL als StatefulSet, PVC und NetworkPolicy; Backup-CronJob und Restore-Skript im Repo; cert-manager, ClusterIssuer und Certificate. Vorerst zurückgestellt, nicht gestrichen: Kustomize-Manifeste für k3s.
- **Bleibt im Umfang von S-14:** Server- und Client-Dockerfile, `nginx.conf`, Konfiguration nur über Umgebungsvariablen, `docs/betrieb.md`, Smoke-Check-Skript.
- **Rechtlich:** Der Auftragsverarbeitungsvertrag mit Strato ist Sache des Nutzers. Verantwortlicher für Impressum und Datenschutzerklärung bleibt offen.
- **Offene Frage (Nutzer):** Sollen später Kubernetes-Manifeste (Deployment, Service, Ingress für k3s) im Repo liegen, oder reichen die Container-Images und die Betriebsdoku?

## E30 Betrieb auf k3s (Council, 18.11.2026, Task S-14)
- **Beschluss:**
  - Manifeste mit Kustomize (`k8s/base`, `k8s/overlays/prod`), ohne Helm. TLS über cert-manager mit Let's Encrypt (ClusterIssuer und Certificate im Repo; Installation von cert-manager durch den Nutzer).
  - Datenbank [Vorsitz gegen die Mehrheit]: PostgreSQL als StatefulSet im Cluster (1 Replica, Major-Version fest, local-path-PVC), Zugriff per NetworkPolicy nur vom Server-Pod.
  - Backup: nächtlicher `pg_dump`-CronJob auf ein Volume, 30 Tage aufbewahrt. Restore-Skript in eine Temp-DB mit Smoke-Check ist Teil der Abnahme.
  - Images: JVM-Image auf Temurin 21 JRE als Fast-JAR, non-root, `readOnlyRootFilesystem`, Ressourcenlimits. Client in eigenem nginx-Container (non-root). Images lokal bauen und per `docker save | sudo k3s ctr images import -` einspielen. Tag ist der Git-Kurz-Hash, nie `latest`.
  - Health: Proben über den Management-Port (`/q/health/live`, `/q/health/ready`); der Service veröffentlicht nur den API-Port.
  - Flyway: `migrate-at-start` in Prod, `replicas: 1`, Strategie `Recreate`; kurze Downtime für den PoC akzeptiert.
  - Routing: Traefik leitet `/v1` an den Server und `/` an nginx. nginx antwortet mit 404 für `/q/*` und `/.well-known/*`; SPA-Fallback nur für Pfade ohne Dateiendung. Der E16-Filter im Server bleibt die zweite Schicht.
  - Header: CSP aus E14 setzt nginx (liefert die HTML-Dokumente aus). HSTS per Traefik-Middleware.
  - Im Repo: Dockerfiles (Server und Client), `nginx.conf`, Kustomize-Basis und Overlay (ohne Werte, nur Platzhalter), Backup-CronJob, Restore-Skript, `docs/betrieb.md`, Smoke-Check-Skript für die Live-Domain.
  - Sache des Nutzers: Domain und DNS, cert-manager installieren, Secrets anlegen (DB, `encryption-key`), Offsite-Kopie der Backups, Host-Härtung (SSH, Firewall, Updates), Standort des Servers, Images bauen und importieren.
- **Abweichende Meinungen:** B1, B3, B4 wollten PostgreSQL auf dem Host; B3 einfache YAML-Dateien und ACME in Traefik; B5 ebenfalls ACME in Traefik.
- **Vermerk:** durch Nutzerentscheid E teilweise ersetzt: Datenbank, TLS und Cluster-Manifeste liegen beim Nutzer bzw. sind zurückgestellt.
- **Vermerk (Nutzerentscheid F):** durch Nutzerentscheide E und F weitgehend ersetzt; es bleiben die Anforderungen an den Betrieb als Dokumentation.

## E31 Öffentlicher Betrieb als Proof of Concept (Council, 18.11.2026)
- **Beschluss:**
  - Registrierung: Konfiguration `trainingsapp.registrierung.modus` mit `GESCHLOSSEN`, `CODE`, `OFFEN`; in Prod ist `CODE` Standard. Der Code liegt gehasht im Secret und wird in konstanter Zeit verglichen; dazu `max-benutzer` (Standard 20). Prüfung schon in `registrieren/optionen`, vor der 409-Antwort (verringert zugleich die Aufzählbarkeit aus E17). Umsetzung: Task S-15 (Server) und Codefeld in C-18.
  - Hinweis (Wortlaut): "Proof of Concept – vollständig KI-generiert („vibe-coded"). Keine Gewähr für Sicherheit oder Verfügbarkeit. Daten können jederzeit zurückgesetzt werden. Bitte keine sensiblen Angaben eintragen." Orte: Startseite bzw. Anmeldeseite, Registrierung (vor der Einwilligung), Footer jeder Seite, Datenschutzerklärung. Umsetzung in C-18.
  - Technische Freigabe vor öffentlicher Erreichbarkeit: (1) S-04, S-05, S-15, S-16 abgeschlossen; S-07 grün (401- und 404-Tabellen, ArchUnit). (2) E2E mit virtuellem Authenticator (C-03) grün. (3) Smoke-Check gegen die Live-Domain: nur HTTPS, HSTS, CSP, Cookie-Attribute aus E14, `/q/*` ergibt 404, `/v1` ohne Anmeldung ergibt 401. (4) Rate-Limits und Registrierungscode wirksam. (5) Export und Kontolöschung getestet. (6) Backup und Restore einmal auf dem Server durchgespielt und protokolliert. (7) Dependency-Audit von Server und Client ohne hohe oder kritische Befunde. (8) OWASP-ZAP-Baseline-Scan gegen die Live-Domain ohne hohe Befunde. (9) Secret-Scan (gitleaks) beider Repos ohne Fund. (10) PoC-Hinweis sichtbar.
  - Rechtlich, nur durch den Nutzer zu klären und ebenfalls Voraussetzung für die Freigabe: Impressum, Verantwortlicher, Text der Datenschutzerklärung, Rechtsgrundlage nach Art. 9, Auftragsverarbeitung mit Hoster bzw. Rechenzentrum, Haftung. Der PoC-Hinweis ersetzt diese Pflichten nicht.
- **Hinweis des Orchestrators zu Kriterium 7 (offen):** Der Client meldet derzeit 12 hohe Befunde in `npm audit`, alle nur in Entwicklungswerkzeugen (`--omit=dev` ist 0, siehe C-14 und E27). Ob Kriterium 7 den ausgelieferten Code meint oder auch Entwicklungswerkzeuge, ist nicht festgelegt. In "Nächste Council-Runde" aufgenommen.
- **Abweichende Meinungen:** B3 wollte offene Registrierung; B4 Standard `GESCHLOSSEN`.

## E32 Löschregel (Council, 18.11.2026, Task S-16)
- **Beschluss:** Neuer taeglicher Aufräumjob, testbar über einen Uhr-Port, Löschung über den `Transaktion`-Port.
  1. Löscht abgelaufene ausstehende Registrierungen; die TTL bleibt bei 10 Minuten.
  2. Löscht Konten mit null Passkeys, deren Anlage mehr als 14 Tage zurückliegt. Das setzt den Nutzerwunsch wörtlich um, als Sicherheitsnetz. Inaktive Konten löscht der Job ausdrücklich NICHT. Er protokolliert nur Anzahlen, ohne Personenbezug.
  3. Die Regel kommt in Datenschutzerklärung und TOM (S-08).
- **Arbeitsannahme:** Die 14 Tage gelten nur für Konten ohne Passkey. Eine Löschung inaktiver Konten kommt erst nach der Antwort des Nutzers.
- **Mit E7 vereinbar als Speicherbegrenzung (Vorsitz).** Offen: Nach E26 und E3 entsteht ein Konto nicht ohne Passkey; die Regel greift nur in Ausnahmefällen. In "Nächste Council-Runde" aufgenommen.
- **Abweichende Meinungen:** B1, B3, B5 wollten eine TTL von 14 Tagen für ausstehende Registrierungen; B2 und der todo-manager sahen einen Widerspruch zu E7.

## E33 Phasensignale (Council, 18.11.2026, Task C-17)
- **Beschluss:**
  - Port `PhasenSignal` mit `phaseGewechselt(neuePhase)`, Fake für Tests.
  - Auslösung: Die 250-ms-Schleife löst pro Übergang genau einmal aus. Nach Rückkehr aus dem Hintergrund wird nur der letzte Wechsel signalisiert; verpasste werden nicht nachgeholt.
  - Ton: Web Audio mit Sinus-Oszillator ohne Datei; AudioContext beim Tippen auf "Start" entsperrt. Wechsel zu Training: zwei kurze Töne (880 Hz, je 120 ms). Wechsel zu Pause: ein Ton (440 Hz, 200 ms). Ende: drei Töne. Mit Hüllkurve gegen Knacken.
  - Vibration: `navigator.vibrate` mit Feature-Detection: Training `[200]`, Pause `[100,100,100]`, Ende `[300,100,300]`.
  - Sichtbares Signal: immer, mit Text und Farbe sowie `aria-live="polite"`.
  - Einstellung: zwei getrennte Schalter (Ton, Vibration), lokal gespeichert, Standard an. Der Vibrationsschalter ist deaktiviert und mit Hinweis versehen, wenn der Browser keine Vibration unterstützt.
  - Tests: Vitest für Phasenlogik, Einmaligkeit und Schalter; Playwright mit gemocktem AudioContext und gemocktem `vibrate`.
- **Noch zu verifizieren (C-01b, echtes Gerät):** Ton und Vibration unter iOS-Safari, auch bei gesperrtem Bildschirm und mit Stummschalter.
- **Offener Punkt (Orchestrator):** Der Beschluss nennt ein Signal für "Ende", die Timer-UI aus C-02 wiederholt die Runden aber bis zum Anhalten und kennt kein Ende. Der Worker meldet das, statt eine Rundenzahl einzuführen.
- **Abweichende Meinungen:** B1, B2, B5 wollten einen gemeinsamen Schalter.

## Nutzerantworten vom 18.11.2026 (keine Council-Beschlüsse; Wortlaut aus TODO.md übernommen)
Diese Antworten hat der Nutzer selbst in `TODO.md` eingetragen. Sie sind nicht ausgelegt. Mehrdeutigkeiten sind markiert und gehen an den Council bzw. an den Nutzer zurück. Es wurden keine Abnahmekriterien in Task-Dateien geändert.

**Frage 1 (Verantwortlicher, Betriebsform):**
> Mein Plan ist dies öffentlich zu hosten. Aber mit dem Hinweis das hier ein Proof of Konzept und kompleet vibe gecodet ist zu veröffentlichen
- Betroffene Tasks: S-08, C-08 (Scope und Verantwortlicher), S-14 (Betrieb).
- Mehrdeutig: "öffentlich" (öffentlich erreichbar im Internet oder öffentlich als Produkt?). Der Verantwortliche selbst ist nicht ausdrücklich benannt.

**Frage 3 (Konto ohne Passkey):**
> Wenn ich einem Konto kein Passkey hinterlget ist, soll es nach 2 Wochen gelöscht werden
- Betroffene Tasks: S-04, S-08, C-03.
- Widerspruch/Klärung nötig: E7 sieht Kontolöschung sofort auf Antrag vor, nicht automatisch nach Frist. E3 und E26 verhindern ein Konto ohne Passkey by design (Registrierung legt Benutzer und Passkey in einer Transaktion an). Unklar, wann ein Konto "ohne Passkey" entstehen kann, und ob die Frist nur für Konten nach einem Verlust gilt. Council prüfen.

**Frage 4 (Betriebsort, CI):**
> ich will das auf meinem ubunut Server in k3s kubernettes laufen lassen.
- Betroffene Tasks: S-14 (Proxy, TLS, Schlüssel), S-12 (Dev Services, unverändert), E12-Arbeitsannahme (Container hinter Reverse Proxy).
- Mehrdeutig: Standort des Servers (E7 verlangt Hosting in der EU) ist nicht genannt. CI bleibt offen.

**Frage 5 (Merge und Git-Autor):**
> KI Agent {Ki-Model}
- Unklar: Das sieht nach einem nicht ausgefüllten Platzhalter aus. Rückfrage an den Nutzer.

**Frage 11 (gleiche Origin):**
> Ich denke schon, das diese unter selben Domain laufen werden können
- Betroffene Tasks: C-03, S-14, S-04 (Abnahme E23 Punkt 7), Arbeitsannahme E15.
- Mehrdeutig: "denke schon" ist keine Bestätigung. Die Arbeitsannahme E15 bleibt bis zur klaren Bestätigung bestehen.

**Frage 16 (Ton und Vibration beim Phasenwechsel):**
> Beim Phasen Wechsel soll ein Ton und Vibration ausgelösst werden
- Betroffene Tasks: C-02 (Annahme des Workers war "kein Ton und keine Vibration"; Umsetzung und Abnahme müssen angepasst werden, nicht durch den Orchestrator).
- Widerspruch: Die Annahme des Workers und die Antwort widersprechen sich. Außerdem ist zu prüfen, ob die Vibrations-API auf iOS-Safari verfügbar ist (Hinweis des Orchestrators, nicht verifiziert). Der Ton braucht eine Nutzeraktion, bevor er abspielt (Autoplay-Regeln); das ist für C-02 zu klären.
- Zuordnung: Die Antwort steht im Text unter Frage 16, ist aber ohne Nummer eingefügt. Zuordnung als wahrscheinlich, nicht sicher.

**Noch offen (unbeantwortet):** Fragen 2 (Art. 9), 6 (Server-README), 10 (Node-Anforderung), 13 (Quellfarbe), 15 (C-02-Rückfrage).

## Nutzerentscheid D (18.11.2026, keine Council-Beschlüsse)
- Die wiederkehrenden technischen Abbrüche von Worker-Sitzungen ("assistant message prefill") werden nicht weiter untersucht, solange das Produkt Fortschritt macht. Abgebrochene Worker werden wieder angestoßen.

## Nutzerentscheid C (18.11.2026, keine Council-Beschlüsse)
**Wörtlich:** "Führe keine visuellen Tests für jeden Browser aus. Ein Test für Chrome reicht."
- Visuelle Tests (Bildvergleiche) laufen nur noch in Chromium, gegen den Test-Build.
- Funktionale E2E-Tests laufen weiterhin in allen vier Projekten (chromium, firefox, webkit, mobile) gegen den Produktions-Build. **Auslegung des Orchestrators:** Die Vorgabe betrifft nur die visuellen Tests; Safari und Firefox bleiben laut Client-README ein Muss.
- Referenzbilder für Firefox werden entfernt; für webkit und mobile werden keine erzeugt. Der geplante Schritt "Referenzbilder für WebKit und Mobil erzeugen" entfällt.
- Folge: Das Aussehen in Safari und Firefox wird nicht automatisch geprüft, sondern nur beim Handtest in C-07.
- Umsetzung im laufenden Task C-06b (Abnahmekriterien ergänzt).

## Nutzerentscheide vom 18.11.2026 (keine Council-Beschlüsse)

**Nutzerentscheid A (zu Frage 12):** Erstmal keine native App. Der Auth-Service soll so vorbereitet werden, dass er dafür erweiterbar ist. Folgen: C-11, C-13, C-15 zurückgestellt; Erweiterbarkeit als Abnahmekriterium in S-04. **Vom Council mit E23 bestätigt (18.11.2026).**

**Nutzerentscheid B (Apple Health):** Kein Apple Health. Es soll aber über eine Schnittstelle möglich sein, Erweiterungen anzubinden.
- Apple Health wird vorerst nicht umgesetzt. S-10 (Apple Health Server) und C-13 (Apple Health iOS) sind zurückgestellt (nicht gelöscht).
- Der Server soll so gebaut werden, dass Erweiterungen wie Apple Health später über eine Schnittstelle angebunden werden können, ohne dass jetzt eine solche Anbindung gebaut wird.
- **Wie die Schnittstelle aussieht, ist NICHT entschieden.** Mit E22 (Council, 18.11.2026) umgesetzt als interner Port `WorkoutImport`; Auslegung als interner Erweiterungspunkt ist vom Nutzer bestätigt (Frage 14, 18.11.2026).
- **Auslegung des Orchestrators (vom Nutzer korrigierbar):** Gemeint ist ein interner Erweiterungspunkt im Server für spätere Anbindungen, keine öffentliche Plugin-API für Dritte. **Vom Nutzer bestätigt (18.11.2026, Frage 14): "Ich will eine interne Server-Schnittstelle."**
- Hinweis zu E7: Apple Health (Gesundheitsquelle) würde die Art.-9-Frage verschärfen. Das ist bei S-08 vermerkt.

## Offene Fragen an den Nutzer (unbeantwortet)
Vollständige Liste steht in `TODO.md`. Hier die Fragen, die Beschlüsse betreffen:
14. (BEANTWORTET) Ist mit "über eine Schnittstelle Erweiterungen anbinden" (Nutzerentscheid B) ein **interner** Erweiterungspunkt im Server gemeint, über den später selbst gebaute Anbindungen wie Apple Health laufen, oder eine **öffentliche** Schnittstelle, über die Dritte eigene Erweiterungen anbinden? (Aktuelle Auslegung: intern, E22.) **Beantwortet 18.11.2026 – Entscheidung des NUTZERS:** "Ich will eine interne Server-Schnittstelle." Arbeitsannahme E22 damit bestätigt.
1. Wer betreibt die App und ist Verantwortlicher nach DSGVO? Betrieb privat, öffentlich oder kommerziell in der EU?
2. Wird rechtlich geprüft, ob Trainingsdaten Gesundheitsdaten nach Art. 9 sind?
3. Ist es in Ordnung, dass ein Konto ohne einen einzigen Passkey endgültig verloren ist?
4. Wo läuft die App später, gibt es eine CI mit Docker oder Podman?
5. Soll S-01 lokal nach main gemergt werden, und welcher Git-Autor soll in den Commits stehen?
11. Können PWA und API später unter derselben Domain laufen (eine Origin hinter dem Reverse Proxy)? Wenn nicht, muss das Sitzungsmodell (E15) geändert werden.
12. ~~Bleibt die native App mit Apple Health (C-11, C-13) gewünscht?~~ **Beantwortet am 18.11.2026 – Entscheidung des NUTZERS (nicht des Council):** "Erstmal keine native App. Aber der Auth-Service soll so vorbereitet werden, dass er dafür erweiterbar ist." Folgen: C-11, C-13, C-15 und S-10 zurückgestellt (nicht gelöscht); C-01b ohne Passkey-Teil; Erweiterbarkeit als Abnahmekriterium in S-04 (Konkretisierung durch den Orchestrator, Bestätigung durch den Council offen).
