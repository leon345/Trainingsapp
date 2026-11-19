# Task GS-02: Passkeys (`quarkus-security-webauthn`), Auth-Port, RBAC/ABAC & `@RateLimit`

- **ID:** `GS-02`
- **Repo:** `server`
- **Status:** `in Arbeit`
- **Abhängigkeiten:** `GS-01`
- **Branch:** `gemini-task/GS-02-passkeys-rbac-abac`
- **Worktree:** `.worktrees/gemini-GS-02`

## Ziel

Implementierung der passwortlosen Passkey-Authentifizierung über `quarkus-security-webauthn` (`WebAuthnSecurity`, `WebAuthnUserProvider`) hinter einem dünnen Auth-Port (Nutzerentscheid A), offene Registrierung ohne Code (Nutzerentscheid G), Multi-Passkey-Verwaltung (`bezeichnung`, `erstelltAm`, `zuletztVerwendetAm`), RBAC/ABAC mit Quarkus-Annotationen (`@Authenticated`, `@RolesAllowed`, `@PermissionsAllowed` + `@PermissionChecker` (`@Blocking`) auf Basis einer testbaren DDD-`ZugriffsPolicy`) sowie Rate-Limiting über `quarkus-smallrye-fault-tolerance` (`@RateLimit`).

## Abnahmekriterien

1. **Domänenmodell & Flyway-Migration:**
   - `BenutzerId` als UUID (`16-Byte` WebAuthn User-Handle), Value Object `Benutzername` (ASCII-Kleinschreibung, Regex `^[a-z0-9](?:[a-z0-9]|[._-](?=[a-z0-9])){2,31}$`, konfigurierbare Sperrliste u. a. `admin`, `root`, `system`, `support`, `trainingsapp`).
   - Flyway-Migration (`V2__benutzer_passkeys.sql`) für `benutzer`, `passkey` (`bezeichnung` VARCHAR(50), `erstellt_am` DATE UTC, `zuletzt_verwendet_am` DATE UTC, `credential_id`, Public Key, Counter, ohne IP/User-Agent/Attestierung) und `ausstehende_registrierung` (TTL 10 Min.).
2. **Passkey-Endpunkte (`/v1/*`) & dünner Auth-Port:**
   - Offene Registrierung ohne Code (`/v1/registrieren/optionen`, `/v1/registrieren` inkl. Einwilligungs-Pflichtfeld), Anmeldung (`/v1/anmelden/optionen`, `/v1/anmelden`), Abmeldung (`/v1/abmelden`), aktueller Benutzer (`/v1/ich`).
   - Multi-Passkey-Verwaltung: `GET /v1/passkeys`, `POST /v1/passkeys/optionen`, `POST /v1/passkeys` (automatische Bezeichnung `Passkey n`), `PATCH /v1/passkeys/{id}` (Umbenennen), `DELETE /v1/passkeys/{id}` (letzter Passkey darf nicht gelöscht werden; fremder Passkey liefert `404`).
   - `WebAuthnSecurity` und `WebAuthnUserProvider` sind in `infrastructure` gekapselt; dünner Auth-Port (`Anmeldesitzung`) in `application` erlaubt späteren Austausch (z. B. Token-Sitzung). Standard-Routen `/q/webauthn/*` werden durch einen vom Nutzer ausdrücklich freigegebenen minimalen Vert.x-`@RouteFilter` (~10 Zeilen in `infrastructure.passkey`) sauber mit `404` (ohne Body und ohne `Set-Cookie`) gesperrt.
3. **RBAC, ABAC & 401-Verhalten:**
   - Rollen `USER` und `ADMIN` (`ADMIN` nur für Betrieb, hat keinen Zugriff auf fremde Trainingsdaten).
   - Alle `/v1/*`-Endpunkte außer `anmelden*` und `registrieren*` erfordern `@Authenticated` und liefern ohne Anmeldung `401` als `FehlerV1`-JSON (kein `302`-Redirect).
   - `@PermissionsAllowed` + `@PermissionChecker` (`@Blocking`) delegieren an eine testbare DDD-`ZugriffsPolicy` in `domain`.
4. **Rate-Limiting & Cookie-/Header-Konfiguration:**
   - `@RateLimit` (`quarkus-smallrye-fault-tolerance`) auf Auth-Endpunkten (`registrieren/optionen`, `registrieren`, `anmelden/optionen`) mit `RateLimitException`-Mapping auf `429` `FehlerV1`.
   - `Secure` (Prod / `quarkus.http.proxy.proxy-address-forwarding=true`) und `SameSite=Strict` auf Auth-/Challenge-Cookies; Origin-/rpId-Allowlist über Konfiguration einstellbar; strikte CSP (`default-src 'self'`) über `quarkus.http.header.*`.
   - **Nutzerentscheid zu `HttpOnly` bei `quarkus-security-webauthn:3.40.1.2`:** Bewusst **keine** Eigenentwicklung (kein eigener Cookie-Patch-Filter); fehlendes `HttpOnly` wird als bekannte Quarkus-3.40.1.2-Limitierung in `server/docs/auth-erweiterung.md` dokumentiert (kompensiert durch `SameSite=Strict`, `Secure` in Prod via `proxy-address-forwarding=true` und strikte CSP `default-src 'self'`).
   - **Nutzerentscheid zu EdDSA (`quarkus-security-webauthn:3.40.1.2` / `webauthn4j-core:0.30.3.RELEASE`):** Bewusst **kein** Workaround für den Upstream-Bug (`EdDSACOSEKey.create` prüft Referenzgleichheit gegen `COSEAlgorithmIdentifier.EdDSA`). Per reiner Config werden `ES256` und `RS256` aktiviert; EdDSA entfällt bis zum Upstream-Fix und wird in `server/docs/auth-erweiterung.md` dokumentiert.
5. **Tests & Doku:**
   - Unit-Tests für `Benutzername`, `ZugriffsPolicy`, Passkey-Logik (ES256, RS256, Signaturzähler 0; EdDSA entfällt per Config bis zum Upstream-Fix) und `@Transactional` in `application`.
   - DB-Integrationstests gegen PostgreSQL (zwei Passkeys registrieren, mit beiden anmelden, umbenennen, einen löschen, letzten nicht löschen, Rate-Limit 429, 401-JSON, `/q/webauthn/*` -> `404` ohne Body/`Set-Cookie`).
   - Austausch-Test mit Fake-Implementierung des Auth-Ports in den Testquellen + `server/docs/auth-erweiterung.md` (inkl. Dokumentation der `HttpOnly`-Limitierung und der EdDSA-Upstream-Limitierung von Quarkus `3.40.1.2` / `webauthn4j-core:0.30.3.RELEASE`).
