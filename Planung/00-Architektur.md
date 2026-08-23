# Architektur

## Aufbau

```
PugLog/                     Kern  – Logbuch, Speicher, Fenster, Modulsystem
PugLog_LFGHighlighter/      Modul – Hinweis im Gruppenfinder
PugLog_CommunityShare/      Modul – Teilen in einer festen Gruppe
```

Beide Module tragen `## Dependencies: PugLog`. Der Kern kennt kein Modul
namentlich; er ruft Haken auf.

## Die Entscheidung, die alles andere bestimmt

Dieses Addon speichert **Notizen über Menschen**. Das ist etwas anderes als
Zahlen über Items, und deshalb steht am Anfang keine Funktionsliste, sondern
eine Haltung:

1. **Alles bleibt lokal.** Die Daten verlassen den Rechner nicht von selbst.
   Es gibt keinen Automatismus, der Notizen verschickt.
2. **Freitext wird nie geteilt.** Eine Notiz ist für einen selbst
   geschrieben, in einer Sprache, die nur für einen selbst gemeint war.
   Geteilt werden — wenn überhaupt — Merkmale und eine Bewertung.
3. **Die Bewertung vergibt der Mensch.** Ein Addon, das aus Kampfdaten
   „guter Spieler" ableitet, misst in Wahrheit Ausrüstung und Tagesform.
   Deshalb: eine Zahl von 1 bis 5, ohne vorgegebene Bedeutung, nie
   automatisch.
4. **Es wird nur festgehalten, was der Spieler ohnehin gesehen hat.**

Diese vier Punkte stehen auch im Quelltext (`Logik/Logbuch.lua`,
`PugLog_CommunityShare/Modul.lua`) — nicht nur hier, weil man beim
Programmieren vergisst, was woanders steht.

## Schlüssel: Name-Realm, nicht GUID

Die GUID wäre eindeutig, steht aber nicht mehr zur Verfügung, sobald der
Spieler die Gruppe verlassen hat — und genau **danach** will man
nachschlagen. Also Name-Realm. Fehlt der Realm, wird der eigene angenommen;
diese Annahme muss überall dieselbe sein, sonst findet die Suche den
vorhandenen Eintrag nicht (siehe `LFGHighlighter`).

Ein Nebeneffekt, der benannt gehört: **Nach einer Umbenennung oder einem
Transfer ist der Eintrag verwaist.** Das lässt sich nicht lösen, nur
aushalten.

## Wann erfasst wird

Am **Ende**, nicht am Anfang. Wer beim Betreten erfasst, hält auch die fest,
die nach zwei Minuten wieder gegangen sind, und verpasst die, die später
nachgerückt sind.

Erfasst wird bei `CHALLENGE_MODE_COMPLETED`, bei gewonnenem `ENCOUNTER_END`
und bei `GROUP_LEFT`. Weil die Gruppe beim Verlassen oft schon aufgelöst ist,
merkt sich der Kern laufend, wer zuletzt dabei war.

## Grenze der gespeicherten Daten

Je Spieler werden höchstens **25** Begegnungen aufgehoben (die Gesamtzahl
bleibt trotzdem richtig). Ohne Grenze wächst die Datei mit jedem Lauf — und
sie wird bei **jedem** Ausloggen vollständig geschrieben. Getestet.
