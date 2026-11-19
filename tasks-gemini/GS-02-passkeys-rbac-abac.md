# Task GS-02: Passkeys (`quarkus-security-webauthn`), Auth-Port, RBAC/ABAC & `@RateLimit`

- **ID:** `GS-02`
- **Repo:** `server`
- **Status:** `offen`
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
   - `WebAuthnSecurity` und `WebAuthnUserProvider` sind in `infrastructure` gekapselt; dünner Auth-Port (`Anmeldesitzung`) in `application` erlaubt späteren Austausch (z. B. Token-Sitzung). Standard-Routen `/q/webauthn/*` bleiben deaktiviert/ungeschaltet.
3. **RBAC, ABAC & 401-Verhalten:**
   - Rollen `USER` und `ADMIN` (`ADMIN` nur für Betrieb, hat keinen Zugriff auf fremde Trainingsdaten).
   - Alle `/v1/*`-Endpunkte außer `anmelden*` und `registrieren*` erfordern `@Authenticated` und liefern ohne Anmeldung `401` als `FehlerV1`-JSON (kein `302`-Redirect).
   - `@PermissionsAllowed` + `@PermissionChecker` (`@Blocking`) delegieren an eine testbare DDD-`ZugriffsPolicy` in `domain`.
4. **Rate-Limiting & Cookie-/Header-Konfiguration:**
   - `@RateLimit` (`quarkus-smallrye-fault-tolerance`) auf Auth-Endpunkten (`registrieren/optionen`, `registrieren`, `anmelden/optionen`) mit `RateLimitException`-Mapping auf `429` `FehlerV1`.
   - `HttpOnly`, `Secure` (Prod / `quarkus.http.proxy.proxy-address-forwarding=true`), `SameSite=Strict` auf Auth-/Challenge-Cookies; Origin-/rpId-Allowlist über Konfiguration einstellbar.
5. **Tests & Doku:**
   - Unit-Tests für `Benutzername`, `ZugriffsPolicy`, Passkey-Logik (RS256, EdDSA, Signaturzähler 0) und `@Transactional` in `application`.
   - DB-Integrationstests gegen PostgreSQL (zwei Passkeys registrieren, mit beiden anmelden, umbenennen, einen löschen, letzten nicht löschen, Rate-Limit 429, 401-JSON).
   - Austausch-Test mit Fake-Implementierung des Auth-Ports in den Testquellen + `server/docs/auth-erweiterung.md`.
