# C-15 – Native Passkeys und Token-Sitzung [Wunsch, Vorbedingung für C-11/C-13]

- **Status:** zurückgestellt (Nutzerentscheid 18.11.2026: erstmal keine native App; Frage 12 beantwortet). Nicht gelöscht. Die Erweiterbarkeit des Auth-Service dafür wird über das Abnahmekriterium in S-04 vorbereitet.
- **Repo:** client und server (Port `Anmeldesitzung` im Server)
- **Ziel:** Anmeldemodell für die native App: Passkeys im nativen Kontext und Token-Sitzung statt Cookie (E15).
- **Umfang:**
  - Entwurf des Port `Anmeldesitzung` (Server), hinter dem das Token-Modell später steckt.
  - Native Passkey-Anbindung (Capacitor-Plugin oder Äquivalent), Entscheidung dokumentieren.
  - Token-Speicherung und Erneuerung auf dem Gerät.
  - Abgleich mit C-01b (Passkeys im WebView unter iOS).
- **Abnahmekriterien:**
  - Architekturentwurf dokumentiert und vom Council bestätigt.
  - Mindestens ein Spike auf einem Gerät (Nutzer nötig).
- **Abhängigkeiten:** S-04 (Umsetzung), C-01b, Frage 12.
- **Blockiert:** C-11, C-13.
- **Quelle:** ENTSCHEIDUNGEN.md E15 (Änderung an E1), Frage 12.
