# C-01b – Spike: Timer bei gesperrtem iOS-Bildschirm (Safari)

- **Status:** blockiert – braucht ein echtes iOS-Gerät und den Nutzer. Ein Worker allein kann diesen Spike nicht erledigen. Teil "Passkeys im Capacitor-WebView" entfällt vorerst (Nutzerentscheid 18.11.2026, keine native App).
- **Repo:** client
- **Timebox:** max. 2 Tage (E1).
- **Ergänzt (E33, 18.11.2026):** Ton und Vibration des Phasenwechsels unter iOS-Safari prüfen, auch bei gesperrtem Bildschirm und mit Stummschalter (Ergebnis für C-17).
- **Frage (verbleibend):** Läuft der Timer unter iOS-Safari bei gesperrtem Bildschirm genau genug? Prüfen: Wake Lock, Berechnung aus Zeitstempeln statt setInterval.
- **Begründung für den Umfang:** Safari auf dem Handy bleibt ein Muss (client/README). Der Timer muss auf dem Gerät funktionieren, auch bei gesperrtem Bildschirm.
- **Entfallen (zurückgestellt):** Passkeys im Capacitor-WebView unter iOS. Wird mit C-15 wieder aufgenommen, falls die native App kommt.
- **Vorgehen:**
  - Worker stellt eine Testseite bereit (Timer mit Zeitstempeln).
  - Nutzer führt den Test auf einem iPhone (iOS 18+) aus und berichtet das Ergebnis.
  - Ergebnis dokumentieren in `docs/spike-ios.md` im client-Repo.
- **Abnahmekriterien:**
  - Frage mit Messwert oder klarem Ja/Nein beantwortet.
  - Empfehlung für C-02 (Timer-Ansatz).
- **Abhängigkeiten:** C-01a. Nutzer mit iOS-Gerät.
- **Auswirkung:** Ergebnis beeinflusst C-02 (Timer). Keine Auswirkung mehr auf C-11/C-13/C-15 (zurückgestellt).
- **Quelle:** ENTSCHEIDUNGEN.md E1 ("Noch zu verifizieren"), Nutzerentscheid 18.11.2026.
