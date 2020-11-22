local addonName, addon = ...
local L = _G.LibStub("AceLocale-3.0"):NewLocale("BetterWardrobe", "deDE", false, true)
-- German translation by Dathwada EU-Eredar
if not L then return end

local LE_DEFAULT = 1
local LE_APPEARANCE = 2
local LE_ALPHABETIC = 3
local LE_ITEM_SOURCE = 6
local LE_EXPANSION = 5
local LE_COLOR = 4
local TAB_ITEMS = 1
local TAB_SETS = 2
local TAB_EXTRASETS = 3

L[LE_DEFAULT] = DEFAULT
L[LE_APPEARANCE] = APPEARANCE_LABEL
L[LE_ALPHABETIC] = COMPACT_UNIT_FRAME_PROFILE_SORTBY_ALPHABETICAL
L[LE_ITEM_SOURCE] = SOURCE:gsub("[:：]", "")
L[LE_COLOR] = COLOR
L[LE_EXPANSION] = "Erweiterung"

L.OM_GOLD = "|c00FFD200"
L.ENDCOLOR = "|r"

--_G["BINDING_NAME_" .. name
_G["BINDING_HEADER_BETTERWARDROBE"] = addonName
_G["BINDING_NAME_BETTERWARDROBE_BINDING_PLAYERMODEL"] = "Spielermodell verwenden"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TARGETMODEL"] = "Zielmodell verwenden"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TARGETGEAR"] = "Rüstung vom Ziel verwenden"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TOGGLE_DRESSINGROOM"] = "Anprobe umschalten"

L["CLOTH"] = "Stoff"
L["LEATHER"] = "Leder"
L["MAIL"] = "Kette"
L["PLATE"] = "Platte"

--------------------------------------------------------------------------
------------------------------ OPTIONS MENU ------------------------------
--------------------------------------------------------------------------

--############################-- TABS --#############################--

L["Options"] = "Optionen"
L["Settings"] = "Einstellungen"
L["Options Profiles"] = "Options Profile"

L["List Profiles"] = "Listenprofile"
L["Favorite Items & Sets"] = "Favorisierte Gegenstände und Sets"
L["Hidden Items & Sets"] = "Ausgeblendete Gegenstände und Sets"

L["Item Substitution"] = "Gegenstand ersetzen"
L["Items"] = "Gegenstände"
L["Profiles"] = "Profile"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GENERAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["General Options"] = "Allgemein"
L["Ignore Class Restriction Filter"] = "Klassenfilter ignorieren"
L["Only for Raid Lookalike/Recolor Sets"] = "Nur für Raid Lookalike/Recolor Sets"
L["Print Set Collection alerts to chat:"] = "Sammelnachricht im Chat für:"
L["Sets"] = true
L["Extra Sets"] = true
L["Collection List"] = "Sammelliste"
L["TSM Source to Use"] = "Zu verwendende TSM-Quelle"
L["Profiles for sharing the various lists across characters"] = "Profile zum Teilen der verschiedenen Listen zwischen Charakteren."

--~~~~~~~~~~~~~~~~~~~~~~~ TRANSMOG VENODR WINDOW ~~~~~~~~~~~~~~~~~~~~~~~--

L["Transmog Vendor Window"] = "Transmogrifiziererfenster"
L["Larger Transmog Area"] = "Großes Fenster"
L["LargeTransmogArea_Tooltip"] = "Vergrößert das Fenster des Transmogrifizierers"
L["Extra Large Transmog Area"] = "Extra großes Fenster"
L["ExtraLargeTransmogArea_Tooltip"] = "Vergrößert das Fenster des Transmogrifizierers enorm, sodass das Fenster auf Bildschirmgröße ist."
L["Show Incomplete Sets"] = "Unvollständige Sets anzeigen"
L["Show Items set to Hidden"] = "Ausgeblendete Vorlagen anzeigen"
L["Hide Missing Set Pieces at Transmog Vendor"] = "Verstecke fehlende Setteile beim Transmogrifizierer"
L["Use Hidden Transmog for Missing Set Pieces"] = "Verwende \"versteckte\" Transmogvorlagen, für fehlende Setteile."
L["Required pieces"] = "Zeige nur Sets mit X Gegenständen:"
L["Show Set Names"] = "Setnamen anzeigen"
L["Show Collected Count"] = "Gesammelte Anzahl anzeigen"

