# PUG- & Social-Logbook

**Ein privates Notizbuch über die Leute, mit denen man unterwegs war.**

*[English version](README.en.md)*

> Der Kern heißt im AddOns-Verzeichnis **PugLog**, der Slash-Befehl ist
> `/pug`.

Die LFG-Suche bietet keinerlei Kontext über frühere Begegnungen. Dieses
Addon merkt sich, wer dabei war — und lässt einen selbst dazuschreiben, was
man sich merken will.

## Stand: Logbuch funktioniert, Oberfläche fehlt

Erfassen, notieren, mit Merkmalen versehen und bewerten **funktioniert** und
ist getestet (33 Logiktests, alle grün) — aber bisher nur über
Slash-Befehle. Die anklickbare Oberfläche ist der nächste Schritt, siehe
[`Planung/`](Planung/).

## Die Haltung dahinter

Dieses Addon speichert Notizen über **Menschen**. Deshalb steht am Anfang
keine Funktionsliste, sondern vier Festlegungen:

1. **Alles bleibt lokal.** Die Daten verlassen den Rechner nicht von selbst.
2. **Freitext wird nie geteilt.** Eine Notiz ist für einen selbst
   geschrieben. Geteilt werden — wenn überhaupt — Merkmale und Bewertung.
3. **Die Bewertung vergibt der Mensch.** Kein Ableiten aus Kampfdaten: Wer
   das tut, misst Gear und Tagesform.
4. **Festgehalten wird nur, was man ohnehin gesehen hat.**

## Befehle

| Befehl | Wirkung |
|---|---|
| `/pug` | Das Buch öffnen |
| `/pug note <Name> <Text>` | Notiz setzen (leer = entfernen) |
| `/pug tag <Name> <Merkmal>` | Merkmal an-/abschalten |
| `/pug rate <Name> 1-5` | Bewerten (ohne Zahl = entfernen) |
| `/pug doctor` | Selbstdiagnose |

Erfasst wird am **Ende** eines Laufs — bei abgeschlossenem Keystone,
gewonnenem Bosskampf oder beim Auflösen der Gruppe. Wer beim Betreten
erfasst, hält die fest, die gleich wieder gehen, und verpasst die, die
nachrücken.

## Aufbau

```
PugLog/                     Kern
PugLog_LFGHighlighter/      Modul – Hinweis im Group Finder
PugLog_CommunityShare/      Modul – Teilen in fester Gruppe (siehe Planung)
```

## Was es *nicht* kann

- **Bewerber automatisch sortieren oder ablehnen.** Der Group Finder ist
  geschützter Bereich. Das Modul *zeigt* einen Hinweis, entschieden wird vom
  Menschen.
- **Umbenennungen und Transfers nachvollziehen.** Der Schlüssel ist
  Name-Realm; danach ist ein Eintrag verwaist. Nicht lösbar, nur aushaltbar.
- **Eine öffentliche Liste führen.** Es gibt keinen Weg, aus diesem Addon
  heraus eine Sammlung von Namen ins Netz zu stellen — und den soll es auch
  nicht geben.
- **Unbegrenzt mitschreiben.** Je Person werden höchstens 25 Begegnungen
  aufgehoben; die gespeicherte Datei wird bei jedem Ausloggen vollständig
  geschrieben.

## Entwickeln

```bash
tools/junction.cmd
./tools/test.sh
```

## Lizenz

MIT, siehe [LICENSE](LICENSE).
