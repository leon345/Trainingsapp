# TODO – Trainingsapp (Gesamtprojekt)

## Wiedereinstieg
- **PROTOTYP ERREICHT (Nutzerentscheid J: Registrieren und Anmelden per Passkey plus Timer mit Ton und Vibration, lokal startbar).**
  - Server: Branch `integration/server`, Worktree `/home/user/trainingsapp/.worktrees/integration-server`, Spitze 9535788 (S-01, S-02a, S-13, S-12, S-04, S-02c und Dev-Eintrag für Origin `http://localhost:5173`); `mvn clean package` ohne Schalter 316 Tests grün, 0 übersprungen. Start: `mvn quarkus:dev` (braucht Docker; Dev-Datenbank ist flüchtig). Anleitung: `docs/prototyp-lokal.md` im Branch.
  - Client: Branch `task/C-03-passkey-ui`, Worktree `/home/user/trainingsapp/.worktrees/C-03`, Spitze 7e1f6aa (ganze Client-Kette bis C-03). Start: Dev-Server auf `http://localhost:5173` mit Proxy für `/v1` nach Port 8080. Anleitung: README-Abschnitt "Prototyp lokal starten".
  - Beleg: `npm run test:e2e:integration` (Chromium mit virtuellen Authenticatoren gegen den echten Server im Dev-Modus, nicht im normalen Lauf): Registrieren, zweiter Passkey, Abmelden, Anmelden ohne Benutzernamen, Sitzung nach Neuladen, Timer, "Name vergeben"; alle acht Schritte bestanden, zweimal. Keine Unstimmigkeit zwischen Client und Server.
  - Einschränkungen: Passkeys nur unter `localhost` (kein Test vom Handy im WLAN); nach Neustart des Servers im Dev-Modus sind Konten weg; ältere Safari-Versionen ohne die JSON-Funktionen von WebAuthn gelten als nicht unterstützt; die Anmeldung schützt noch nichts, der Timer läuft ohne Konto.
  - Nichts ist nach `main` gemergt; `main` in beiden Repos unverändert.
- **Zielumfang Prototyp (Nutzerentscheid J, Auslegung des Orchestrators):** Registrieren und Anmelden per Passkey plus Timer mit Ton und Vibration, lokal startbar. Nicht in dieser Sitzung: S-05, S-03, S-02b, S-06, S-08, S-16, S-14, S-07, Health (S-17), C-04, C-05, C-08, C-18, Server-Abgleich der Timer-Einstellung.
- **In `integration/server` (Spitze f8d2ad4, 316 Tests grün, 0 übersprungen):** S-01, S-02a, S-13, S-12, S-04, S-02c. In Arbeit darauf: Dev-Commit für Origin `http://localhost:5173` (nur Dev-Profil) und `docs/prototyp-lokal.md`.
- **Umgesetzt, Merge offen:** C-17 (Spitze 0b35f4b, Vitest 259/259, Playwright 230/230), C-01a, C-06, C-14 (Bewertung), C-06b (Spitze 8a828e3), C-02 (Spitze 88c13f2, unabhängig nachgeprüft; Abweichung genehmigt), C-16 Teil 1 (Cache-Test, Spitze d132c60; Teil 2 Upgrade wartet auf neue workbox-build-Version).
- **Läuft:** C-03 reduziert (Worker, Branch `task/C-03-passkey-ui`, Basis 0b35f4b). Abbrüche werden nach Nutzerentscheid D wieder angestoßen.
- **Beschlossen:** E1–E33 in `tasks/ENTSCHEIDUNGEN.md` (E30–E33 am 18.11.2026 neu).
- **Nutzerentscheid E (18.11.2026):** Hosting bei Strato (Deutschland); Datenbank (PostgreSQL) und TLS-Zertifikate beim Nutzer; S-14 verkleinert.
- **Nutzerentscheide G–J (18.11.2026, siehe ENTSCHEIDUNGEN.md):** G Registrierung offen ohne Code und Obergrenze (S-15 entfällt; C-18 nur PoC-Hinweis; Freigabe-Kriterium 4 nur Rate-Limits); H Budget 180 $, keine weiteren Council-Runden; I Wunsch-Tasks nicht umsetzen; J Zielumfang Prototyp.
- **Nutzerentscheid F (18.11.2026):** Manifeste und Artefakte (Images, Dockerfiles, nginx.conf) erstellt der Nutzer selbst; S-14 liefert nur Betriebsdoku und Prüfbarkeit (Auslegung des Orchestrators, vom Nutzer korrigierbar). Neu: E26 Transaktionen, E27 kein glob-Override, E28 Benutzernamen, E29 Passkeys in der Verwaltung.
- **Nutzerentscheid D (18.11.2026):** Wiederkehrende technische Abbrüche von Worker-Sitzungen ("assistant message prefill") werden nicht weiter untersucht, solange Fortschritt entsteht; abgebrochene Worker werden wieder angestoßen.
- **Blockiert:** C-01b (iOS-Gerät, Timer-Teil); Quellfarbe C-06 (Frage 13); S-03, S-02b, S-05, S-06, S-11 bis Abschluss S-04; S-14 (Frage 11).
- **Zurückgestellt (Nutzerentscheid):** C-11, C-13, C-15 (keine native App), S-10 (kein Apple Health). Nicht gelöscht.
- **Nächste Schritte (alt, ersetzt durch Abschnitt "Nächste Schritte (spätere Sitzung)"):** (1) C-03 reduziert abschließen. (2) Zusammenspiel Client und Server lokal mit einem durchgehenden Test belegen; Startanleitung fertigstellen (`docs/prototyp-lokal.md`). (3) Stand sichern: Merge der Client-Kette nach `main`-Plan klären; Aufräumliste durch den Nutzer.
- **Git:** `main` in server (e65d322) und client (8d39469) unverändert. Alles Weitere liegt auf lokalen Branches und Worktrees unter `/home/user/trainingsapp/.worktrees/`. Nichts gemergt nach main.

