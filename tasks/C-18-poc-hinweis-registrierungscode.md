# C-18 – PoC-Hinweis und Registrierungscode (E31)

- **Status:** offen
- **Repo:** client
- **Ziel:** Der öffentliche Proof-of-Concept-Betrieb ist für Besucher klar gekennzeichnet; die Registrierung verlangt den Code.
- **Umfang:**
  - PoC-Hinweis (Wortlaut): "Proof of Concept – vollständig KI-generiert („vibe-coded"). Keine Gewähr für Sicherheit oder Verfügbarkeit. Daten können jederzeit zurückgesetzt werden. Bitte keine sensiblen Angaben eintragen."
  - Orte: Startseite bzw. Anmeldeseite, Registrierung (vor der Einwilligung), Footer jeder Seite, Datenschutzerklärung.
  - Codefeld bei der Registrierung (Anfrage an S-15).
  - Hinweis ist Text, nicht HTML; keine Abhängigkeit von Trackern.
- **Option (Orchestrator):** Footer und Startseite können vorgezogen werden, unabhängig von S-15.
- **Abnahmekriterien:**
  - Hinweis an allen vier Orten sichtbar (Playwright, alle vier Projekte bzw. Chromium-visuell für das Aussehen).
  - Codefeld vorhanden; Fehlermeldung bei falschem Code.
  - Texte stimmen mit E31 überein.
- **Abhängigkeiten:** C-03 (Registrierungsablauf), S-15 (Code-API). Footer und Startseite optional vorab.
- **Quelle:** ENTSCHEIDUNGEN.md E31.
