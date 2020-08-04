local addonName, addon = ...
local L = _G.LibStub("AceLocale-3.0"):NewLocale("BetterWardrobe", "zhTW", false, true)
-- Traditional Chinese translation by 三皈依 TW-暗影之月
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
L[LE_EXPANSION] = "資料片"

L.OM_GOLD = "|c00FFD200"
L.ENDCOLOR = "|r"

--_G["BINDING_NAME_" .. name
_G["BINDING_HEADER_BETTERWARDROBE"] = addonName
_G["BINDING_NAME_BETTERWARDROBE_BINDING_PLAYERMODEL"] = "使用玩家模型" 
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TARGETMODEL"] = "使用目標的模型"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TARGETGEAR"] =  "使用目標裝備"
_G["BINDING_NAME_BETTERWARDROBE_BINDING_TOGGLE_DRESSINGROOM"] = "切換試衣間"

L["CLOTH"] = "布甲"
L["LEATHER"] = "皮甲"
L["MAIL"] = "鎖甲"
L["PLATE"] = "鎧甲"

--------------------------------------------------------------------------
------------------------------ OPTIONS MENU ------------------------------
--------------------------------------------------------------------------

--############################-- TABS --#############################--

L["Options"] = "選項"
L["Settings"] = "設置"
L["Options Profiles"] = "選項設定檔"

L["List Profiles"] = "清單設定檔"
L["Favorite Items & Sets"] = "最愛物品與套裝"
L["Collection List"] = "收藏列表"
L["Hidden Items & Sets"] = "隱藏物品與套裝"

L["Item Substitution"] = "物品替代"
L["Items"] = "物品"
L["Profiles"] = "設定檔"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GENERAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["General Options"] = "一般選項"
L["Ignore Class Restriction Filter"] = "忽略職業限定過濾器"
L["Only for Raid Lookalike/Recolor Sets"] = "僅適用於團隊同模型/異色版套裝"
L["Print Set Collection alerts to chat:"] = "發出套裝收藏警告到聊天中:"
L["Sets"] = "套裝"
L["Extra Sets"] = "額外套裝"
L["Collection List"] = "收藏列表"
L["TSM Source to Use"] = "使用TSM來源"
L["Profiles for sharing the various lists across characters"] = "用於跨角色共享各種清單的設定檔"

--~~~~~~~~~~~~~~~~~~~~~~~ TRANSMOG VENODR WINDOW ~~~~~~~~~~~~~~~~~~~~~~~--

L["Transmog Vendor Window"] = "塑型商店視窗"
L["Larger Transmog Area"] = "大型塑形區域"
L["Extra Large Transmog Area"] = "額外加大塑形區域"
L["LargeTransmogArea_Tooltip"] = "加大塑形商店視窗"
L["ExtraLargeTransmogArea_Tooltip"] = "加大塑形商店視窗以填充螢幕寬度"
L["Show Incomplete Sets"] = "顯示未完成套裝"
L["Show Items set to Hidden"] = "顯示物品套裝為隱藏"
L["Hide Missing Set Pieces at Transmog Vendor"] = "在塑形商店隱藏缺少套裝的部位"
L["Use Hidden Transmog for Missing Set Pieces"] = "在缺少套裝部位使用隱藏塑形"
L["Required pieces"] = "需求件數"
L["Show Set Names"] = "顯示套裝名稱"
L["Show Collected Count"] = "顯示已收藏件數"

L["Select Slot to Hide"] = "選擇隱藏的部位"
L["Requires 'Show Incomplete Sets' Enabled"] = "需要啟用'顯示未完成套裝'"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOOLTIP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Tooltip Options"] = "工具提示選項"
L["Show Set Info in Tooltips"] = "在提示中顯示套裝訊息"
L["Show Set Collection Details"] = "顯示套裝收藏詳細資訊"
L["Only List Missing Pieces"] = "只列出缺少部位"
L["Show Item ID"] = "顯示物品ID"
L["Show if appearance is known"] = "顯示如果外觀已收集"
L["Show if additional sources are available"] = "顯示如果額外來源可用"
L["Show Token Information"] = "顯示兌換物訊息"