L["Select Slot to Hide"] = "Slot zum verstecken auswählen"
L["Requires 'Show Incomplete Sets' Enabled"] = "'Unvollständige Sets anzeigen' muss aktiviert sein"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOOLTIP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Tooltip Options"] = "Tooltip"
L["Show Set Info in Tooltips"] = "Setinfo in Tooltips anzeigen"
L["Show Set Collection Details"] = "Details zum Set anzeigen"
L["Only List Missing Pieces"] = "Nur fehlende Teile auflisten"
L["Show Item ID"] = "Zeige Gegenstands ID"
L["Show if appearance is known"] = "Bereits bekannte Vorlagen anzeigen"
L["Show if additional sources are available"] = "Zusätzliche Quellen anzeigen, wenn verfügbar"
L["Show Token Information"] = "Zeige Tokeninfos"

L["Class can't use item for transmog"] = "Diese Klasse kann den Gegenstand nicht transmogrifizieren."
L["Show unable to uses as transmog warning"] = "Warnung für nicht benutzbare Transmogvorlagen anzeigen"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ITEM PREVIEW ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Item Preview Options"] = "Gegenstandsvorschau"
L["Appearance Preview"] = "Vorlagenvorschau"
L["Only show if modifier is pressed"] = "Nur anzeigen, wenn die Taste gedrückt ist"
L["None"] = "keiner"
L["Only transmogrification items"] = "Nur Transmogrifikationsgegenstände"
L["Try to preview armor tokens"] = "Versuche eine Vorschau für Rüstungtoken anzuzeigen"
L["Prevent Comparison Overlap"] = "Verhindere eine Überlappung mit Gegenstandsvergleichen"
L["TooltipPreview_Overlap_Tooltip"] = "Wenn der Vergleichstooltip dort angezeigt wird, wo die Vorschau sein soll, zeigen diese daneben an."
L["Zoom:"] = true
L["On Weapons"] = "bei Waffen"
L["On Clothes"] = "bei Rüstung"
L["Dress Preview Model"] = "Vorschaumodell bekleiden"
L["TooltipPreview_Dress_Tooltip"] = "Zeige in der Vorschau auch mein momentanes Rüstungsaussehen an."
L["Use Dressing Dummy Model"] = "Verwende das Spieler Dummymodell"
L["TooltipPreview_DressingDummy"] = "Blende Details des Spielermodells aus, während des zoom (wie es die Transmog-Garderobe tut)."
L["Auto Rotate"] = "Automatische Rotation"
L["TooltipPreviewRotate_Tooltip"] = "Rotiert die Vorschau dauerhaft, wenn diese angezeigt wird."
L["Rotate with mouse wheel"] = "Mit dem Mausrad drehen"
L["TooltipPreview_MouseRotate_Tooltip"] = "Verwende das Mausrad um die Vorschau zu drehen."
L["Anchor point"] = "Ankerpunkt"
L["Top/bottom"] = "oben/unten"
L["Left/right"] = "links/rechts"
L["TooltipPreview_Anchor_Tooltip"] = "Seite des Tooltips zum Anhängen der Vorschau, abhängig davon wo es auf dem Bildschirm angezeigt wird."
L["Width"] = "Breite"
L["Height"] = "Höhe"
L["Reset"] = "Zurücksetzen"
L["Use custom model"] = "Benutzerdefiniertes Charaktermodell"
L["CUSTOM_MODEL_WARNING"] = "*Benutzerdefinierte Modelle sind auf das Anprobemodell eingestellt und werden möglicherweise nicht richtig angezeigt."
L["Model race"] = "Rasse"
L["Model gender"] = "Geschlecht"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DRESSING ROOM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Dressing Room Options"] = "Anprobe"
L["Enable"] = "Aktivieren"
L["Show Item Buttons"] = "Zeige Gegenstandslots"
L["Show DressingRoom Controls"] = "Zeige Anprobesteuerungen"
L["Dim Backround Image"] = "Hintergrundbild verdunkeln"
L["Hide Backround Image"] = "Hintergrundbild verstecken"
L["Start Undressed"] = "Starte unbekleidet"
L["Hide Weapons"] = "Waffen verstecken"
L["Hide Shirt"] = "Hemd verstecken"
L["Hide Tabard"] = "Wappenrock verstecken"
L["Resize Window"] = "Fenstergröße ändern"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ITEM SUBSTITUTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Items"] = "Gegenstände"
L["Base Item ID"] = "Basis Gegenstands ID"
L["Not a valid itemID"] = "Keine gültige Gegenstands ID"
L["Replacement Item ID"] = "Ersatz Gegenstands ID"
L["Remove"] = "Entfernen"
L["Add"] = "Hinzufügen"
L["Item Locations Don't Match"] = "Gegenstandsvorlagen passen nicht zusammen"
L["Saved Item Substitutes"] = "Gespeicherte Gegenstandsersetzungen"