Quellen: `server/README.md`, `client/README.md`. Repos: `server/` und `client/` sind je eigenes Git-Repo (Branch `main`). Dieser Projektordner ist kein Repo.
**Verbindliche Entscheidungen: `tasks/ENTSCHEIDUNGEN.md` (E1–E29, Nutzerentscheide A, B, C).**
Status-Werte: `offen`, `blockiert`, `in Arbeit`, `umgesetzt, Merge offen`, `umgesetzt und geprüft, Merge offen`, `zurückgestellt`, `erledigt`.

## Priorisierte Tasks

| Prio | ID | Titel | Repo | Status | Abhängigkeiten | Datei |
|---|---|---|---|---|---|---|
| 1 | S-04 | Passkey-Umsetzung, Phase B (E23, E26, E28, E29) | server | umgesetzt und geprüft (ohne unabhängiges Gutachten), in integration/server gemergt (Spitze e708fb4) | S-01, S-02a, S-12 | tasks/S-04-passkey-auth.md |
| 2 | S-02c | Timer-Standard 30/10 und Feld `gespeichert` (E20) | server | umgesetzt und geprüft, in integration/server gemergt | S-02a | tasks/S-02c-timer-standard-gespeichert.md |
| 3 | S-12 | Persistenz-Grundlage (PostgreSQL, Panache, Flyway) | server | umgesetzt und geprüft, in `integration/server` gemergt | S-01 | tasks/S-12-persistenz-grundlage.md |
| 4 | S-01 | Quarkus-Grundgerüst, Layered/DDD, OpenAPI, /v1 | server | umgesetzt, in `integration/server`, Merge nach main offen | – | tasks/S-01-quarkus-grundgeruest.md |
| 5 | S-02a | Timer-Einstellung: Service + In-Memory-Adapter | server | umgesetzt, in `integration/server`, Merge nach main offen | S-01 | tasks/S-02a-timer-einstellung-service.md |
| 6 | S-13 | README-Verweis goals/ ersetzen (E8) | server | umgesetzt, in `integration/server`, Merge nach main offen | – | tasks/S-13-readme-goals.md |
| 7 | C-01a | Client-Grundgerüst (React 19, TS, Vite, PWA, Vitest, Playwright) | client | umgesetzt, geprüft (WebKit/Mobil grün), Merge offen | – | tasks/C-01a-client-grundgeruest.md |
| 8 | C-06 | Design Material 3 Expressive (eigenes Token-Paket) | client | umgesetzt, geprüft, Merge offen (Kette C-06 -> C-14 -> C-06b) | C-01a | tasks/C-06-material-design.md |
| 9 | C-14 | Client: Dependency-Audit (Bewertung) | client | abgeschlossen (Bewertung), Merge offen; kein Override (E27) | C-06 | tasks/C-14-client-dependency-audit.md |
| 10 | C-06b | `galerie.html` nur im Test-Build (E24) | client | umgesetzt und geprüft, Merge offen (Spitze 8a828e3) | C-14 | tasks/C-06b-galerie-build-trennung.md |
| 11 | C-02 | Timer-UI, mobil bedienbar (lokal; Server-Abgleich nach S-02b) | client | umgesetzt und unabhängig nachgeprüft, Merge offen (Spitze 88c13f2) | C-06b (Basis), S-02b (Abgleich) | tasks/C-02-timer-ui.md |
| 12 | S-02b | Timer-API `GET`/`PUT /v1/timer/einstellung` + JPA | server | offen, blockiert (S-04, S-05) | S-02a, S-02c, S-04, S-05, S-12 | tasks/S-02b-timer-api-jpa.md |
| 13 | S-05 | Autorisierung RBAC/ABAC, Policy-Service, Prod-Konfig, 401-JSON (E25) | server | offen (nicht Teil des Prototyps) | S-04 | tasks/S-05-rbac-abac.md |
| 14 | S-03 | Workout- und Calisthenics-Tracking inkl. `WorkoutImport` (E5, E22, E26) | server | offen (nicht Teil des Prototyps) | S-01, S-04, S-05, S-12 | tasks/S-03-workout-tracking.md |
| 15 | S-06 | Workout-Sichtbarkeit, Profil mit Rate-Limit (E26) | server | offen, blockiert (S-03, S-05) | S-03, S-05 | tasks/S-06-sichtbarkeit.md |
| 16 | S-07 | Sicherheits- und Funktionstests (E14, E16, E23, E25, E26, E28) | server | offen | S-01 (laufend), S-03–S-06 | tasks/S-07-tests-server.md |
| 17 | S-14 | Betriebsdokumentation und Prüfbarkeit (E30; durch Nutzerentscheide E und F weitgehend ersetzt; Images und Manifeste beim Nutzer) | server + client | offen; Doku und Smoke-Check vorab startbar | S-04 (Konfiguration), S-15 (Variablen), S-07 | tasks/S-14-betriebsvorgaben.md |
| 18 | S-08 | DSGVO/EU-Konformität (Server), inkl. E22, E28, E29 | server | offen (Fragen 1–2 offen), blockiert (S-03, S-04, S-06) | S-03, S-04, S-06, S-12 | tasks/S-08-dsgvo-server.md |
| 19 | C-03 | Passkey-UI, Verwaltung (E29), E2E mit virtuellem Authenticator | client | reduzierter Umfang umgesetzt und geprüft, Merge offen; Rest offen (Spitze 7e1f6aa; Commits ff60ec5 bis 7e1f6aa) | C-06b, S-04 | tasks/C-03-passkey-ui.md |
| 20 | C-04 | Workout- und Calisthenics-Tracking (UI) | client | offen, blockiert (S-03) | C-06b, S-03 | tasks/C-04-workout-ui.md |
| 21 | C-05 | Sichtbarkeit und Einladen (UI, exakte Namenssuche E28) | client | offen, blockiert (C-04, S-06) | C-04, S-06 | tasks/C-05-sichtbarkeit-ui.md |
| 22 | C-09 | Funktionstests + mm:ss/h:mm:ss-Formatierer (E21) | client | umgesetzt und geprüft, soweit ohne C-03 bis C-05 möglich; Merge offen (Spitze 619c5f6) | C-06b, C-02 | tasks/C-09-tests-client.md |
| 23 | C-07 | Lauffähigkeit Safari/Firefox/Chrome mobil; Handtest Passkeys | client | offen (Handtest) | C-06b | tasks/C-07-browser-mobil.md |
| 24 | C-08 | DSGVO/EU-Konformität (Client) | client | offen (Fragen 1–2 offen), blockiert (S-08) | C-06b, S-08 | tasks/C-08-dsgvo-client.md |
| 25 | C-16 | Workbox-Upgrade mit Test des Service-Worker-Caches (E27) | client | Teil 1 umgesetzt und geprüft, Teil 2 (Upgrade) offen, Merge offen (Spitze d132c60) | C-14, C-06b | tasks/C-16-workbox-upgrade.md |
| 26 | C-01b | Spike: Timer iOS-Safari gesperrt (Passkey-Teil zurückgestellt) | client | blockiert (iOS-Gerät, Nutzer) | C-06b | tasks/C-01b-spike-ios-geraet.md |
| 27 | C-15 | Native Passkeys und Token-Sitzung | client + server | zurückgestellt (Nutzerentscheid) | S-04 | tasks/C-15-native-passkeys-token.md |
| 28 | C-11 | Native Hülle per Capacitor (Wunsch) | client | zurückgestellt (Nutzerentscheid) | C-01a, C-15 | tasks/C-11-native-app.md |
| 29 | C-13 | Apple Health (HealthKit-Plugin) (Wunsch) | client | zurückgestellt (Nutzerentscheid) | C-11, C-15, S-10 | tasks/C-13-apple-health-client.md |
| 30 | S-09 | Schwimm-Workouts (Server, Wunsch) | server | nicht umsetzen (Nutzerentscheid I) | S-03 | tasks/S-09-schwimm-server.md |
| 31 | S-10 | Apple Health Server-Teil (Wunsch) | server | zurückgestellt (Nutzerentscheid) | S-03 | tasks/S-10-apple-health-server.md |
| 32 | S-11 | Mitnutzer mit Lese-/Schreibrechten (Wunsch, E26) | server | nicht umsetzen (Nutzerentscheid I) | S-06 | tasks/S-11-mitnutzer.md |
| 33 | C-10 | Desktop-Bedienung, Tastenkürzel, Shneiderman (Wunsch) | client | nicht umsetzen (Nutzerentscheid I) | C-02, C-03, C-04, C-05 | tasks/C-10-desktop-usability.md |
| 34 | C-12 | Schwimm-Workouts (UI, Wunsch) | client | nicht umsetzen (Nutzerentscheid I) | C-04, S-09 | tasks/C-12-schwimm-ui.md |
| 35 | S-15 | Registrierungsmodus, Code, `max-benutzer` (E31) | server | entfällt durch Nutzerentscheid G | S-04 | tasks/S-15-registrierungsmodus.md |
| 36 | S-16 | Täglicher Aufräumjob (E32) | server | offen | S-04 | tasks/S-16-aufraeumjob.md |
| 37 | C-17 | Phasensignale: Ton, Vibration, sichtbares Signal (E33) | client | umgesetzt und geprüft, Merge offen (Spitze 0b35f4b); Ende-Signal offen | C-02 | tasks/C-17-phasensignale.md |
| 38 | C-18 | PoC-Hinweis an vier Orten, Registrierungscode (E31) | client | offen, nicht Teil des Prototyps; nur PoC-Hinweis (Nutzerentscheid G, kein Codefeld) | C-03, S-15 | tasks/C-18-poc-hinweis-registrierungscode.md |
| 39 | S-17 | Health über Management-Port (E12); Hinweis `/q/openapi` (Extension nicht abgeschaltet, nur Filter) | server | offen (nicht Teil des Prototyps); noch keine Task-Datei | S-04 | – |

