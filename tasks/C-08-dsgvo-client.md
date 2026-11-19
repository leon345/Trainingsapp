# C-08 – DSGVO- und EU-Konformität (Client)

- **Repo:** client
- **Ziel:** Frontend erfüllt DSGVO und relevante EU-Vorgaben (z. B. Einwilligung, Datenschutzerklärung, Cookies/Speicherung im Browser).
- **Betroffene Dateien/Bereiche:** Datenschutz-Screens, Consent-Handling, lokale Speicherung (localStorage/IndexedDB), Analytics/Tracking (falls vorhanden).
- **Abnahmekriterien:**
  - Umfang der relevanten Vorgaben ist festgelegt (abgestimmt mit S-08).
  - Datenschutzerklärung und ggf. Einwilligung sind umgesetzt.
  - Keine unnötigen personenbezogenen Daten im Browser gespeichert (dokumentiert).
- **Scope (E7):** Datenschutzerklärung im Client; Einwilligung bei Registrierung (Art.-9-Arbeitsannahme); kein Tracking, keine Drittdienste, kein Cookie-Banner; WCAG 2.1 AA.
- **E31/E32 (18.11.2026):** PoC-Hinweis an den vier Orten (C-18) in Datenschutzerklärung und Footer; Löschregel aus E32 in der Datenschutzerklärung; Freigabeliste siehe TODO.md.
- **Abhängigkeiten:** C-06b, S-08.
- **Quelle:** client/README.md, „Muss-Kriterien“ (DSGVO).
- **Hinweis:** Umfang ist nicht spezifiziert; vor Umsetzung klären.
