# C-11 – Native Hülle per Capacitor [Wunsch]

- **Status:** zurückgestellt (Nutzerentscheid 18.11.2026: erstmal keine native App). Nicht gelöscht.
- **Repo:** client
- **Ziel:** Frontend zusätzlich als native App für iOS 18+ und Android 12+ per Capacitor (E1). Kein Flutter, kein Kotlin Multiplatform.
- **Umfang:**
  - Capacitor-Einrichtung, iOS- und Android-Projekt erzeugt und baubar.
  - Web-Code bleibt die eine Codebasis (E1).
  - Passkeys im WebView: Abhängig vom Ergebnis C-01b.
- **Abnahmekriterien:**
  - Build für iOS 18+ und Android 12+ möglich und dokumentiert.
  - Kernfunktionen laufen in der nativen Hülle (Smoke-Test).
  - Ergebnis des C-01b-Spikes (Passkeys im WebView) ist berücksichtigt.
- **Abhängigkeiten:** C-01a, C-01b, C-15 (native Passkeys und Token-Sitzung, E15). Capacitor ist nicht Teil der S-04-Umsetzung.
- **Quelle:** ENTSCHEIDUNGEN.md E1; client/README.md, "Wunsch-Kriterien".
