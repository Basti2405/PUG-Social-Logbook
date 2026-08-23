-- UI/Fenster.lua - die Liste der Begegnungen
--
-- ===========================================================================
-- Ohne Fremdbibliothek gebaut. Gezeigt wird, wer zuletzt dabei war - mit
-- Bewertung, Merkmalen und der eigenen Notiz.
-- ===========================================================================
local PL = _G.PugLog
local M = PL.Module

PL.UI = PL.UI or {}
local UI = PL.UI

local BREITE, HOEHE = 640, 460
local MAX_ZEILEN = 18

local function bauen()
    local f = CreateFrame("Frame", "PugLogFenster", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(BREITE, HOEHE)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local punkt, _, relativ, x, y = self:GetPoint()
        local db = PL.Speicher and PL.Speicher.db
        if db then db.einstellungen.fensterPunkt = { punkt, relativ, x, y } end
    end)

    f.TitleText:SetText(PL.L["WINDOW_TITLE"])

    local text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", 18, -34)
    text:SetPoint("BOTTOMRIGHT", -18, 18)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    f.Inhalt = text

    local db = PL.Speicher and PL.Speicher.db
    local p = db and db.einstellungen.fensterPunkt
    if p then
        f:ClearAllPoints()
        f:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    end

    f:Hide()
    return f
end

function UI.Fenster()
    if not UI.rahmen then UI.rahmen = bauen() end
    return UI.rahmen
end

-- Sterne als Text. Ein Eintrag ohne Bewertung bekommt KEINE leeren Sterne,
-- sondern gar nichts - "noch nicht bewertet" und "schlecht bewertet" duerfen
-- nicht gleich aussehen.
local function sterne(n)
    if not n then return "" end
    return ("|cffffd100%s|r"):format(string.rep("*", n))
end

local function inhaltBauen()
    local L = PL.L
    local liste = PL.Logbuch.Liste()

    if #liste == 0 then
        return L["NO_DATA"]
    end

    local zeilen = { L["ENTRIES_KNOWN"]:format(#liste), " " }

    for i = 1, math.min(#liste, MAX_ZEILEN) do
        local e = liste[i]
        local wann = e.zuletzt and date("%d.%m.%Y", e.zuletzt) or "?"

        local merkmale = {}
        for merkmal in pairs(e.merkmale or {}) do merkmale[#merkmale + 1] = merkmal end
        table.sort(merkmale)

        local zeile = ("|cffffffff%s|r %s  |cff808080%s|r"):format(
            e.schluessel, sterne(e.bewertung), wann)

        if #merkmale > 0 then
            zeile = zeile .. ("  |cff40c0f0[%s]|r"):format(table.concat(merkmale, ", "))
        end
        if e.notiz then
            zeile = zeile .. "\n    " .. e.notiz
        end

        zeilen[#zeilen + 1] = zeile
    end

    if #liste > MAX_ZEILEN then
        zeilen[#zeilen + 1] = " "
        zeilen[#zeilen + 1] = L["AND_MORE"]:format(#liste - MAX_ZEILEN)
    end

    local kennzahlen = M.Rufen("Kennzahl")
    if #kennzahlen > 0 then
        zeilen[#zeilen + 1] = " "
        for _, treffer in ipairs(kennzahlen) do
            zeilen[#zeilen + 1] = ("|cff40c0f0%s|r  %s"):format(treffer.modul.name, tostring(treffer.wert))
        end
    end

    return table.concat(zeilen, "\n")
end

function UI.Umschalten()
    local f = UI.Fenster()
    if f:IsShown() then
        f:Hide()
    else
        f.Inhalt:SetText(inhaltBauen())
        f:Show()
    end
end
