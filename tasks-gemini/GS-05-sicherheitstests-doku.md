# Task GS-05: Sicherheits-/Härtungstests, ArchUnit-Abnahme, DSGVO-/Betriebsdoku & Smoke-Check

- **ID:** `GS-05`
- **Repo:** `server`
- **Status:** `offen`
- **Abhängigkeiten:** `GS-04`
- **Branch:** `gemini-task/GS-05-sicherheitstests-doku`
- **Worktree:** `.worktrees/gemini-GS-05`

## Ziel

Abschließende Verifikation aller Sicherheits-, ArchUnit-, DSGVO- und Betriebsanforderungen auf dem Server inklusive vollständiger 401-/404-/IDOR-Testmatrizen im `%prod`-Profil, DSGVO-/TOM-Dokumentation und Betriebsanleitung (Nutzerentscheide E, F, G).

## Abnahmekriterien

1. **Vollständige Security- & `%prod`-Härtungs-Tests:**
   - `%prod`-Profil-Testmatrix:
     - Alle `/q/openapi`, `/q/swagger-ui`, `/q/health` (auf Hauptport) über Quarkus-Bordmittel sowie `/q/webauthn/*` (via freigegebenem minimalen Vert.x-`@RouteFilter` in `infrastructure.passkey`) sind im `%prod`-Profil gesperrt (`404` bzw. ohne Leak/Body/`Set-Cookie`); Health läuft auf dem Management-Port.
     - Alle `/v1/*`-Routen (inkl. unbekannter Pfade) außer `anmelden*` und `registrieren*` liefern ohne gültige Sitzung `401` als `FehlerV1`-JSON (niemals `302`).
   - HTTP-Security-Header (`X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `CSP` via `quarkus.http.header.*`), Cookie-Attribute (`SameSite=Strict`, `Secure` mit `X-Forwarded-Proto: https`; fehlendes `HttpOnly` bei `quarkus-security-webauthn:3.40.1.2` gemäß Nutzerentscheid dokumentiert), Origin-Allowlist und `@RateLimit` (429) vollständig getestet.
   - IDOR-Komplettprüfung über alle Endpunkte (Passkeys, Timer, Workouts, Übungen, Sätze, Einladungen, Profile, DSGVO).
2. **ArchUnit- & Code-Qualitätsabnahme:**
   - Alle ArchUnit-Regeln (`domain` 100 % framework-frei; `application` ohne JPA/Vert.x/WebAuthn/`SecurityIdentity`; `api.v1` ohne JPA/Vert.x/WebAuthn/`SecurityIdentity`) laufen grün.
   - Keine ungenehmigten Eigenentwicklungen außerhalb der Business-Logik; alle offenen Warnungen/Dependency-Checks geprüft.
3. **DSGVO- & Betriebsdokumentation:**
   - `server/docs/dsgvo-tom.md`: Verarbeitungsverzeichnis, technische und organisatorische Maßnahmen (TOM), 14 Tage Log-Retention, 30 Tage Backup-Retention, Löschregeln.
   - `server/docs/betrieb.md`: Anforderungen für Strato-/EU-Betrieb (PostgreSQL extern, TLS über Reverse Proxy, gleiche Origin für PWA & `/v1/*`, erforderliche Env-Variablen, Health-Checks auf Management-Port).
   - `server/docs/prototyp-lokal.md`: Anleitung zum lokalen Start (Server + PostgreSQL Dev Services + Client).
   - `server/scripts/smoke-check.sh`: Ausführbares Smoke-Check-Skript für Live- oder Staging-Prüfung (HTTPS, Security-Header, 401 auf `/v1/*`, gesperrtes `/q/*`).
4. **Gesamtbuild:**
   - `./mvnw clean verify` (inkl. PostgreSQL-Tests) läuft 100 % grün mit 0 übersprungenen Tests; OpenAPI-Schema-Artefakt ist aktuell.
