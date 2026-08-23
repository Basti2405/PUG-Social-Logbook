-- Locales/deDE.lua - Deutsch
if GetLocale() ~= "deDE" then return end

local PL = _G.PugLog
local L = PL.L

L["SLASH_HINT"]        = "/pug oeffnet das Buch. /pug note <Name> <Text>, /pug tag <Name> <Merkmal>, /pug rate <Name> 1-5, /pug doctor."

L["NO_DATA"]           = "Noch nichts erfasst. Schliesse einen Lauf mit anderen ab, dann stehen sie hier."
L["ENTRIES_KNOWN"]     = "Erfasste Leute: %d"
L["AND_MORE"]          = "... und %d weitere."

L["RECORDED"]          = "%d Mitspieler aus %s erfasst."
L["NOTE_SET"]          = "Notiz zu %s gespeichert."
L["NOTE_CLEARED"]      = "Notiz zu %s entfernt."
L["TAG_ON"]            = "Merkmal '%s' fuer %s gesetzt."
L["TAG_OFF"]           = "Merkmal '%s' fuer %s entfernt."
L["RATED"]             = "%s mit %d von 5 bewertet."
L["RATE_CLEARED"]      = "Bewertung von %s entfernt."
L["UNKNOWN_PLAYER"]    = "Zu '%s' gibt es noch keinen Eintrag."
L["NEED_NAME"]         = "Es fehlt der Name."

L["DOCTOR_TITLE"]      = "Pug Log - Selbstdiagnose"
L["DOCTOR_STORAGE_OK"] = "Speicher: bereit (%d Leute)."
L["DOCTOR_STORAGE_NO"] = "Speicher: NICHT bereit - die gespeicherten Variablen wurden nicht geladen."
L["DOCTOR_GROUP"]      = "Gruppe: gerade %d andere Mitglieder."
L["DOCTOR_ALONE"]      = "Gruppe: im Augenblick allein."
L["DOCTOR_NO_MODULES"] = "Module: keines installiert."
L["DOCTOR_MODULE_ON"]  = "Modul %s: aktiv."
L["DOCTOR_MODULE_OFF"] = "Modul %s: nicht aktiv (%s)."
L["DOCTOR_NO_REASON"]  = "ohne Angabe"
