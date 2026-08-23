-- Logik/Kompat.lua - Bruecke zu den Schnittstellen des Spiels
--
-- ===========================================================================
-- Legt als erste Datei den Namensraum GLOBAL an - die Module sind eigene
-- Addons und kaemen an eine addon-lokale Tabelle nicht heran.
-- ===========================================================================
local addonName = ...

_G.PugLog = _G.PugLog or {}
local PL = _G.PugLog

PL.name = addonName
PL.version = "0.1.0"

PL.Kompat = PL.Kompat or {}
local K = PL.Kompat

K.Zeit = GetTime
K.Datum = time

-- ---------------------------------------------------------------------------
-- Wen haben wir vor uns?
-- ---------------------------------------------------------------------------
-- Der Schluessel eines Mitspielers ist Name-Realm, NICHT die GUID: Die GUID
-- ist zwar eindeutig, steht aber nicht mehr zur Verfuegung, sobald der
-- Spieler die Gruppe verlassen hat - und genau danach will man nachschlagen.
-- Der Realm gehoert dazu, weil Gruppen realmuebergreifend gebildet werden.
function K.SpielerSchluessel(einheit)
    local name, realm = UnitName(einheit)
    if not name then return nil end
    if not realm or realm == "" then
        realm = GetRealmName and GetRealmName() or ""
    end
    realm = (realm or ""):gsub("%s+", "")
    if realm == "" then return name end
    return name .. "-" .. realm
end

-- Alle Mitspieler ausser einem selbst. Gibt nil zurueck, wenn man allein ist.
function K.Gruppe()
    if not IsInGroup or not IsInGroup() then return nil end

    local anzahl = GetNumGroupMembers and GetNumGroupMembers() or 0
    if anzahl < 2 then return nil end

    local praefix = (IsInRaid and IsInRaid()) and "raid" or "party"
    local bis = (praefix == "raid") and anzahl or (anzahl - 1)

    local ergebnis = {}
    for i = 1, bis do
        local einheit = praefix .. i
        if not UnitIsUnit(einheit, "player") then
            local schluessel = K.SpielerSchluessel(einheit)
            if schluessel then
                local _, klasse = UnitClass(einheit)
                ergebnis[#ergebnis + 1] = {
                    schluessel = schluessel,
                    klasse = klasse,
                    rolle = UnitGroupRolesAssigned and UnitGroupRolesAssigned(einheit) or nil,
                }
            end
        end
    end

    if #ergebnis == 0 then return nil end
    return ergebnis
end

-- ---------------------------------------------------------------------------
-- Wo sind wir?
-- ---------------------------------------------------------------------------
function K.Instanz()
    if not GetInstanceInfo then return nil end
    local name, art, schwierigkeitID, schwierigkeit = GetInstanceInfo()
    if not name or art == "none" then return nil end
    return { name = name, art = art, schwierigkeitID = schwierigkeitID,
             schwierigkeit = schwierigkeit }
end

-- Laeuft gerade ein Schluesselstein, und wie hoch?
function K.Schluesselstein()
    if not (C_ChallengeMode and C_ChallengeMode.GetActiveKeystoneInfo) then return nil end
    local ok, stufe = pcall(C_ChallengeMode.GetActiveKeystoneInfo)
    if not ok or not stufe or stufe == 0 then return nil end
    return stufe
end

-- ---------------------------------------------------------------------------
-- Ereignisse
-- ---------------------------------------------------------------------------
local rahmen = CreateFrame("Frame")
local horcher = {}

rahmen:SetScript("OnEvent", function(_, ereignis, ...)
    local liste = horcher[ereignis]
    if not liste then return end
    for _, fn in ipairs(liste) do
        local ok, fehler = pcall(fn, ereignis, ...)
        if not ok then PL.letzterFehler = tostring(fehler) end
    end
end)

function K.Horchen(ereignis, fn)
    if not horcher[ereignis] then
        horcher[ereignis] = {}
        rahmen:RegisterEvent(ereignis)
    end
    local liste = horcher[ereignis]
    liste[#liste + 1] = fn
end

function K.Spaeter(sekunden, fn)
    if C_Timer and C_Timer.After then
        C_Timer.After(sekunden, fn)
    else
        fn()
    end
end
