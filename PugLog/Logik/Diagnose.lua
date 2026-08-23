-- Logik/Diagnose.lua - beantwortet  /pug doctor
--
-- ===========================================================================
-- WOZU
-- ---------------------------------------------------------------------------
-- Wenn ein Spieler sagt "geht nicht", ist die erste Frage immer dieselbe:
-- laedt das Addon ueberhaupt, steht der Speicher, welche Module sind
-- angekoppelt und welche haben sich abgemeldet - und warum. Diese Datei
-- beantwortet das in einem Rutsch, damit niemand raten muss.
--
-- Grundsatz: Sie stellt nichts fest, was sie nicht wirklich geprueft hat.
-- Lieber "unbekannt" als eine beruhigende Zeile, die nicht stimmt.
-- ===========================================================================
local PL = _G.PugLog
local M = PL.Module

PL.Diagnose = PL.Diagnose or {}
local D = PL.Diagnose

local function sag(text) print("|cff8080ff[PL]|r " .. tostring(text)) end

local function anzahl(tabelle)
    local n = 0
    for _ in pairs(tabelle or {}) do n = n + 1 end
    return n
end

function D.Bericht()
    local L = PL.L
    sag(L["DOCTOR_TITLE"])

    -- Fassung und Speicher
    sag(("Version %s"):format(PL.version or "?"))
    local db = PL.Speicher and PL.Speicher.db
    if db then
        sag(L["DOCTOR_STORAGE_OK"]:format(anzahl(db.spieler)))
    else
        sag(L["DOCTOR_STORAGE_NO"])
    end

    -- Gruppe. Sagt dem Spieler, ob gerade ueberhaupt etwas zu erfassen waere.
    local gruppe = PL.Kompat.Gruppe()
    if gruppe then
        sag(L["DOCTOR_GROUP"]:format(#gruppe))
    else
        sag(L["DOCTOR_ALONE"])
    end

    -- Module. Der Kern kennt sie nur ueber das Modulsystem - was hier steht,
    -- hat sich selbst angemeldet.
    if #M.liste == 0 then
        sag(L["DOCTOR_NO_MODULES"])
    else
        for _, modul in ipairs(M.liste) do
            if modul.aktiv then
                sag(L["DOCTOR_MODULE_ON"]:format(modul.name))
            else
                sag(L["DOCTOR_MODULE_OFF"]:format(modul.name, modul.grund or L["DOCTOR_NO_REASON"]))
            end
        end
    end

    -- Ein Fehler, der einen Ereignis-Horcher erwischt hat, wird in Kompat.lua
    -- weggefangen, damit er die anderen nicht mitreisst - hier ist die
    -- Stelle, an der er trotzdem sichtbar wird.
    if PL.letzterFehler then
        sag("Letzter abgefangener Fehler: " .. PL.letzterFehler)
    end
end
