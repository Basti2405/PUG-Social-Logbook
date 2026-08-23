-- Logik/Logbuch.lua - wer war dabei, und was war
--
-- ===========================================================================
-- WAS HIER GESPEICHERT WIRD - UND WAS NICHT
-- ---------------------------------------------------------------------------
-- Gespeichert wird, was der Spieler ohnehin gesehen hat: mit wem er in einer
-- Gruppe war, wann, wo, und was er selbst dazu notiert. Nicht gespeichert
-- wird irgendetwas, das er nicht sehen konnte.
--
-- Diese Daten verlassen den Rechner NICHT von selbst. Es gibt keinen
-- Automatismus, der Notizen verschickt - das Teilen ist ein eigenes Modul,
-- es fragt, und es teilt nur, was ausdruecklich freigegeben wurde. Eine
-- Notiz ueber einen Menschen ist etwas anderes als eine Zahl ueber ein Item.
--
-- ZUR BEWERTUNG
-- ---------------------------------------------------------------------------
-- Die Bewertung ist bewusst eine Zahl von 1 bis 5 OHNE vorgegebene
-- Bedeutung, und sie wird nie automatisch vergeben. Ein Addon, das aus
-- Kampfdaten "guter Spieler" ableitet, misst in Wahrheit Ausruestung und
-- Tagesform. Wer bewertet, tut das selbst - dann weiss er auch, was er
-- gemeint hat.
-- ===========================================================================
local PL = _G.PugLog
local K = PL.Kompat

PL.Logbuch = PL.Logbuch or {}
local B = PL.Logbuch

-- Wie viele Begegnungen je Spieler aufgehoben werden. Ohne Grenze waechst
-- die gespeicherte Datei mit jedem Lauf, und sie wird bei JEDEM Ausloggen
-- vollstaendig geschrieben - irgendwann merkt man das.
local MAX_BEGEGNUNGEN = 25

local function eintraege()
    local db = PL.Speicher and PL.Speicher.db
    if not db then return nil end
    db.spieler = db.spieler or {}
    return db.spieler
end

B.Alle = eintraege

-- ---------------------------------------------------------------------------
-- Nachschlagen
-- ---------------------------------------------------------------------------
function B.Holen(schluessel)
    local alle = eintraege()
    if not alle then return nil end
    return alle[schluessel]
end

function B.HolenOderAnlegen(schluessel)
    local alle = eintraege()
    if not alle or not schluessel then return nil end

    local eintrag = alle[schluessel]
    if not eintrag then
        eintrag = {
            schluessel = schluessel,
            begegnungen = {},
            merkmale = {},
            notiz = nil,
            bewertung = nil,
        }
        alle[schluessel] = eintrag
    end
    return eintrag
end

-- ---------------------------------------------------------------------------
-- Eine Begegnung festhalten
-- ---------------------------------------------------------------------------
function B.Begegnung(schluessel, angaben)
    local eintrag = B.HolenOderAnlegen(schluessel)
    if not eintrag then return nil end

    angaben = angaben or {}
    eintrag.klasse = angaben.klasse or eintrag.klasse

    local begegnung = {
        wann = K.Datum(),
        wo = angaben.wo,
        stufe = angaben.stufe,
        rolle = angaben.rolle,
    }

    table.insert(eintrag.begegnungen, 1, begegnung)

    -- Die aeltesten fallen hinten heraus.
    while #eintrag.begegnungen > MAX_BEGEGNUNGEN do
        table.remove(eintrag.begegnungen)
    end

    eintrag.zuletzt = begegnung.wann
    eintrag.anzahl = (eintrag.anzahl or 0) + 1

    return eintrag
end

-- Die ganze Gruppe auf einmal - so, wie es nach einem Lauf passiert.
function B.GruppeFesthalten(gruppe, angaben)
    if not gruppe then return 0 end
    local n = 0
    for _, mitglied in ipairs(gruppe) do
        local a = {
            klasse = mitglied.klasse,
            rolle = mitglied.rolle,
            wo = angaben and angaben.wo,
            stufe = angaben and angaben.stufe,
        }
        if B.Begegnung(mitglied.schluessel, a) then n = n + 1 end
    end
    return n
end

-- ---------------------------------------------------------------------------
-- Notiz, Merkmale, Bewertung
-- ---------------------------------------------------------------------------
function B.Notieren(schluessel, text)
    local eintrag = B.HolenOderAnlegen(schluessel)
    if not eintrag then return nil end

    text = text and strtrim(text) or ""
    -- Eine geleerte Notiz wird entfernt, nicht als leerer Text behalten -
    -- sonst sieht ein Eintrag "notiert" aus, an dem nichts steht.
    eintrag.notiz = (text ~= "") and text or nil
    return eintrag
end

function B.Merkmal(schluessel, merkmal, an)
    local eintrag = B.HolenOderAnlegen(schluessel)
    if not eintrag or not merkmal or merkmal == "" then return nil end

    merkmal = merkmal:lower()
    if an == nil then
        -- Umschalten, wenn nichts vorgegeben ist.
        an = not eintrag.merkmale[merkmal]
    end
    eintrag.merkmale[merkmal] = an and true or nil
    return eintrag
end

function B.Bewerten(schluessel, sterne)
    local eintrag = B.HolenOderAnlegen(schluessel)
    if not eintrag then return nil end

    sterne = tonumber(sterne)
    if not sterne then
        eintrag.bewertung = nil
        return eintrag
    end

    -- In den erlaubten Bereich zwingen, statt eine 9 zu speichern, die die
    -- Oberflaeche spaeter nicht darstellen kann.
    sterne = math.floor(sterne + 0.5)
    if sterne < 1 then sterne = 1 end
    if sterne > 5 then sterne = 5 end

    eintrag.bewertung = sterne
    return eintrag
end

-- ---------------------------------------------------------------------------
-- Suchen
-- ---------------------------------------------------------------------------
-- Der Aufrufer bekommt eine sortierte Liste: zuletzt gesehen zuerst. Ohne
-- feste Sortierung sieht dieselbe Liste bei jedem Aufruf anders aus, weil
-- pairs() keine Reihenfolge zusagt.
function B.Liste(filter)
    local alle = eintraege()
    if not alle then return {} end

    filter = filter and filter:lower() or nil

    local ergebnis = {}
    for schluessel, eintrag in pairs(alle) do
        if not filter or schluessel:lower():find(filter, 1, true) then
            ergebnis[#ergebnis + 1] = eintrag
        end
    end

    table.sort(ergebnis, function(a, b)
        return (a.zuletzt or 0) > (b.zuletzt or 0)
    end)
    return ergebnis
end
