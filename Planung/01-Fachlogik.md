# Fachlogik des Kerns

## Was heute steht

Das Logbuch ist **funktionsfähig**, nicht nur skizziert:

- Gruppe erkennen (ohne einen selbst; fremder Realm bleibt am Namen).
- Begegnung festhalten, mit Ort und Keystonestufe.
- Notiz setzen und wieder entfernen (eine geleerte Notiz wird entfernt, nicht
  als Leertext behalten — sonst sieht ein Eintrag „notiert" aus, an dem
  nichts steht).
- Merkmale setzen, umschalten, entfernen.
- Bewertung 1–5, mit Begrenzung: Eine 9 wird zu 5, eine −3 zu 1, 3,6 zu 4,
  Text zu keiner Bewertung. Sonst stünde in der Datei ein Wert, den die
  Oberfläche nicht darstellen kann.
- Liste, sortiert nach „zuletzt gesehen", mit Suche.
- Slash-Befehle: `/pug`, `/pug note`, `/pug tag`, `/pug rate`, `/pug doctor`.
- **33 Logiktests, alle grün.**

## Noch zu bauen

### Oberfläche zum Bearbeiten

Heute läuft alles über Slash-Befehle. Das ist für den Anfang richtig — die
Logik steht dahinter und ist getestet —, aber niemand tippt auf Dauer
`/pug note Tankwart ruhiger Tank`.

Gebraucht wird: Liste anklicken, Notiz in ein Feld, Sterne anklicken,
Merkmale als Knöpfe. **Das** ist der Zeitpunkt für AceGUI.

### Merkmale mit Vorschlägen

Freitext-Merkmale laufen auseinander („leaver", „Leaver", „geleavt"). Eine
kurze Vorschlagsliste, ergänzbar, hält das zusammen. Kleinschreibung
passiert bereits.

### Kontext beim Eintrag

Was war das für ein Lauf — abgeschlossen, abgebrochen, in der Zeit? Erhöht
den Wert einer Notiz erheblich, weil man später weiß, worauf sie sich bezog.

## Was bewusst nicht kommt

- **Keine automatische Bewertung** aus Schaden, Heilung oder Todesfällen.
- **Keine öffentliche Liste.** Es gibt keinen Weg, aus diesem Addon heraus
  eine Sammlung von Namen ins Netz zu stellen, und den soll es auch nicht
  geben.