Ersetzt (nur Verweis): `tasks/S-02-timer-intervall.md`, `tasks/C-01-frontend-technik-entscheiden.md`.

## Git-Stand
- server `main`: unverändert auf e65d322, sauber.
- client `main`: unverändert auf 8d39469.
- **`integration/server`** (Worktree `.worktrees/integration-server`): Spitze a8cc57d; S-01 + S-02a + S-13 + S-12; `mvn clean package` 46 Tests grün. Basis für Folgetasks, bis der Nutzer über den Merge nach main entscheidet.
- `task/S-04-passkeys` (Worktree `.worktrees/S-04`), Basis a8cc57d. Phase A: Spitze 003b2cc (Commits db40a4d, fe27f74, 860ee9f Spike-Übernahme; 3b89356 UUID; 2b89812, 8b79571, 40997ec Persistenz; 003b2cc Doku). Migrationen V2 (benutzer, passkey) und V3 (ausstehende_registrierung, TTL 10 Minuten). Phase B in Arbeit.
- `task/S-02c-timer-standard` (Worktree `.worktrees/S-02c`), Basis 003b2cc, Commits e98e11b, 95de62c, 567b701. Merge offen.
- `task/S-12-persistenz-grundlage` (Spitze 87aecad), in `integration/server` gemergt.
- `task/S-01-quarkus-grundgeruest`, `task/S-02-timer-intervall`, `task/S-13-readme-goals`: in `integration/server` enthalten.
- `spike/S-04-passkeys` (01a76ae, e23817c, 15c672f), Worktree `.worktrees/S-04-spike`. Abgeschlossen, Übernahme in `task/S-04-passkeys`.
- **Client-Kette (linear):** C-01a -> C-06 -> C-14 -> C-06b -> C-02 -> C-16 -> C-09. Spitze 619c5f6 enthält alles und ist Basis für weitere Client-Tasks.
  - `task/C-01a-client-grundgeruest` (4bb90b4 und Vorgänger), Merge offen.
  - `task/C-06-material-design` (e3edbf5), Merge offen.
  - `task/C-14-dependency-audit` (e132a66), Merge offen.
  - `task/C-06b-galerie-build-trennung` (Spitze 8a828e3; Commits 3e82064, bee01e6, b06d217, add63d9, 515e735, 8a828e3), Merge offen.
