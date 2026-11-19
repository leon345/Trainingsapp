# S-14 – Betriebsdokumentation und Prüfbarkeit (E30, durch Nutzerentscheide E und F weitgehend ersetzt)

- **Status:** offen. Images, Manifeste und Dockerfiles liegen beim Nutzer (Nutzerentscheid F). Im Repo bleibt die Betriebsdokumentation und das, was lokal prüfbar ist.
- **Repo:** server und client (aufgeteilt, siehe unten).
- **Ziel:** Der Nutzer soll Images und Manifeste später selbst richtig bauen können. Dafür liefert das Repo die Anforderungen an Laufzeit, Konfiguration, Proxy und Auslieferung sowie ein Smoke-Check-Skript.
- **Auslegung des Orchestrators (vom Nutzer korrigierbar):** Der Nutzer stellt PostgreSQL und TLS selbst bereit, erstellt Dockerfiles, Images und Kubernetes-Manifeste selbst und richtet das Hosting bei Strato (Deutschland) selbst ein.

## Umfang im Repo

### Server-Repo (`server/`)
- `docs/betrieb.md`:
  - Laufzeit: Java 21, Start des Fast-JAR.
  - Ports: API-Port; Management-Port für Health (`/q/health/live`, `/q/health/ready`).
  - Flyway `migrate-at-start` und die Folge für Updates: eine Instanz, kurze Downtime.
  - Alle Umgebungsvariablen mit Bedeutung, ohne Werte: Datenbank (`QUARKUS_DATASOURCE_*`), `encryption-key` der Sitzung, Origins und rpId, Proxy-Weiterleitung (`X-Forwarded-Proto`, `proxy-address-forwarding`), später Registrierungsmodus und Code aus S-15.
  - Anforderungen an die vom Nutzer gestellte PostgreSQL: Version, Rechte, Zeichensatz (UTF-8).
  - Anforderungen an den Reverse Proxy: eine Origin; `/v1` zum Server; alles andere zur PWA; 404 für `/q/*` und `/.well-known/*`; HSTS; TLS-Terminierung mit `X-Forwarded-Proto`.
  - Empfehlungen für das Image: non-root, nur lesendes Dateisystem, Ressourcenlimits.
  - Hinweise zu Backup und Restore (Sache des Nutzers; die Doku nennt, was gesichert werden muss).
- `scripts/smoke-check.sh` (oder gleichwertig): prüft die Live-Domain auf HTTPS, HSTS, CSP, Cookie-Attribute aus E14, `/q/*` ergibt 404, `/v1` ohne Anmeldung ergibt 401.

### Client-Repo (`client/`)
- `docs/betrieb.md` (oder Abschnitt in der README):
  - Bau: `npm ci`, `npm run build`; Ergebnis liegt in `dist/`.
  - Was der ausliefernde Webserver leisten muss:
    - SPA-Fallback nur für Pfade ohne Dateiendung.
    - Cache-Header: `sw.js` und `index.html` nicht cachen; Dateien mit Hash im Namen lang cachen.
    - CSP aus E14 für die HTML-Dokumente.
    - Keine Auslieferung von Galerie oder Test-Build (`galerie*`, `--mode test`).

## Prüfbar in der Entwicklungsumgebung
- Start des Fast-JAR im Prod-Profil nur mit Umgebungsvariablen gegen einen PostgreSQL-Container.
- Smoke-Check-Skript gegen eine lokale Instanz, soweit ohne TLS sinnvoll (401 für `/v1`, 404 für `/q/*`, Cookie- und CSP-Header).
- Client: `npm ci`, `npm run build`, Auslieferungsregeln gegen `dist/` prüfbar (z. B. Galerie fehlt im Build).

## Nur beim Nutzer prüfbar
- Alles mit echter Domain, TLS, Reverse Proxy und HSTS.
- Die CSP für die HTML-Dokumente wird vom Webserver des Nutzers gesetzt, nicht von einer `nginx.conf` im Repo. Sie ist eine dokumentierte Betriebsanforderung und wird erst durch den Smoke-Check gegen die Live-Domain nachgewiesen.
- Backup und Restore der Datenbank.

## Abnahmekriterien
- `docs/betrieb.md` (Server) vollständig: Laufzeit, Ports, Umgebungsvariablen ohne Werte, PostgreSQL-Anforderungen, Proxy-Anforderungen, Image-Empfehlungen, Backup-Hinweise.
- Client-Betriebsdoku vollständig: Bau, Auslieferungsanforderungen, Cache-Header, CSP.
- Fast-JAR startet im Prod-Profil nur mit Umgebungsvariablen gegen PostgreSQL-Container (lokal geprüft).
- Smoke-Check-Skript vorhanden und gegen lokale Instanz getestet, soweit ohne TLS sinnvoll.
- Keine Werte, Geheimnisse oder Domains im Repo.

## Abhängigkeiten
- S-04 abgeschlossen (Prod-Konfiguration der Sitzung, `encryption-key`, Origins, rpId).
- S-15 für die Variablen des Registrierungsmodus und Codes.
- S-07 (Smoke-Check als Freigabeschritt).
- Freigabe vor öffentlicher Erreichbarkeit: siehe TODO.md.

## Vom Worker S-04 notiert (für die Betriebsdoku)
- Proxy muss `X-Forwarded-For` überschreiben statt anhängen.
- Anwendung nur über den Proxy erreichbar.
- Konfiguration `TRAININGSAPP_TRUSTED_PROXIES`.
- Genau eine Instanz (Rate-Limit liegt im Speicher).

## Quellen
- ENTSCHEIDUNGEN.md Nutzerentscheid F, Nutzerentscheid E, E30 (durch E und F weitgehend ersetzt), E14, E15, E16, E31 (Freigabe), E7 (EU-Hosting, erfüllt durch Strato).