L["Class can't use item for transmog"] = "職業無法使用此物品來塑形"
L["Show unable to uses as transmog warning"] = "顯示無法使用塑形警告"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ITEM PREVIEW ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Item Preview Options"] = "物品預覽選項"
L["Appearance Preview"] = "外觀預覽"
L["Only show if modifier is pressed"] = "只在快捷鍵按下時顯示"
L["None"] = "無"
L["Only transmogrification items"] = "只限可塑形物品"
L["Try to preview armor tokens"] = "嘗試預覽護甲兌換物"
L["Prevent Comparison Overlap"] = "防止物品比較重疊"
L["TooltipPreview_Overlap_Tooltip"] = "如果比較工具提示顯示在預覽的位置，那麼在旁邊顯示"
L["Zoom:"] = "縮放:"
L["On Weapons"] = "在武器"
L["On Clothes"] = "在衣服"
L["Dress Preview Model"] = "試衣預覽模型"
L["TooltipPreview_Dress_Tooltip"] = "除預覽物品外，顯示模特穿著您當前的服裝"
L["Use Dressing Dummy Model"] = "使用試衣假人模型"
L["TooltipPreview_DressingDummy"] = "縮放時隱藏玩家模型的詳細訊息（就像塑形衣櫃一樣）"
L["Auto Rotate"] = "自動旋轉"
L["TooltipPreviewRotate_Tooltip"] = "顯示模型時不斷旋轉"
L["Rotate with mouse wheel"] = "使用滑鼠滾輪旋轉"
L["TooltipPreview_MouseRotate_Tooltip"] = "使用滑鼠滾輪在工具提示中旋轉模型"
L["Anchor point"] = "定位點"
L["Top/bottom"] = "上/下"
L["Left/right"] = "左/右"
L["TooltipPreview_Anchor_Tooltip"] = "要附加到工具提示的某一面，具體取決於它在螢幕上顯示的位置"
L["Height"] = "高度"
L["Width"] = "寬度"
L["Reset"] = "重置"
L["Use custom model"] = "使用自訂模型"
L["CUSTOM_MODEL_WARNING"] = "*自定義模型設置為塑形試衣模型，可能無法正確顯示"
L["Model race"] = "模型種族"
L["Model gender"] = "模型性別"
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DRESSING ROOM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Dressing Room Options"] = "試衣間選項"
L["Enable"] = "啟用"
L["Show Item Buttons"] = "顯示物品按鈕"
L["Show DressingRoom Controls"] = "顯示試衣間控制"
L["Dim Backround Image"] = "黯淡背景圖像"
L["Hide Backround Image"] = "隱藏背景圖像"
L["Start Undressed"] = "開始時脫裝"
L["Hide Weapons"] = "隱藏武器"
L["Hide Shirt"] = "隱藏襯衣"
L["Hide Tabard"] = "隱藏外袍"
L["Resize Window"] = "調整視窗大小"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ITEM SUBSTITUTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

L["Items"] = "物品"
L["Base Item ID"] = "基礎物品ID"
L["Not a valid itemID"] = "非有效物品ID"
L["Replacement Item ID"] = "替換物品ID"
L["Remove"] = "移除"
L["Add"] = "新增"
L["Item Locations Don't Match"] = "物品位置不符"
L["Saved Item Substitutes"] = "保存的物品替代品"

L["item: %d - %s \n==>\nitem: %d - %s"] = "物品: %d - %s \n==>\n物品: %d - %s"

--------------------------------------------------------------------------
-------------------------- ARTIFACT APPEARANCES --------------------------
--------------------------------------------------------------------------

L["Base Appearance"] = "基礎外觀"
L["Class Hall Appearance"] = "職業大廳外觀"
L["Mythic Dungeon Quests Appearance"] = "傳奇地下城任務外觀"
L["PvP Appearance"] = "PvP外觀"
L["Hidden Appearance"] = "隱藏外觀"
L["Mage Tower Appearance"] = "法師塔挑戰外觀"
L["Learned from Item"] = "從物品收藏"

--------------------------------------------------------------------------
----------------------------- DROPDOWN MENUS -----------------------------
--------------------------------------------------------------------------

L["Visual View"] = "外觀可視化"

L["Default"] = "預設"
L["Expansion"] = "資料片"
L["Missing:"] = "缺少:"
L["Armor Type"] = "護甲類型"