- `task/C-02-timer-ui` (Worktree `.worktrees/C-02`), Basis 8a828e3, Spitze 88c13f2 (Commits 15a132d, cc63e40, a9d88b0, 4256770, 2730bd7, 94cacd8, 1faa940, 4970d61, 5265902, 88c13f2). Merge offen. Abweichung in `docs/abweichungen-c02.md` (Branch).
- `task/C-16-workbox-upgrade` (Worktree `.worktrees/C-16`), Basis 88c13f2, Commits ea7b353, d132c60. Teil 1 umgesetzt, Teil 2 wartet auf Registry-Version. Merge offen.
- `task/C-09-tests-client` (Worktree `.worktrees/C-09`), Basis d132c60, Commits c8fdb79, 619c5f6. Umgesetzt, Merge offen.
- `task/S-04-passkeys`: Phase B Zwischenstand (Commits 50f8fec, d7e9fbe, d73e2d0, 4429988, 777c17c, 2dbece9, c935191, 3bf6f7c); `mvn clean package` 248 Tests grün.
- `task/C-17-phasensignale` (Worktree `.worktrees/C-17`), Basis 619c5f6, Spitze 0b35f4b. Merge offen.
- `task/C-03-passkey-ui` (Worktree `.worktrees/C-03`), Basis 0b35f4b. In Arbeit (reduziert).
- `integration/server`: Spitze f8d2ad4 (Merges 7631dc5 S-04, f8d2ad4 S-02c). In Arbeit: Dev-Origin-Commit und `docs/prototyp-lokal.md`.
- Client-Kette: C-01a -> C-06 -> C-14 -> C-06b -> C-02 -> C-16 -> C-09 -> C-17, Spitze 0b35f4b.
- Offen: Git-Autor. Agent-Commits tragen `Agent <Task> <agent-…@localhost>`. Frage 5.

