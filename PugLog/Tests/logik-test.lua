-- Tests/logik-test.lua - prueft die Logik ohne laufendes WoW
--
-- ===========================================================================
-- Aufruf:   ../tools/test.sh
--
-- Schwerpunkt ist das Logbuch: Bewertungen, die ausserhalb des erlaubten
-- Bereichs hereinkommen, Merkmale, die umgeschaltet werden, und die Grenze
-- fuer gespeicherte Begegnungen. Das sind die Stellen, an denen ein Fehler
-- erst Monate spaeter auffaellt - naemlich dann, wenn die gespeicherte Datei
-- zu gross geworden ist oder eine Bewertung nicht darstellbar ist.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- WoW nachbauen
-- ---------------------------------------------------------------------------
local ereignisse = {}

_G.UIParent = {}

function _G.CreateFrame()
    local f = {}
    f.RegisterEvent = function(_, e) ereignisse[e] = true end
    f.SetScript = function(self, was, fn) self["_" .. was] = fn end
    f.SetSize = function() end
    f.SetPoint = function() end
    f.ClearAllPoints = function() end
    f.SetMovable = function() end
    f.EnableMouse = function() end
    f.RegisterForDrag = function() end
    f.CreateFontString = function()
        return { SetPoint = function() end, SetJustifyH = function() end,
                 SetJustifyV = function() end, SetText = function() end }
    end
    f.Hide = function(self) self.gezeigt = false end
    f.Show = function(self) self.gezeigt = true end
    f.IsShown = function(self) return self.gezeigt end
    f.GetPoint = function() return "CENTER", nil, "CENTER", 0, 0 end
    f.StartMoving = function() end
    f.StopMovingOrSizing = function() end
    f.TitleText = { SetText = function() end }
    return f
end

_G.GetTime = os.clock
_G.time = os.time
_G.date = os.date
_G.strtrim = function(s) return (tostring(s):gsub("^%s+", ""):gsub("%s+$", "")) end
_G.GetLocale = function() return "enUS" end
_G.GetRealmName = function() return "Antonidas" end
_G.SlashCmdList = {}
_G.C_Timer = { After = function(_, fn) fn() end }
_G.print = function() end   -- Core meldet Erfassungen; im Test stoert das nur

-- Gruppe: zwei Mitspieler ausser einem selbst.
local gruppeAn = true
_G.IsInGroup = function() return gruppeAn end
_G.IsInRaid = function() return false end
_G.GetNumGroupMembers = function() return 3 end
_G.UnitIsUnit = function(a, b) return a == b end
_G.UnitName = function(einheit)
    if einheit == "player" then return "Ichselbst", nil end
    if einheit == "party1" then return "Tankwart", "Blackmoore" end
    if einheit == "party2" then return "Heilhand", nil end
    return nil
end
_G.UnitClass = function(einheit)
    if einheit == "party1" then return "Warrior", "WARRIOR" end
    return "Priest", "PRIEST"
end
_G.UnitGroupRolesAssigned = function(einheit)
    if einheit == "party1" then return "TANK" end
    return "HEALER"
end
_G.GetInstanceInfo = function() return "Turm der Pruefung", "party", 8, "Mythisch+" end
_G.C_ChallengeMode = { GetActiveKeystoneInfo = function() return 15 end }

-- ---------------------------------------------------------------------------
-- Testgeruest
-- ---------------------------------------------------------------------------
local bestanden, gefallen = 0, 0
local function pruefe(bedingung, was)
    if bedingung then
        bestanden = bestanden + 1
        print2(("  ok    %s"):format(was))
    else
        gefallen = gefallen + 1
        print2(("  FEHLT %s"):format(was))
    end
end
function print2(...) io.write(..., "\n") end

-- ---------------------------------------------------------------------------
-- Kern laden, in der Reihenfolge der .toc
-- ---------------------------------------------------------------------------
local hier = (arg and arg[0] or ""):match("(.*)Tests[/\\]") or "./"
local function lade(pfad)
    local fn, fehler = loadfile(hier .. pfad)
    if not fn then error("kann " .. pfad .. " nicht laden: " .. tostring(fehler)) end
    fn("PugLog", {})
end

lade("Logik/Kompat.lua")
lade("Locales/enUS.lua")
lade("Locales/deDE.lua")
lade("Logik/Speicher.lua")
lade("Logik/Logbuch.lua")
lade("Logik/Modulsystem.lua")
lade("Logik/Diagnose.lua")
lade("UI/Fenster.lua")
lade("Core.lua")

local PL = _G.PugLog
local B = PL.Logbuch

print2("Kern")
pruefe(PL ~= nil, "Namensraum ist global erreichbar")
pruefe(ereignisse["CHALLENGE_MODE_COMPLETED"], "Schluesselstein-Ende ist angemeldet")
pruefe(ereignisse["ENCOUNTER_END"], "Bosskampf-Ende ist angemeldet")
pruefe(_G.SlashCmdList["PUGLOG"] ~= nil, "Slash-Befehl ist angemeldet")