L["item: %d - %s \n==>\nitem: %d - %s"] = "Gegenstand: %d - %s \n==>\nGegenstand: %d - %s"

--------------------------------------------------------------------------
-------------------------- ARTIFACT APPEARANCES --------------------------
--------------------------------------------------------------------------

L["Base Appearance"] = "Basisvorlage"
L["Class Hall Appearance"] = "Ordenshallenvorlage"
L["Mythic Dungeon Quests Appearance"] = "Mythische Dungeonquest Vorlage"
L["PvP Appearance"] = "PvP Vorlage"
L["Hidden Appearance"] = "Versteckte Vorlage"
L["Mage Tower Appearance"] = "Magierturm Vorlage"
L["Learned from Item"] = "Erlernt von Gegenstand"

--------------------------------------------------------------------------
----------------------------- DROPDOWN MENUS -----------------------------
--------------------------------------------------------------------------

L["Visual View"] = "Visuelle Ansicht"

L["Default"] = "Standard"
L["Expansion"] = "Erweiterung"
L["Missing:"] = "Fehlend"
L["Armor Type"] = "Rüstungstyp"

L["Class Sets Only"] = "Nur Klassensets"
L["Hide Unavailable Sets"] = "Blende" --
L["MISC"] = "Sonstiges"
L["Classic Set"] = true
L["Quest Set"] = true
L["Dungeon Set"] = true
L["Raid Recolor"] = true
L["Raid Lookalike"] = true
L["PvP"] = true
L["Garrison"] = "Garnision"
L["Island Expedition"] = "Inselexpedition"
L["Warfronts"] = "Kriegsfront"

--------------------------------------------------------------------------
---------------------------- COLLECTION LIST -----------------------------
--------------------------------------------------------------------------

L["Appearance added."] = "Vorlage der Sammelliste hinzugefügt."
L["Appearance removed."] = "Vorlage von der Sammelliste entfernt."

L["%s: Uncollected items added"] = "%s: Nicht gesammelte Gegenstände hinzugefügt"
L["No new appearces needed."] = "Keine neuen Vorlagen erforderlich."

L["COLLECTION_LIST_HELP"] = [[
Füge dieser Liste Gegenstände hinzu, indem du
auf einen Gegenstand oder ein Set mit Rechtsklick
die Option 'Zur Sammelliste hinzufügen' auswählst.
]]

L["View All"] = "Zeige alles"
L["Add List"] = "Liste hinzufügen"
L["Rename"] = "Umbenennen"
L["Delete"] = "Löschen"
L["Add by Item ID"] = "Mit Gegenstands ID hinzufügen"

L["Export TSM Groups"] = "Exportiere TSM Gruppen"
L["%sgroup:Appearance Group %s,"] = true
L["Collected"] = "Gesammelt"

L["Type the item ID in the text box below"] = "Trage die Gegenstands ID in das untere Textfeld ein"

