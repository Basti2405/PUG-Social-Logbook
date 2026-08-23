-- Locales/enUS.lua - the base language
_G.PugLog = _G.PugLog or {}
local PL = _G.PugLog

PL.L = PL.L or {}
local L = PL.L

L["ADDON_NAME"]        = "Pug Log"
L["SLASH_HINT"]        = "/pug opens the book. /pug note <name> <text>, /pug tag <name> <tag>, /pug rate <name> 1-5, /pug doctor."

L["WINDOW_TITLE"]      = "Pug Log"
L["NO_DATA"]           = "Nothing recorded yet. Finish a dungeon or raid with other people and they will show up here."
L["ENTRIES_KNOWN"]     = "People recorded: %d"
L["AND_MORE"]          = "... and %d more."

L["RECORDED"]          = "Recorded %d group members from %s."
L["NOTE_SET"]          = "Note saved for %s."
L["NOTE_CLEARED"]      = "Note removed for %s."
L["TAG_ON"]            = "Tag '%s' set for %s."
L["TAG_OFF"]           = "Tag '%s' removed for %s."
L["RATED"]             = "%s rated %d of 5."
L["RATE_CLEARED"]      = "Rating removed for %s."
L["UNKNOWN_PLAYER"]    = "No entry for '%s' yet."
L["NEED_NAME"]         = "A name is required."

L["DOCTOR_TITLE"]      = "Pug Log - self-check"
L["DOCTOR_STORAGE_OK"] = "Storage: ready (%d people)."
L["DOCTOR_STORAGE_NO"] = "Storage: NOT ready - saved variables did not load."
L["DOCTOR_GROUP"]      = "Group: %d other members right now."
L["DOCTOR_ALONE"]      = "Group: alone at the moment."
L["DOCTOR_NO_MODULES"] = "Modules: none installed."
L["DOCTOR_MODULE_ON"]  = "Module %s: active."
L["DOCTOR_MODULE_OFF"] = "Module %s: inactive (%s)."
L["DOCTOR_NO_REASON"]  = "no reason given"
