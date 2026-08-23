-- Core.lua - startet alles auf und nimmt die Befehle entgegen
--
-- ===========================================================================
-- Laedt als LETZTE Datei des Kerns (siehe .toc).
--
-- WANN ERFASST WIRD
-- ---------------------------------------------------------------------------
-- Am Ende, nicht am Anfang. Wer beim Betreten der Instanz erfasst, haelt auch
-- die fest, die nach zwei Minuten wieder gegangen sind - und verpasst die,
-- die spaeter nachgerueckt sind. Erfasst wird deshalb, wenn der Lauf
-- vorbei ist: beim Abschluss eines Schluesselsteins, beim Verlassen der
-- Instanz und beim Aufloesen der Gruppe.
-- ===========================================================================
local PL = _G.PugLog
local K = PL.Kompat
local M = PL.Module
local B = PL.Logbuch

-- Was zuletzt gesehen wurde. Beim Verlassen der Instanz ist die Gruppe oft
-- schon aufgeloest - dann steht hier noch, mit wem man drin war.
local letzteGruppe, letzterOrt, letzteStufe

local function merken()
    local gruppe = K.Gruppe()
    if gruppe then letzteGruppe = gruppe end

    local instanz = K.Instanz()
    if instanz then
        letzterOrt = instanz.name
        letzteStufe = K.Schluesselstein()
    end
end

local function festhalten(grund)
    local gruppe = K.Gruppe() or letzteGruppe
    if not gruppe then return end

    local n = B.GruppeFesthalten(gruppe, { wo = letzterOrt, stufe = letzteStufe })
    if n > 0 then
        print(("|cffb98cff[PugLog]|r " .. PL.L["RECORDED"]):format(n, letzterOrt or grund or "?"))
    end

    letzteGruppe = nil
    M.Rufen("Aktualisieren")
end

-- ---------------------------------------------------------------------------
-- Login und Ereignisse
-- ---------------------------------------------------------------------------
K.Horchen("PLAYER_LOGIN", function()
    PL.Speicher.Start()
    M.Pruefen()
    M.Rufen("Start")
end)

-- Solange man unterwegs ist, im Blick behalten, wer dabei ist.
K.Horchen("GROUP_ROSTER_UPDATE", merken)
K.Horchen("PLAYER_ENTERING_WORLD", function() K.Spaeter(3, merken) end)

-- Schluesselstein abgeschlossen: der klarste Zeitpunkt, den es gibt.
K.Horchen("CHALLENGE_MODE_COMPLETED", function()
    merken()
    K.Spaeter(1, function() festhalten("Schluesselstein") end)
end)

-- Bosskampf gewonnen.
K.Horchen("ENCOUNTER_END", function(_, _, _, _, _, erfolg)
    if erfolg == 1 then
        merken()
        K.Spaeter(1, function() festhalten("Bosskampf") end)
    end
end)

-- Gruppe loest sich auf - letzte Gelegenheit.
K.Horchen("GROUP_LEFT", function() festhalten("Gruppe") end)

-- ---------------------------------------------------------------------------
-- Befehle
-- ---------------------------------------------------------------------------
-- Der Name kann mit oder ohne Realm angegeben werden. Ohne Realm wird der
-- erste passende Eintrag genommen - im Alltag tippt niemand "-Antonidas" mit.
local function findeSchluessel(name)
    if not name or name == "" then return nil end
    if B.Holen(name) then return name end

    local gesucht = name:lower()
    for _, eintrag in ipairs(B.Liste()) do
        local nurName = eintrag.schluessel:match("^([^-]+)")
        if nurName and nurName:lower() == gesucht then
            return eintrag.schluessel
        end
    end
    return nil
end

local function befehl(eingabe)
    local roh = strtrim(eingabe or "")
    local wort, rest = roh:match("^(%S*)%s*(.*)$")
    wort = (wort or ""):lower()

    if wort == "" then
        PL.UI.Umschalten()

    elseif wort == "doctor" then
        PL.Diagnose.Bericht()

    elseif wort == "note" or wort == "notiz" then
        local name, text = rest:match("^(%S+)%s*(.*)$")
        if not name then return print("|cffb98cff[PugLog]|r " .. PL.L["NEED_NAME"]) end
        -- Eine Notiz darf auch ueber jemanden angelegt werden, der noch nicht
        -- im Buch steht - man trifft ihn ja gerade.
        local schluessel = findeSchluessel(name) or name
        B.Notieren(schluessel, text)
        local meldung = (text ~= "") and PL.L["NOTE_SET"] or PL.L["NOTE_CLEARED"]
        print("|cffb98cff[PugLog]|r " .. meldung:format(schluessel))

    elseif wort == "tag" or wort == "merkmal" then
        local name, merkmal = rest:match("^(%S+)%s+(%S+)$")
        if not name or not merkmal then return print("|cffb98cff[PugLog]|r " .. PL.L["NEED_NAME"]) end
        local schluessel = findeSchluessel(name) or name
        local eintrag = B.Merkmal(schluessel, merkmal)
        local an = eintrag and eintrag.merkmale[merkmal:lower()]
        local meldung = an and PL.L["TAG_ON"] or PL.L["TAG_OFF"]
        print("|cffb98cff[PugLog]|r " .. meldung:format(merkmal:lower(), schluessel))

    elseif wort == "rate" or wort == "note5" then
        local name, sterne = rest:match("^(%S+)%s*(%S*)$")
        if not name then return print("|cffb98cff[PugLog]|r " .. PL.L["NEED_NAME"]) end
        local schluessel = findeSchluessel(name)
        if not schluessel then
            return print(("|cffb98cff[PugLog]|r " .. PL.L["UNKNOWN_PLAYER"]):format(name))
        end
        local eintrag = B.Bewerten(schluessel, sterne ~= "" and sterne or nil)
        if eintrag.bewertung then
            print(("|cffb98cff[PugLog]|r " .. PL.L["RATED"]):format(schluessel, eintrag.bewertung))
        else
            print(("|cffb98cff[PugLog]|r " .. PL.L["RATE_CLEARED"]):format(schluessel))
        end

    elseif wort == "help" or wort == "hilfe" then
        print("|cffb98cff[PugLog]|r " .. PL.L["SLASH_HINT"])

    else
        local behandelt = false
        for _, modul in ipairs(M.Aktive()) do
            if M.RufenAuf(modul, "Befehl", wort, rest) then
                behandelt = true
                break
            end
        end
        if not behandelt then
            print("|cffb98cff[PugLog]|r " .. PL.L["SLASH_HINT"])
        end
    end
end

SLASH_PUGLOG1 = "/pug"
SLASH_PUGLOG2 = "/puglog"
SlashCmdList["PUGLOG"] = befehl
