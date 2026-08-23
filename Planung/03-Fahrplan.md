# Fahrplan

## Reihenfolge

| # | Schritt | Warum diese Stelle |
|---|---|---|
| 1 | Oberfläche zum Bearbeiten | Die Logik steht und ist getestet; es fehlt nur der bequeme Weg dorthin. |
| 2 | Merkmale mit Vorschlägen | Klein, hält die Daten sauber. |
| 3 | Kontext beim Eintrag (abgeschlossen/abgebrochen) | Erhöht den Wert jeder Notiz. |
| 4 | Modul LFGHighlighter | Der eigentliche Alltagsnutzen — aber erst sinnvoll, wenn genug Einträge da sind. |
| 5 | Modul CommunityShare | Nur, wenn die Frage aus `02-Module.md` beantwortet ist. |

## Offene Fragen

1. **Wird CommunityShare überhaupt gebaut?** Siehe `02-Module.md`. Solange
   die Frage offen ist, bleibt das Gerüst untätig — und das ist in Ordnung.
2. **Wie lange sollen Einträge leben?** Eine Bewertung von vor zwei Jahren
   sagt wenig über heute. Ein Vorschlag: Einträge, die lange nicht berührt
   wurden, verblassen in der Anzeige, statt gelöscht zu werden.
3. **Umbenennungen und Transfers.** Nicht lösbar, aber die Oberfläche sollte
   erlauben, einen verwaisten Eintrag von Hand umzuhängen.

## Was heute steht

Ein funktionsfähiges Logbuch mit Slash-Befehlen, Begrenzung der
gespeicherten Begegnungen, Erfassung am Ende eines Laufs und zwei
Modul-Gerüsten. **33 Logiktests, alle grün.**