print2("Gruppe erkennen")
local gruppe = PL.Kompat.Gruppe()
pruefe(gruppe and #gruppe == 2, "eigener Charakter wird NICHT mitgezaehlt")
pruefe(gruppe and gruppe[1].schluessel == "Tankwart-Blackmoore", "fremder Realm kommt an den Namen")
pruefe(gruppe and gruppe[2].schluessel == "Heilhand-Antonidas", "eigener Realm wird ergaenzt")
pruefe(gruppe and gruppe[1].rolle == "TANK", "Rolle kommt mit")

gruppeAn = false
pruefe(PL.Kompat.Gruppe() == nil, "allein ergibt nil, nicht eine leere Liste")
gruppeAn = true

print2("Logbuch")
PL.Speicher.Start()

local n = B.GruppeFesthalten(PL.Kompat.Gruppe(), { wo = "Turm der Pruefung", stufe = 15 })
pruefe(n == 2, "beide Mitspieler wurden festgehalten")

local e = B.Holen("Tankwart-Blackmoore")
pruefe(e ~= nil, "Eintrag wurde angelegt")
pruefe(e.anzahl == 1, "Begegnung wurde gezaehlt")
pruefe(e.begegnungen[1].wo == "Turm der Pruefung", "Ort wurde festgehalten")
pruefe(e.begegnungen[1].stufe == 15, "Schluesselstufe wurde festgehalten")
pruefe(e.klasse == "WARRIOR", "Klasse wurde festgehalten")

print2("Notiz")
B.Notieren("Tankwart-Blackmoore", "  ruhiger Tank  ")
pruefe(B.Holen("Tankwart-Blackmoore").notiz == "ruhiger Tank", "Notiz wird von Leerzeichen befreit")
B.Notieren("Tankwart-Blackmoore", "   ")
pruefe(B.Holen("Tankwart-Blackmoore").notiz == nil, "geleerte Notiz wird entfernt, nicht als Leertext behalten")

print2("Merkmale")
B.Merkmal("Tankwart-Blackmoore", "Shotcaller")
pruefe(B.Holen("Tankwart-Blackmoore").merkmale["shotcaller"] == true, "Merkmal wird kleingeschrieben gesetzt")
B.Merkmal("Tankwart-Blackmoore", "Shotcaller")
pruefe(B.Holen("Tankwart-Blackmoore").merkmale["shotcaller"] == nil, "zweiter Aufruf schaltet es wieder ab")
B.Merkmal("Tankwart-Blackmoore", "leaver", true)
pruefe(B.Holen("Tankwart-Blackmoore").merkmale["leaver"] == true, "ausdrueckliches Setzen greift")

print2("Bewertung")
B.Bewerten("Heilhand-Antonidas", 4)
pruefe(B.Holen("Heilhand-Antonidas").bewertung == 4, "Bewertung wird uebernommen")
B.Bewerten("Heilhand-Antonidas", 9)
pruefe(B.Holen("Heilhand-Antonidas").bewertung == 5, "zu hohe Bewertung wird auf 5 begrenzt")
B.Bewerten("Heilhand-Antonidas", -3)
pruefe(B.Holen("Heilhand-Antonidas").bewertung == 1, "zu niedrige Bewertung wird auf 1 angehoben")
B.Bewerten("Heilhand-Antonidas", 3.6)
pruefe(B.Holen("Heilhand-Antonidas").bewertung == 4, "Kommazahl wird gerundet")
B.Bewerten("Heilhand-Antonidas", nil)
pruefe(B.Holen("Heilhand-Antonidas").bewertung == nil, "Bewertung laesst sich wieder entfernen")
B.Bewerten("Heilhand-Antonidas", "kein Wert")
pruefe(B.Holen("Heilhand-Antonidas").bewertung == nil, "Text statt Zahl setzt keine Bewertung")

print2("Grenze der Begegnungen")
for i = 1, 40 do
    B.Begegnung("Vielflieger-Antonidas", { wo = "Lauf " .. i })
end
local viel = B.Holen("Vielflieger-Antonidas")
pruefe(#viel.begegnungen == 25, "es werden hoechstens 25 Begegnungen aufgehoben")
pruefe(viel.begegnungen[1].wo == "Lauf 40", "die neueste steht vorn")
pruefe(viel.anzahl == 40, "die Gesamtzahl bleibt trotzdem richtig")

print2("Liste")
local liste = B.Liste()
pruefe(#liste == 3, "alle Eintraege werden gelistet")
pruefe(liste[1].zuletzt >= liste[#liste].zuletzt, "zuletzt gesehen steht vorn")
pruefe(#B.Liste("tankwart") == 1, "Suche findet ohne Ruecksicht auf Gross-/Kleinschreibung")
pruefe(#B.Liste("gibtsnicht") == 0, "Suche ohne Treffer gibt eine leere Liste")

print2("")
print2(("bestanden: %d   gefallen: %d"):format(bestanden, gefallen))
if gefallen > 0 then os.exit(1) end
os.exit(0)
