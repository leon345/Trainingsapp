# S-13 – README-Verweis goals/ ersetzen

- **Status:** umgesetzt, Merge offen (Branch `task/S-13-readme-goals`, Commit 137b2c1). Nur Zeile 5 geändert; Satz "Akzeptanzkriterien stehen in docs/" bewusst nicht übernommen, da `docs/` noch keine Akzeptanzkriterien enthält. Veraltet und unverändert: "Offene Entscheidungen" (Zeilen 47–51) und "Status: Planung" (Zeile 5), siehe Nutzerfrage 6.
- **Repo:** server
- **Ziel:** Toten Verweis auf `goals/` im Server-README durch einen gültigen Satz ersetzen (E8).
- **Betroffene Datei:** `server/README.md`, Zeile 5 (Status-Absatz).
- **Änderung:** "werden als prüfbare Ziele (`goals/`) umgesetzt" wird ersetzt durch "werden als prüfbare Tasks umgesetzt". Akzeptanzkriterien stehen in `docs/` des Repos.
- **Abnahmekriterien:**
  - Kein Verweis auf `goals/` mehr im Server-Repo.
  - Keine anderen Inhalte des README geändert.
  - Ein Verweis auf `docs/` ist nur erlaubt, wenn der Ordner existiert (S-01 legt `docs/api-konventionen.md` an).
- **Abhängigkeiten:** keine.
- **Quelle:** ENTSCHEIDUNGEN.md E8.
