-- Modul.lua - Bewerber im Gruppenfinder kennzeichnen
--
-- ===========================================================================
-- STAND: Geruest. Siehe Planung/02-Module.md.
--
-- WAS HIER ZU BEACHTEN IST
-- ---------------------------------------------------------------------------
-- Der Gruppenfinder ist geschuetzter Bereich. Wer Bewerber automatisch
-- sortiert, annimmt oder ablehnt, greift in geschuetzte Ablaeufe ein - das
-- ist nicht erlaubt und wuerde beim ersten Patch brechen. Dieses Modul
-- ZEIGT deshalb nur etwas an: eine Markierung an einer Zeile, die es ohnehin
-- schon gibt. Die Entscheidung trifft weiterhin der Mensch.
--
-- Zweitens: Ein Bewerber wird im Finder mit Name-Realm gefuehrt, aber nicht
-- immer vollstaendig. Wo der Realm fehlt, wird der eigene angenommen - das
-- ist dieselbe Annahme, die der Kern trifft, und sie muss dieselbe bleiben,
-- sonst findet die Suche den vorhandenen Eintrag nicht.
-- ===========================================================================
local PL = _G.PugLog
if not PL or not PL.Module then return end

local Modul = PL.Module.Registrieren("LFGHighlighter", {})

function Modul:Pruefen()
    if not (C_LFGList and C_LFGList.GetApplicantMemberInfo) then
        return false, "C_LFGList steht in diesem Client nicht zur Verfuegung"
    end
    return true
end

function Modul:Start()
    self.daten = PL.Speicher.ModulSchublade("lfghighlighter")
end

-- Gibt es zu diesem Namen einen Eintrag - und was ist das Bemerkenswerte
-- daran? Nur das wird angezeigt, nicht die ganze Notiz: Im Gruppenfinder ist
-- kein Platz, und eine Notiz ueber einen Menschen gehoert nicht beilaeufig
-- in eine Liste.
function Modul:Kurzhinweis(name)
    if not name or name == "" then return nil end

    local eintrag = PL.Logbuch.Holen(name)
    if not eintrag then
        -- Ohne Realm noch einmal versuchen, so wie der Kern es tut.
        local realm = GetRealmName and GetRealmName() or ""
        realm = (realm or ""):gsub("%s+", "")
        if realm ~= "" and not name:find("-", 1, true) then
            eintrag = PL.Logbuch.Holen(name .. "-" .. realm)
        end
    end
    if not eintrag then return nil end

    return {
        bewertung = eintrag.bewertung,
        merkmale = eintrag.merkmale,
        anzahl = eintrag.anzahl,
    }
end

function Modul:Kennzahl()
    return PL.L["LH_READY"]
end
