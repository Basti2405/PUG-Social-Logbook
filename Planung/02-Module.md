# Module

## LFGHighlighter — Hinweis im Group Finder

**Zweck.** Beim Durchsehen der Bewerber sofort sehen, zu wem schon ein
Eintrag vorliegt.

**Die harte Grenze:** Der Group Finder ist **geschützter Bereich**. Wer
Bewerber automatisch sortiert, annimmt oder ablehnt, greift in geschützte
Abläufe ein — das ist nicht erlaubt und bräche beim ersten Patch.

Dieses Modul **zeigt** deshalb nur etwas an: eine Markierung an einer Zeile,
die es ohnehin schon gibt. Entschieden wird weiterhin vom Menschen.

Aus demselben Grund heißt der Haken `Kurzhinweis` und liefert **nicht** die
Notiz: Im Group Finder ist kein Platz, und eine Notiz über einen Menschen
gehört nicht beiläufig in eine Liste. Bewertung, Merkmale, Anzahl der
Begegnungen — mehr nicht.

**Datenquelle.** `C_LFGList.GetApplicantMemberInfo`.

**Fallstricke:**

- Bewerbernamen kommen nicht immer mit Realm. Die Ergänzung muss **exakt**
  dieselbe sein wie im Kern, sonst wird der vorhandene Eintrag nicht
  gefunden. Bereits so gebaut.
- Die Bewerberliste ändert sich schnell. Bei jeder Änderung alles neu
  nachzuschlagen ist teuer — innerhalb einer Suche zwischenspeichern.

**Aufwand:** klein bis mittel. Der Aufwand liegt im Anhängen an die
vorhandenen Zeilen, nicht im Nachschlagen.

---

## CommunityShare — Teilen in einer festen Gruppe

Das Modul, bei dem man am ehesten etwas falsch macht. Die Regeln stehen im
Quelltext und hier:

1. **Nichts geht automatisch hinaus.** Der Spieler stößt es an, jedes Mal.
2. **Freitext-Notizen werden nie geteilt.** Nur Merkmale und Bewertung.
3. **Nur mit einer benannten, festen Gruppe** — nicht mit der Gilde, nicht
   mit einem offenen Kanal, nicht mit allen.
4. **Ein Addon-Kanal ist mitlesbar.** Verschlüsselung verschiebt das Problem
   nur, weil der Schlüssel bei allen liegen müsste.

**Und die unangenehme Frage, die vor dem Bau zu beantworten ist:** Eine
geteilte Liste von Bewertungen über namentlich genannte Menschen ist ihrem
Wesen nach eine Bewertungsliste. Sie kann gegen Leute verwendet werden, die
nie erfahren, dass sie darauf stehen.

Wenn dieses Modul gebaut wird, dann mit einer sehr engen Auslegung von
Punkt 3 — oder gar nicht. **Diese Entscheidung ist noch nicht getroffen.**
Das Gerüst ist bewusst so angelegt, dass ohne eingetragene Gruppe **nichts**
passiert, und das bleibt der Grundzustand.

**Aufwand:** mittel. **Empfehlung:** zurückstellen, bis der Kern im Alltag
steht.