L["Class Sets Only"] = "僅限職業套裝"
L["Hide Unavailable Sets"] = "隱藏不可用套裝"
L["MISC"] = "雜項"
L["Classic Set"] = "經典套裝"
L["Quest Set"] = "任務套裝"
L["Dungeon Set"] = "地下城套裝"
L["Raid Recolor"] = "團隊異色版"
L["Raid Lookalike"] = "團隊同模型"
L["PvP"] = "PvP"
L["Garrison"] = "要塞"
L["Island Expedition"] = "海嶼遠征"
L["Warfronts"] = "戰爭前線"

--------------------------------------------------------------------------
---------------------------- COLLECTION LIST -----------------------------
--------------------------------------------------------------------------

L["Appearance added."] = "已加入外觀。"
L["Appearance removed."] = "已移除外觀。"

L["%s: Uncollected items added"] = "%s: 已加入未收藏物品"
L["No new appearces needed."] = "無新外觀需要。"

L["COLLECTION_LIST_HELP"] = "通過右鍵單擊某個物品或套裝將物品加入到清單中，\n然後選擇'新增到收藏清單'"

L["View All"] = "觀看全部"
L["Add List"] = "新增清單"
L["Rename"] = "重命名"
L["Delete"] = "刪除"
L["Add by Item ID"] = "按物品ID新增"

L["Export TSM Groups"] = "導出TSM群組"
L["%sgroup:Appearance Group %s,"] = "%sgroup:外觀群組 %s,"
L["Collected"] = "已收藏"

L["Type the item ID in the text box below"] = "在下面的文本框中輸入物品ID"

L["List Name"] = "清單名稱"

L["Click: Show Collection List"] = "點擊: 顯示收藏清單"
L["Shift Click: Show Detail List"] = "Shift-點擊: 顯示詳細清單"

--------------------------------------------------------------------------
----------------------------- DRESSING ROOM ------------------------------
--------------------------------------------------------------------------

L["Display Options"] = "顯示選項"
L["Character Options"] = "角色選項"

L["Import/Export Options"] = "導入/導出選項"
L["Load Set: %s"] = "載入套裝: %s"
L["None Selected"] = "未選擇"

L["Import Item"] = "導入物品"
L["Import Set"] =  "導入套裝"
L["Export Set"] = "導出套裝"
L["Create Dressing Room Command Link"] = "建立試衣間指令連結"

L["Target Options"] = "目標選項"
L["Use Player Model"] = "使用玩家模型"
L["Use Target Model"] = "使用目標模型"
L["Use Target Gear"] = "使用目標裝備"
L["Undress"] = "脫裝"
L["Hide Armor Slots"] = "隱藏護甲部位"

--------------------------------------------------------------------------
----------------------------- IMPORT EXPORT ------------------------------
--------------------------------------------------------------------------

L["Copy and paste a Wowhead Compare URL into the text box below to import"] = "將Wowhead比較網址複製並貼上到下面的文本框中來導入"
L["Import"] = "導入"
L["Type the item ID or url in the text box below"] = "在下面的文本框中輸入物品ID或網址"
L["Export"] = "導出"

--------------------------------------------------------------------------
------------------------------- RANDOMIZER -------------------------------
--------------------------------------------------------------------------

L["Click: Randomize Items"] = "點擊: 隨機物品"
L["Shift Click: Randomize Outfit"] = "Shift-點擊: 隨機套裝"

--------------------------------------------------------------------------
-------------------------------- TOOLTIPS --------------------------------
--------------------------------------------------------------------------

L["HEADERTEXT"] = '|cffffd100--------================--------'
L["Item ID"] = "物品ID"

L["-Appearance in %d Collection List-"] = "-出現在 %d 收藏清單中-"
L["Part of Set:"] = "套裝的部份:"
L["Part of Extra Set:"] = "額外套裝的部份:"

L["-%s %s(%d/%d)"] = true
L["|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t %s%s"] = true
L["|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s%s"] = true

--------------------------------------------------------------------------
----------------------------------- UI -----------------------------------
--------------------------------------------------------------------------

L["unhiding_item"] = "取消隱藏"
L["unhiding_item_end"] = "從外觀標籤頁"
L["hiding_item"] = "隱藏"
L["hiding_item_end"] = "從外觀標籤頁"