## Nächste Schritte (spätere Sitzung)
1. Entscheidung des Nutzers zu Git-Autor und Merge nach `main`.
2. S-05 Rechtemodell.
3. S-03 und C-04 Workout-Tracking.
4. S-02b und Server-Abgleich des Timers.
5. S-08, C-08, C-18 und die Freigabeliste vor öffentlicher Erreichbarkeit.
6. S-14 Betriebsdoku, S-17 Health.
Offene Nutzerfragen bleiben unverändert stehen.

## Arbeitsregeln (Parallelität)
- Nie zwei Client-Worker gleichzeitig Playwright ausführen lassen (feste Ports 4173/4174, `reuseExistingServer`).
- Nie zwei Maven-Läufe im Server-Repo gleichzeitig (Testport 8081).

## Reihenfolge der Umsetzung (Server)
1. S-04 Phase B (E23, E26, E28, E29; Lücken aus Phase A).
2. Merge S-04 und S-02c nach `integration/server`.
3. S-05, dann S-03 (E22, E26), S-02b (nach S-02c und S-04, Hinweise siehe Task), S-06, S-11.
4. S-07, S-14, S-08 (nach Fragen 1–2).

## Reihenfolge der Umsetzung (Client)
1. Merge der Kette C-01a, C-14, C-06b, C-06.
2. C-02 abschließen (Server-Abgleich nach S-02b).
3. C-03 (nach S-04), C-04 (nach S-03), C-05 (nach C-04 und S-06).
4. C-09, C-07 (Handtest), C-16 (Workbox-Upgrade), C-08 (nach S-08).

## Aufräumen durch den Nutzer (Worker durften nicht löschen)
1. `src/test/java/de/trainingsapp/spike/ProbeTest.java` im Spike-Worktree (`.worktrees/S-04-spike`).
2. `/home/user/trainingsapp/.worktrees/C-06b/dist-alt/`
3. `/home/user/trainingsapp/.worktrees/C-06b/vite.config.alt.ts`
4. `/home/user/trainingsapp/.worktrees/C-02-review` (detached, ohne Commits; kann entfernt werden).
5. `/tmp/opencode/c02-build.log` (Log-Datei).
6. `/home/user/trainingsapp/.worktrees/C-16/e2e/zz-debug.spec.ts` (uncommittete Wegwerf-Datei; solange sie dort liegt, nimmt ein normaler `playwright test` in diesem Worktree sie mit).
7. `/home/user/trainingsapp/.worktrees/C-09/test-results-gesamt.log` (Log-Datei).
8. `/home/user/trainingsapp/.worktrees/C-03/server-dev.log` (Log-Datei).
9. `/tmp/c03-pw.json`.
10. `/tmp/opencode-vite.log`.
11. Vermutlich `~/.java` (von jshell).
12. Chromium-Revision in `~/.cache/ms-playwright` (vom Server-E2E geladen; kann bleiben).

