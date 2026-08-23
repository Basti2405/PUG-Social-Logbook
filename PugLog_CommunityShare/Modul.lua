-- Modul.lua - Empfehlungen in einer festen Gruppe teilen
--
-- ===========================================================================
-- STAND: Geruest. Siehe Planung/02-Module.md - und dort besonders den
-- Abschnitt darueber, was dieses Modul ABSICHTLICH nicht tut.
--
-- DIE REGELN, DIE HIER NICHT VERHANDELBAR SIND
-- ---------------------------------------------------------------------------
-- 1. Nichts geht automatisch heraus. Der Spieler stoesst das Teilen an,
--    jedes Mal.
-- 2. Freitext-Notizen werden NIE geteilt. Eine Notiz ist fuer einen selbst
--    geschrieben, in einer Sprache, die nur fuer einen selbst gemeint war.
--    Geteilt werden hoechstens Merkmale und eine Bewertung.
-- 3. Geteilt wird nur mit einer FESTEN Gruppe, die der Spieler benennt -
--    nicht mit der Gilde, nicht mit einem offenen Kanal, nicht mit allen.
-- 4. Ein Addon-Kanal ist mitlesbar. Wer das umgeht, indem er "verschluesselt",
--    verschiebt das Problem nur: Der Schluessel muesste dann bei allen
--    liegen, die mitlesen duerfen sollen - und damit auch bei dem, der es
--    weitergibt.
--
-- Diese Punkte stehen hier und nicht nur in der Planung, weil sie beim
-- Programmieren vergessen werden koennen, wenn sie nur woanders stehen.
-- ===========================================================================
local PL = _G.PugLog
if not PL or not PL.Module then return end

local Modul = PL.Module.Registrieren("CommunityShare", {})

function Modul:Pruefen()
    if not (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) then
        return false, "C_ChatInfo steht in diesem Client nicht zur Verfuegung"
    end
    return true
end

function Modul:Start()
    self.daten = PL.Speicher.ModulSchublade("communityshare")
    -- Ohne benannte Gruppe passiert nichts. Das ist der Grundzustand und
    -- bleibt es, bis der Spieler etwas eintraegt.
    self.daten.gruppe = self.daten.gruppe or nil
end

function Modul:Kennzahl()
    if not (self.daten and self.daten.gruppe) then
        return PL.L["CS_OFF"]
    end
    return PL.L["CS_ON"]:format(self.daten.gruppe)
end