L["unhiding_set"] = "取消隱藏套裝"
L["hiding_set"] = "隱藏套裝"

L["Queue Transmog"] = "塑形佇列"

L["Add to Collection List"] = "新增到收藏清單"
L["Remove from Collection List"] = "從收藏清單移除"

L["Toggle Hidden View"] = "切換隱藏是否顯示"

--------------------------------------------------------------------------
----------------------------- BETTERWARDROBE -----------------------------
--------------------------------------------------------------------------

L["Added missing appearances of: \124cffff7fff\124H%s:%s\124h[%s]\124h\124r"] = "新增了缺少的外觀：\124cffff7fff\124H%s:%s\124h[%s]\124h\124r"
L["Added appearance in Collection List"] = "在收藏清單中新增外觀"

L["Set Substitution"] = "設定替代品"
L["Substitue Item"] = "替代品"

L["Item No Longer Available"] = "物品不再可用"

--------------------------------------------------------------------------
-------------------------------- DATABASE --------------------------------
--------------------------------------------------------------------------

L["Saved Set"] = "已儲存套裝"
L["COLLECTIONLIST_TEXT"] = "%s - %s"
L["SHOPPINGLIST_TEXT"] = "%s - %s: %s"


--Autogenerated below this
--PvP Set
L["NOTE_17"] = "競技場賽季1套裝"
L["NOTE_19"] = "競技場賽季2套裝"
L["NOTE_20"] = "競技場賽季3套裝"
L["NOTE_22"] = "競技場賽季4套裝"
L["NOTE_24"] = "競技場賽季5套裝"
L["NOTE_26"] = "競技場賽季6套裝"
L["NOTE_28"] = "競技場賽季7套裝"
L["NOTE_30"] = "競技場賽季8套裝"
L["NOTE_33"] = "競技場賽季9套裝"
L["NOTE_34"] = "競技場賽季10套裝"
L["NOTE_37"] = "競技場賽季11套裝"
L["NOTE_40"] = "競技場賽季12套裝"
L["NOTE_42"] = "競技場賽季13套裝"
L["NOTE_62"] = "競技場賽季14套裝"
L["NOTE_63"] = "競技場賽季15套裝"
L["NOTE_66"] = "競技場賽季16套裝"
L["NOTE_89"] = "BFA賽季1"
L["NOTE_93"] = "BFA賽季2"
L["NOTE_80"] = "軍臨天下榮譽套裝"
L["NOTE_79"] = "軍臨天下賽季1"
L["NOTE_83"] = "軍臨天下賽季3"
L["NOTE_85"] = "軍臨天下賽季5"
L["NOTE_8"] = "等級60 PvP 史詩套裝"
L["NOTE_6"] = "等級60 PvP 精良套裝"
L["NOTE_16"] = "等級70 PvP 精良套裝"
L["NOTE_21"] = "等級70 PvP 精良套裝 2"
L["NOTE_36"] = "等級85 PvP 史詩套裝"
L["NOTE_32"] = "等級85 PvP 精良套裝"
L["NOTE_41"] = "等級90 PvP 精良套裝"
L["NOTE_73"] = "德拉諾之霸賽季3"
L["NOTE_72"] = "德拉諾之霸賽季2"

--Dungeon Sets
L["NOTE_87"] = "BFA地城套裝"
L["NOTE_50"] = "浩劫與重生地城套裝"
L["NOTE_52"] = "挑戰模式地城套裝"
L["NOTE_77"] = "職業大廳套裝"
L["NOTE_45"] = "經典地城套裝"
L["NOTE_1"] = "地城套裝1"
L["NOTE_2"] = "地城套裝2"
L["NOTE_14"] = "地城套裝3"
L["NOTE_49"] = "暮光之時地城套裝"
L["NOTE_76"] = "軍臨天下地城套裝"
L["NOTE_51"] = "潘達利亞地城套裝"
L["NOTE_46"] = "食人妖地城套裝"
L["NOTE_67"] = "德拉諾之霸地城套裝"
L["NOTE_47"] = "巫妖王之怒地城套裝1"
L["NOTE_48"] = "巫妖王之怒地城套裝2"