## Freigabe vor öffentlicher Erreichbarkeit (E31, Stand 18.11.2026: alle offen)
Technisch (Voraussetzung vor jeder öffentlichen Erreichbarkeit):
1. S-04, S-05, S-15, S-16 abgeschlossen; S-07 grün (401- und 404-Tabellen, ArchUnit). — **offen**
2. E2E mit virtuellem Authenticator (C-03) grün. — **offen**
3. Smoke-Check gegen die Live-Domain: nur HTTPS, HSTS, CSP, Cookie-Attribute (E14), `/q/*` 404, `/v1` ohne Anmeldung 401. — **offen**. Aufbau und Durchführung auf dem Server sind Sache des Nutzers; das Skript bzw. die Hinweise liefert S-14.
4. Rate-Limits wirksam (Nutzerentscheid G: kein Registrierungscode). — **offen**
5. Export und Kontolöschung getestet. — **offen**
6. Backup und Restore einmal auf dem Server durchgespielt und protokolliert. — **offen**. Aufbau und Durchführung auf dem Server sind Sache des Nutzers; die Hinweise liefert S-14.
7. Dependency-Audit von Server und Client ohne hohe oder kritische Befunde. — **offen**. Hinweis: Der Client meldet 12 hohe Befunde in `npm audit`, alle nur in Entwicklungswerkzeugen (`--omit=dev` ist 0, siehe C-14 und E27). Ob das Kriterium ausgeliefertem Code oder auch Entwicklungswerkzeugen gilt, ist offen (siehe "Nächste Council-Runde").
8. OWASP-ZAP-Baseline-Scan gegen die Live-Domain ohne hohe Befunde. — **offen**
9. Secret-Scan (gitleaks) beider Repos ohne Fund. — **offen**
10. PoC-Hinweis sichtbar (C-18). — **offen**

Rechtlich (nur durch den Nutzer zu klären, ebenfalls Voraussetzung; der PoC-Hinweis ersetzt diese Pflichten nicht):
- Impressum; Verantwortlicher (Frage 17). — **offen**
- Text der Datenschutzerklärung. — **offen**
- Rechtsgrundlage nach Art. 9 (Frage 19). — **offen**
- Auftragsverarbeitungsvertrag mit Strato (Deutschland): Sache des Nutzers (Nutzerentscheid E). — **offen**
- Haftung. — **offen**

## Offene Nutzerfragen
15. Hast du eine Rückfrage des C-02-Workers (Timer ersetzt die Startseite) selbst beantwortet? Der Worker gibt an, über das Frage-Werkzeug eine Antwort erhalten zu haben, die nicht vom Orchestrator stammte (Commits 4256770, 1faa940). Je nach Antwort passt der Orchestrator `docs/abweichungen-c02.md` an.
16. (BEANTWORTET, Zuordnung der Antwort darunter wahrscheinlich, siehe ENTSCHEIDUNGEN.md; widerspricht C-02-Annahme) Soll der Timer beim Phasenwechsel einen Ton oder eine Vibration auslösen? Aktuell (Annahme des Workers): keines von beidem.
Beim Phasen Wechsel soll ein Ton und Vibration ausgelösst werden
17. (TEILWEISE BEANTWORTET 18.11.2026, Nutzerentscheid E: Standort Deutschland, Hoster Strato; Verantwortlicher für Impressum und Datenschutzerklärung offen) Wer steht als Verantwortlicher im Impressum und in der Datenschutzerklärung, und in welchem Land steht der Server (zu Hause oder bei einem Hoster, dann mit Auftragsverarbeitungsvertrag)?
18. (neu, E32; ergänzt zu 3) Loeschregel: Nur Konten ohne Passkey nach 14 Tagen loeschen, oder auch lange nicht genutzte Konten, und wenn ja, nach welcher Zeit? (Rückfrage des Orchestrators; bis zur Antwort werden inaktive Konten nicht gelöscht.)
19. (neu, E31; ergänzt zu 2) Wird vor der öffentlichen Freigabe geprüft, ob Trainingsdaten Gesundheitsdaten nach Art. 9 sind, oder bleibt die App bis dahin nur für Personen mit Registrierungscode erreichbar?
20. (neu, Rückfrage Git-Autor; ergänzt zu 5) Modellname für den Platzhalter "KI Agent {Ki-Model}", E-Mail-Adresse, bisherige Commits umschreiben ja/nein, Merge nach main ja/nein.
21. (BEANTWORTET 18.11.2026, Nutzerentscheid F, siehe ENTSCHEIDUNGEN.md; Auslegung "Manifeste" = Kubernetes-Manifeste, "Artefakte" = Images und Bau-Dateien, vom Nutzer korrigierbar) Sollen spätere Kubernetes-Manifeste (Deployment, Service, Ingress für k3s) im Repo liegen, oder reichen dir die Container-Images und die Betriebsdoku?
Antwort des Nutzers (wörtlich): "Manifeste und Artifakte werde sleber später erstellen"
1. (BEANTWORTET, Wortlaut in ENTSCHEIDUNGEN.md, Abschnitt Nutzerantworten 18.11.2026) Verantwortlicher nach DSGVO; Betriebsform (privat, öffentlich, kommerziell).
Mein Plan ist dies öffentlich zu hosten. Aber mit dem Hinweis das hier ein Proof of Konzept und kompleet vibe gecodet ist zu veröffentlichen
2. Rechtliche Prüfung Art. 9 bei Trainingsdaten.

