-- Logik/Speicher.lua - der Katalog, der alle Charaktere ueberdauert
--
-- ===========================================================================
-- WARUM ACCOUNT-WEIT
-- ---------------------------------------------------------------------------
-- Wer einem auf dem Magier unangenehm aufgefallen ist, soll auch auffallen,
-- wenn man mit dem Priester unterwegs ist. Ein Speicher je Charakter koennte
-- das nicht. Deshalb steht in der .toc
-- SavedVariables (account-weit) und nicht SavedVariablesPerCharacter.
--
-- Was daraus folgt: Jeder Charakter schreibt nur seinen EIGENEN Abschnitt,
-- liest aber alle. Ein Charakter, der laenger nicht eingeloggt war, hat
-- veraltete Angaben - deshalb steht an jedem Abschnitt, WANN er zuletzt
-- geschrieben wurde. Die Oberflaeche zeigt das an, statt einen alten Stand
-- als Tatsache auszugeben.
--
-- WAS HIER NICHT PASSIERT
-- ---------------------------------------------------------------------------
-- Hier wird nichts erhoben und nichts gerechnet - nur abgelegt und
-- herausgegeben. Das Erheben macht die jeweilige Logik-Datei, das Rechnen
-- die Auswertung.
-- ===========================================================================
local PL = _G.PugLog
local K = PL.Kompat

PL.Speicher = PL.Speicher or {}
local S = PL.Speicher

-- Aufbau der gespeicherten Tabelle. Wird bei jedem Start gegen die
-- vorhandene Datei gelegt, damit eine aeltere Fassung fehlende Felder
-- nachgereicht bekommt statt auf einen nil-Zugriff zu laufen.
local VORLAGE = {
    version = 1,
    spieler = {},      -- [schluessel] = { begegnungen, merkmale, notiz, bewertung }
    module = {},       -- jedes Modul bekommt hier seine eigene Schublade
    einstellungen = {
        fensterPunkt = nil,
        minimap = { hide = false },
    },
}

-- Fehlende Felder ergaenzen, vorhandene in Ruhe lassen.
local function auffuellen(ziel, vorlage)
    for schluessel, wert in pairs(vorlage) do
        if type(wert) == "table" then
            if type(ziel[schluessel]) ~= "table" then ziel[schluessel] = {} end
            auffuellen(ziel[schluessel], wert)
        elseif ziel[schluessel] == nil then
            ziel[schluessel] = wert
        end
    end
end

function S.Start()
    if type(_G.PugLogDB) ~= "table" then _G.PugLogDB = {} end
    auffuellen(_G.PugLogDB, VORLAGE)
    S.db = _G.PugLogDB
    return S.db
end

-- ---------------------------------------------------------------------------
-- Der eigene Abschnitt
-- ---------------------------------------------------------------------------
function S.EigenerAbschnitt()
    if not S.db then return nil end
    local schluessel = K.CharakterSchluessel()
    if not schluessel then return nil end

    local eintrag = S.db.spieler[schluessel]
    if not eintrag then
        eintrag = { schluessel = schluessel }
        S.db.spieler[schluessel] = eintrag
    end
    return eintrag
end

-- Nach jedem Schreiben aufrufen. Ohne Zeitstempel weiss die Oberflaeche
-- nicht, wie alt die Angabe ist - und ein alter Stand, der wie ein aktueller
-- aussieht, ist schlimmer als eine Luecke.
function S.Stempeln(eintrag)
    if eintrag then eintrag.aktualisiert = K.Datum() end
end

-- ---------------------------------------------------------------------------
-- Schublade fuer ein Modul
-- ---------------------------------------------------------------------------
-- Module legen NICHT ihre eigene SavedVariables-Datei an. Sonst haette der
-- Spieler zwei Dateien, die getrennt gesichert und getrennt beschaedigt
-- werden koennen - und ein deaktiviertes Modul liesse seine Daten verwaisen.
function S.ModulSchublade(name)
    if not S.db then return nil end
    S.db.module[name] = S.db.module[name] or {}
    return S.db.module[name]
end

-- ---------------------------------------------------------------------------
-- Lesen ueber alle Charaktere
-- ---------------------------------------------------------------------------
function S.AlleSpieler()
    if not S.db then return {} end
    return S.db.spieler
end