L["List Name"] = "Listenname"

L["Click: Show Collection List"] = "Klick: Zeige die Sammelliste"
L["Shift Click: Show Detail List"] = "Shift + Klick: Zeige die Detailierte Liste"

--------------------------------------------------------------------------
----------------------------- DRESSING ROOM ------------------------------
--------------------------------------------------------------------------

L["Display Options"] = "Anzeigeoptionen"
L["Character Options"] = "Charakteroptionen"

L["Import/Export Options"] = "Import/Export Optionen"
L["Load Set: %s"] = "Lade Set: %s"
L["None Selected"] = "Keins ausgewählt"

L["Import Item"] = "Gegenstand importieren"
L["Import Set"] = "Set importieren"
L["Export Set"] = "Set exportieren"
L["Create Dressing Room Command Link"] = "Anprobenlink erstellen"

L["Target Options"] = "Ziel Optionen"
L["Use Player Model"] = "Spielermodell verwenden"
L["Use Target Model"] = "Zielmodell verwenden"
L["Use Target Gear"] = "Rüstung vom Ziel verwenden"
L["Undress"] = "Ausziehen"
L["Hide Armor Slots"] = "Rüstungsslots verstecken"

--------------------------------------------------------------------------
----------------------------- IMPORT EXPORT ------------------------------
--------------------------------------------------------------------------

L["Copy and paste a Wowhead Compare URL into the text box below to import"] = "Füge hier eine Wowhead Compare URL zum importieren ein"
L["Import"] = "Importieren"
L["Type the item ID or url in the text box below"] = "Trage die Gegenstands ID oder URL in das Textfeld unten ein"
L["Export"] = "Exportieren"

--------------------------------------------------------------------------
------------------------------- RANDOMIZER -------------------------------
--------------------------------------------------------------------------

L["Click: Randomize Items"] = "Klick: Gegenstände zufällig auswählen"
L["Shift Click: Randomize Outfit"] = "Shift + Klick: Outfit zufällig auswählen"

--------------------------------------------------------------------------
-------------------------------- TOOLTIPS --------------------------------
--------------------------------------------------------------------------

L["HEADERTEXT"] = '|cffffd100--------================--------'
L["Item ID"] = "Gegenstands ID"

L["-Appearance in %d Collection List-"] = "-Vorlage in %d Sammelliste-"
L["Part of Set:"] = "Teil eines Sets:"
L["Part of Extra Set:"] = "Teil eines Extra Sets:"

L["-%s %s(%d/%d)"] = true
L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"] = true
L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"] = true

--------------------------------------------------------------------------
----------------------------------- UI -----------------------------------
--------------------------------------------------------------------------

L["unhiding_item"] = "Blende"
L["unhiding_item_end"] = "in der Vorlagensammlung wieder ein."
L["hiding_item"] = "Verstecke"
L["hiding_item_end"] = "in der Vorlagensammlung."

L["unhiding_set"] = "Blende das Set"
L["unhiding_set_end"] = "wieder ein."
L["hiding_set"] = "Verstecke das Set"
L["hiding_set_end"] = "."

L["Queue Transmog"] = "Transmog in Warteschlange einreihen"

L["Add to Collection List"] = "Zur Sammelliste hinzufügen"
L["Remove from Collection List"] = "Von der Sammelliste entfernen"

L["Toggle Hidden View"] = "Verstecken umschalten"

--------------------------------------------------------------------------
----------------------------- BETTERWARDROBE -----------------------------
--------------------------------------------------------------------------

L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"] = "Fehlende Vorlage hinzugefügt: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"
L["Added appearance in Collection List"] = "Vorlage in Sammelliste hinzugefügt"

L["Set Substitution"] = "Ersatz festlegen"
L["Substitue Item"] = "Gegenstand ersetzen"

L["Item No Longer Available"] = "Gegenstand nicht länger verfügbar"

--------------------------------------------------------------------------
-------------------------------- DATABASE --------------------------------
--------------------------------------------------------------------------

L["Saved Set"] = "Set gespeichert"