3. (BEANTWORTET, Klärung nötig: Widerspruch zu E7/E3/E26, siehe ENTSCHEIDUNGEN.md) Konto ohne Passkey endgültig verloren: akzeptabel?
Wenn ich einem Konto kein Passkey hinterlget ist, soll es nach 2 Wochen gelöscht werden
4. (TEILWEISE BEANTWORTET: Betrieb auf Ubuntu-Server mit k3s; Standort in der EU und CI offen, siehe ENTSCHEIDUNGEN.md) Betriebsort und CI (Docker/Podman). Docker ist nutzbar (erledigt, siehe 8); CI offen.
ich will das auf meinem ubunut Server in k3s kubernettes laufen lassen. 
5. (ANTWORT UNKLAR: Platzhalter, Rückfrage nötig, siehe ENTSCHEIDUNGEN.md) S-01, S-02a, S-13 und die Kette nach main mergen? Welcher Git-Autor?
KI Agent {Ki-Model}
6. Soll die Liste "Offene Entscheidungen" im Server-README (Zeilen 47–51) durch die Council-Beschlüsse ersetzt werden? Zusätzlich veraltet: "Status: Planung" (Zeile 5). Das README ist dein Anforderungsdokument; S-13 ändert es nicht.
7. ~~Node.js ab 22.12 installieren~~ – erledigt (Node v22.22.1, npm 9.2.0).
8. ~~PostgreSQL bereitstellen~~ – erledigt (Docker 29.10.0 nutzbar nach Neustart, `user` in Gruppe `docker`).
9. ~~Systembibliotheken für Playwright-WebKit~~ – erledigt (WebKit und Mobil starten; je 9 funktionale Tests grün).
10. Node-Anforderung in `client/package.json` (`^22.22.2 || ^24.15.0 || >=26`) ist auf dem Rechner (22.22.1) knapp nicht erfüllt. Node aktualisieren oder Anforderung senken (jsdom 31)?
11. (BEANTWORTET, aber nur "denke schon", nicht bestätigt; E15-Arbeitsannahme bleibt, siehe ENTSCHEIDUNGEN.md) Können PWA und API später unter derselben Domain laufen (eine Origin hinter dem Reverse Proxy)? Wenn nicht, muss das Sitzungsmodell (E15) geändert werden.
Ich denke schon, das diese unter selben Domain laufen werden können
12. ~~Native App mit Apple Health~~ – beantwortet 18.11.2026 (Nutzer): keine native App; Auth-Service erweiterbar. Zurückgestellt.
13. Quellfarbe `#6750a4` (Material-Token-Basis in C-06) als Markenfarbe bestätigen oder ersetzen? Festlegung des Workers, keine Vorgabe des Nutzers.
14. ~~Interner oder öffentlicher Erweiterungspunkt~~ – beantwortet 18.11.2026 (Nutzer): "Ich will eine interne Server-Schnittstelle." E22 bestätigt.

## Council-Beschlüsse (Runde 3 und Folgeabschnitte)
Wortlaut in `tasks/ENTSCHEIDUNGEN.md`. Kurzfassung (E30–E33 am 18.11.2026 neu, siehe unten):
- E13 Passkey über `WebAuthnSecurity`; Befund-Tests dauerhaft.
- E14 `HttpOnly`, `Secure`, `SameSite=Strict`, CSP.
- E15 Sitzung per Cookie, gleiche Origin, Origin-Prüfung; Capacitor über C-15.
- E16 404 statt 302 für `/q/*` im Prod-Profil; drei Schichten; präzisiert durch E25.
- E17 Aufzählbarkeit hingenommen; Rate-Limit; Pseudonym-Hinweis.
- E18 `BenutzerId` als UUID; Reihenfolge der Umsetzung.
- E19 Datenbank-Tests Pflicht; Überspringen nur mit `-Ddatenbank.tests=aus`.
- E20 `GET` ohne Einstellung: 200 mit 30 s / 10 s; Feld `gespeichert`.
- E21 Dauer-Format `mm:ss` unter 1 h, `h:mm:ss` ab 1 h.
- E22 Erweiterungsport `WorkoutImport`, Felder `herkunft` und `externeId`, Teilindex, idempotent, PRIVAT.
- E23 Auth-Abnahme S-04 (Punkte 1–9), `Anmeldesitzung` und `PasskeyZeremonie`, ArchUnit-Regel.
- E24 `galerie.html` nur im Test-Build; umgesetzt in C-06b.
- E25 `/v1/info` und `/v1/*` ohne Anmeldung: 401 JSON; Deny-Policy entfällt.
- E26 Transaktionen: Port `application.Transaktion`, `MANDATORY`, ArchUnit.
- E27 Kein glob-Override; Restrisiko; Workbox-Upgrade als C-16.
- E28 Benutzername: Value Object, Regeln, gesperrte Namen, exakte Suche beim Einladen.
- E29 Passkeys in der Verwaltung: Bezeichnung, Datumsfelder, `PATCH`, Migrationsregel.
- E30 Betrieb auf k3s: Kustomize, cert-manager, PostgreSQL im Cluster [Vorsitz gegen Mehrheit], Backup, Images, Traefik-Routing, nginx (Task S-14).
- E31 Öffentlicher PoC: Registrierungsmodus (`CODE` in Prod), `max-benutzer`, PoC-Hinweis, zehn technische Freigabekriterien (Task S-15, C-18).
- E32 Löschregel: Aufräumjob, abgelaufene Registrierungen, Konten ohne Passkey nach 14 Tagen (Task S-16).
- E33 Phasensignale: Ton, Vibration, sichtbares Signal, zwei Schalter (Task C-17).