--Base
L["NOTE_2"] = "異色版"
L["NOTE_12"] = "同盟種族套裝"
L["NOTE_10"] = "經典世界套裝"
L["NOTE_4"] = "地下城套裝"
L["NOTE_8"] = "事件套裝"
L["NOTE_11"] = "要塞套裝"
L["NOTE_5"] = "PvP套裝"
L["NOTE_6"] = "團隊套裝"
L["NOTE_7"] = "任務套裝"
L["NOTE_44"] = "經典世界套裝"

--Expansion
L["NOTE_8"] = "決戰艾澤拉斯"
L["NOTE_7"] = "軍臨天下"
L["NOTE_6"] = "德拉諾之霸"
L["NOTE_5"] = "潘達利亞迷霧"
L["NOTE_4"] = "浩劫與重生"
L["NOTE_3"] = "巫妖王之怒"
L["NOTE_2"] = "燃燒的遠征"
L["NOTE_1"] = "無"


--Questing
L["NOTE_84"] = "阿古斯任務套裝"
L["NOTE_53"] = "艾澤拉斯任務套裝"
L["NOTE_92"] = "BFA任務套裝"
L["NOTE_81"] = "破碎群島任務套裝"
L["NOTE_55"] = "浩劫與重生任務套裝"
L["NOTE_75"] = "軍臨天下任務套裝"
L["NOTE_56"] = "潘達利亞任務套裝"
L["NOTE_68"] = "德拉諾之霸任務套裝"
L["NOTE_54"] = "巫妖王之怒任務套裝"

--Gusses
L["NOTE_95"] = "BFA賽季3"
L["NOTE_96"] = "永恆宮殿團隊套裝"
L["NOTE_97"] = "納沙塔爾任務套裝"
L["NOTE_0"] = ""
--Raid

L["NOTE_-2323"] = "任何"
L["NOTE_57"] = "經典抗性套裝"
L["NOTE_94"] = "達薩亞洛團隊套裝"
L["NOTE_59"] = "魔古山寶庫團隊套裝"
L["NOTE_9"] = "安其拉廢墟套裝"
L["NOTE_58"] = "太陽井高地團隊套裝"
L["NOTE_10"] = "安其拉神廟團隊套裝"
L["NOTE_3"] = "熔火之心套裝"
L["NOTE_4"] = "黑翼之巢套裝"
L["NOTE_5"] = "納克薩瑪斯(原始)團隊套裝"
L["NOTE_12"] = "卡拉贊、戈魯爾之巢、馬瑟里頓的巢穴團隊套裝"
L["NOTE_13"] = "T5團隊套裝"
L["NOTE_18"] = "海加爾山、黑暗神廟、太陽之井高地團隊套裝"
L["NOTE_23"] = "納克薩瑪斯(巫妖王)團隊套裝"
L["NOTE_25"] = "奧杜亞團隊套裝"
L["NOTE_27"] = "十字軍的試煉團隊套裝"
L["NOTE_29"] = "冰冠城寨團隊套裝"
L["NOTE_31"] = "暮光堡壘與黑翼陷窟團隊套裝"
L["NOTE_35"] = "火源之地團隊套裝"
L["NOTE_38"] = "巨龍之魂團隊套裝"
L["NOTE_39"] = "豐泉臺與恐懼之心團隊套裝"
L["NOTE_43"] = "雷霆王座團隊套裝"
L["NOTE_64"] = "圍攻奧格瑪團隊套裝"
L["NOTE_65"] = "黑石鑄造場團隊套裝"
L["NOTE_71"] = "地獄火堡壘團隊套裝"
L["NOTE_78"] = "暗夜堡團隊套裝"
L["NOTE_82"] = "薩格拉斯之墓團隊套裝"
L["NOTE_86"] = "燃燒的王座團隊套裝"
L["NOTE_88"] = "奧迪爾團隊套裝"
L["NOTE_70"] = "德拉諾之霸LFR套裝"
L["NOTE_61"] = "巫妖王之怒團隊套裝1"
L["NOTE_11"] = "祖爾格拉布套裝"
L["NOTE_90"] = "傳統護甲"

--Event
L["NOTE_74"] = "惡魔入侵事件套裝"
L["NOTE_91"] = "海嶼遠征事件套裝"
L["NOTE_60"] = "天譴入侵事件套裝"
L["NOTE_69"] = "要塞套裝"
L["NOTE_1001"] = "暗影之境入侵事件套裝"