## Widersprüche und Lücken
- **Aufgelöst:** E16 gegen E12 durch E25; E19 gegen S-12 mit dem S-12-Merge; E22 gegen E5 (Teil desselben Beschlusses).
- **Bekannte Lücke (E25):** Zwischen Merge S-01 und S-04 ist `/v1/info` im Prod-Profil ungeschützt. Regel: **kein Stand vor Abschluss von S-04 wird ausgeliefert.** Kein neuer Task.
- **Hinweis (E29):** V2 und V3 liegen bereits im Branch `task/S-04-passkeys`; die Änderungsregel gilt erst ab dem Merge nach `integration/server`. Unkritisch, solange nicht gemergt. Offen: Prüfung, dass keine dauerhafte Dev-Datenbank V2 angewendet hat.
- Keine neuen Widersprüche aus E26–E29.
- **Nutzerantworten 18.11.2026 (Klärung nötig, Details in ENTSCHEIDUNGEN.md):**
  - Frage 3 (Konto ohne Passkey nach 2 Wochen löschen) widerspricht E7 (Löschung auf Antrag) und ist mit E3/E26 nur schwer vereinbar. Betroffen: S-04, S-08, C-03.
  - Frage 16 (Ton und Vibration) widerspricht der Annahme in C-02 (kein Ton, keine Vibration). Betroffen: C-02, nicht ohne Freigabe des Orchestrators ändern.
  - Frage 4 (Ubuntu-Server, k3s): Standort in der EU nicht genannt (E7). Betroffen: S-14.
  - Frage 11 ("denke schon"): keine Bestätigung von E15. Betroffen: S-04, S-14, C-03.
  - Frage 5 ("KI Agent {Ki-Model}"): Platzhalter, Rückfrage nötig.
- **E32 Löschregel (Klärung):** Nach E26 und E3 entsteht ein Konto nicht ohne Passkey; die 14-Tage-Regel greift nur in Ausnahmefällen. Mit E7 als Speicherbegrenzung vereinbar (Vorsitz). Betroffen: S-16, S-08, Frage 18.
- **E33 Ende-Signal:** C-02 wiederholt Runden bis zum Anhalten und kennt kein Ende. Der Worker meldet das (C-17).
- **Offen (Nutzerfrage 15):** Commit-Nachrichten 4256770 und 1faa940 (C-02) nennen eine Abstimmung mit dem Orchestrator, die es so nicht gab. Klärung durch den Nutzer; danach `docs/abweichungen-c02.md` anpassen.

## Nächste Council-Runde
- E31 Kriterium 7 (Audit): gilt es nur für ausgelieferten Code oder auch für Entwicklungswerkzeuge? Der Client meldet 12 hohe Befunde, alle nur in Entwicklungswerkzeugen.
- E33 Ende-Signal: Die Timer-UI aus C-02 kennt kein Ende. Der Worker meldet das, statt eine Rundenzahl einzuführen. Entscheidung offen.
- E32 Löschregel: Praxisrelevanz nach E26/E3 gering; Löschung inaktiver Konten erst nach Antwort des Nutzers (Frage 18).
- E30 zur Kenntnis: PostgreSQL im Cluster (Vorsitz gegen Mehrheit B1, B3, B4 für Host). Durch Nutzerentscheid E teilweise ersetzt.
- CI-Plattform (C-09: keine CI vorhanden): Architekturentscheidung, zusammen mit der Frage, wo die Repos später liegen. Ergänzung (Nutzerentscheid F): Der Nutzer baut Artefakte (Images, Manifeste) selbst; eine CI wäre dann nur für Tests relevant.
