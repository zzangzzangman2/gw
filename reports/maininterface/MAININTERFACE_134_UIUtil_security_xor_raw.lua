local r=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local d=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local e=require("DataNode/DataTable/Create/sys/DTSysCodeDBModel")
local w=require("DataNode/DataTable/Create/item/DTItemDBModel")
local j=require("DataNode/DataTable/Create/equip/DTEquipDBModel")
local x=require("DataNode/DataTable/Create/constant/DTCurrencyDBModel")
local _=require("DataNode/DataTable/Create/underwear/DTUnderWearDBModel")
local c=require("DataNode/DataTable/Create/player/DTHeadDBModel")
local k=require("DataNode/DataTable/Create/player/DTHeadFrameDBModel")
local m=require("DataNode/DataManager/DataMgr/DataUtil")
local A=require("DataNode/DataTable/Create/activity/DTActivityPointDBModel")
local f=require('DataNode/DataTable/Create/hero/DTHeroVoiceDBModel')
local I=require("DataNode/DataTable/Create/harem/DTLoverVoiceDBModel")
local O=require('DataNode/DataTable/Create/harem/DTLoverUnlockDBModel')
local z=require("DataNode/DataTable/Create/officer/DTOfficerDBModel")
local e=require("DataNode/DataTable/Create/monster/DTMonsterDBModel")
local T=require('DataNode/DataTable/Create/amulet/DTAmuletDBModel')
local E=require('DataNode/DataTable/Create/amulet/DTAmuletGiftDBModel')
local N=require('DataNode/DataTable/Create/treasure/DTTreasureDBModel')
local S=require('DataNode/DataTable/Create/luxuryGoods/DTluxuryGoodsDBModel')
local e=require('DataNode/DataTable/Create/skillAct/DTSkillActDBModel')
local b=require('DataNode/DataTable/Create/constant/DTBattleAttrDBModel')
local H=require("DataNode/DataTable/Create/activity/DTSaunteredCardDBModel")
local q=require("DataNode/DataTable/Create/item/DTItemIconPath")
local i=string.format
local g=math.floor
local R=require("Common/cs_coroutine")
local u={9999,10000,99999999,100000000}
local l={
GameTools.GetLocalize("UI.Common.Num02",LanguageCategory.LangCommon),
GameTools.GetLocalize("UI.Common.Num01",LanguageCategory.LangCommon),
}
UIUtil={
isShowAttrTips=true,
prevPlayAudioId=0,
isShowingItemTip=false
}
ItemQuailtyBgs={
[ItemColor.White]="T_zhuangbeikuang_0",
[ItemColor.Green]="T_zhuangbeikuang_1",
[ItemColor.Blue]="T_zhuangbeikuang_2",
[ItemColor.Purple]="T_zhuangbeikuang_3",
[ItemColor.Orange]="T_zhuangbeikuang_4",
[ItemColor.Red]="T_zhuangbeikuang_5"
}
EquipQuailtyBgs={
[EquipQulity.White]="T_zhuangbeikuang_0",
[EquipQulity.Green]="T_zhuangbeikuang_1",
[EquipQulity.Blue]="T_zhuangbeikuang_2",
[EquipQulity.Purple]="T_zhuangbeikuang_3",
[EquipQulity.Orange]="T_zhuangbeikuang_4",
[EquipQulity.Gold]="T_zhuangbeikuang_5"
}
SummonPetQuailtyBgs={
[EquipQulity.White]="T_zhuangbeikuang_0",
[EquipQulity.Green]="T_zhuangbeikuang_1",
[EquipQulity.Blue]="T_zhuangbeikuang_2",
[EquipQulity.Purple]="T_zhuangbeikuang_3",
[EquipQulity.Orange]="T_zhuangbeikuang_4",
[EquipQulity.Gold]="T_zhuangbeikuang_5",
[EquipQulity.Colorful]="T_zhuangbeikuang_6",
}
EquipGemEffects={
[EquipQulity.Purple]={"B1","B"},
[EquipQulity.Orange]={"A1","A"},
[EquipQulity.Gold]={"C1","C"}
}
EquipQuailtyBaseboard={
[EquipQulity.White]="BG_zhuangbeikuang_0",
[EquipQulity.Green]="BG_zhuangbeikuang_1",
[EquipQulity.Blue]="BG_zhuangbeikuang_2",
[EquipQulity.Purple]="BG_zhuangbeikuang_3",
[EquipQulity.Orange]="BG_zhuangbeikuang_4",
[EquipQulity.Gold]="BG_zhuangbeikuang_5"
}
UnderwearQuailtyBgs={
[ItemColor.White]="IC_neiyi_neiyidi1",
[ItemColor.Green]="IC_neiyi_neiyidi1",
[ItemColor.Blue]="IC_neiyi_neiyidi2",
[ItemColor.Purple]="IC_neiyi_neiyidi3",
[ItemColor.Orange]="IC_neiyi_neiyidi4",
[ItemColor.Red]="IC_neiyi_neiyidi5"
}
TreasureQuailtyBgs={
[TreasureQulity.White]="Treasure_T_baojukuang_1",
[TreasureQulity.Green]="Treasure_T_baojukuang_2",
[TreasureQulity.Blue]="Treasure_T_baojukuang_3",
[TreasureQulity.Purple]="Treasure_T_baojukuang_4",
[TreasureQulity.Orange]="Treasure_T_baojukuang_5",
[TreasureQulity.Red]="Treasure_T_baojukuang_6",
[TreasureQulity.Colorful]="Treasure_T_baojukuang_7",
}
TreasureQuailtyBaseboard={
[TreasureQulity.White]="Treasure_BG_baojukuang_1",
[TreasureQulity.Green]="Treasure_BG_baojukuang_2",
[TreasureQulity.Blue]="Treasure_BG_baojukuang_3",
[TreasureQulity.Purple]="Treasure_BG_baojukuang_4",
[TreasureQulity.Orange]="Treasure_BG_baojukuang_5",
[TreasureQulity.Red]="Treasure_BG_baojukuang_6",
[TreasureQulity.Colorful]="Treasure_BG_baojukuang_7",
}
TreasureBreakImage="BJ_xingxing"
TreasureBreakImageBg="BJ_xingxing_1"
LuxuryBreakImage="UICommonOther_2/scp_xingji"
LuxuryBreakImageBg="UICommonOther_2/scp_xinghui"
LuxuryQuailtyBaseboard={
[ItemColor.Purple]="scp_daojukuang_5",
[ItemColor.Orange]="scp_daojukuang_4",
[ItemColor.Red]="scp_daojukuang_3"
}
CardQuailtyBgs={
[Quality.R]="T_zhuangbeikuang_1",
[Quality.SR]="T_zhuangbeikuang_2",
[Quality.SSR]="T_zhuangbeikuang_3",
[Quality.UR]="T_zhuangbeikuang_4",
[Quality.LR]="T_zhuangbeikuang_5",
}
BreakCardQuailtyBgs={
[1]="T_zhuangbeikuang_0",
[2]="T_zhuangbeikuang_1",
[3]="T_zhuangbeikuang_1",
[4]="T_zhuangbeikuang_2",
[5]="T_zhuangbeikuang_2",
[6]="T_zhuangbeikuang_3",
[7]="T_zhuangbeikuang_3",
[8]="T_zhuangbeikuang_3",
[9]="T_zhuangbeikuang_4",
[10]="T_zhuangbeikuang_4",
[11]="T_zhuangbeikuang_4",
[12]="T_zhuangbeikuang_5",
[15]="T_zhuangbeikuang_6",
}
BreakCardGemstoneCount={
[1]=0,
[2]=0,
[3]=1,
[4]=0,
[5]=1,
[6]=0,
[7]=1,
[8]=2,
[9]=0,
[10]=1,
[11]=2,
[12]=0,
[15]=0,
}
BreakCardGemstoneIcon={
[1]="T_zhuangbeikuang_0_bs",
[2]="T_zhuangbeikuang_1_bs",
[3]="T_zhuangbeikuang_1_bs",
[4]="T_zhuangbeikuang_2_bs",
[5]="T_zhuangbeikuang_2_bs",
[6]="T_zhuangbeikuang_3_bs",
[7]="T_zhuangbeikuang_3_bs",
[8]="T_zhuangbeikuang_3_bs",
[9]="T_zhuangbeikuang_4_bs",
[10]="T_zhuangbeikuang_4_bs",
[11]="T_zhuangbeikuang_4_bs",
[12]="T_zhuangbeikuang_5_bs",
[15]="T_zhuangbeikuang_6_bs",
}
CardQuailtyFont={
[Quality.N]="IC_n",
[Quality.R]="IC_r",
[Quality.SR]="IC_sr",
[Quality.SSR]="IC_ssr",
[Quality.UR]="IC_ur",
[Quality.LR]="IC_lr",
}
ProfessionIcons={
[ProfessionType.Tank]="IC_zhiye_1",
[ProfessionType.Mage]="IC_zhiye_2",
[ProfessionType.Warrior]="IC_zhiye_3"
}
EquipEmptyFrames={
[PROTO_ENUM.EquipPos.EQUIP_POS_HELMET]="UILineup/IC_toukui",
[PROTO_ENUM.EquipPos.EQUIP_POS_GLOVE]="UILineup/IC_shoutao",
[PROTO_ENUM.EquipPos.EQUIP_POS_TROUSER]="UILineup/IC_kuzi",
[PROTO_ENUM.EquipPos.EQUIP_POS_CHEST]="UILineup/IC_xiongjia",
[PROTO_ENUM.EquipPos.EQUIP_POS_BOOT]="UILineup/IC_xie",
[PROTO_ENUM.EquipPos.EQUIP_POS_BELT]="UILineup/IC_jiezhi",
[PROTO_ENUM.EquipPos.EQUIP_POS_WEAPON]="UILineup/IC_xiongjia"
}
UnderwearEmptyFrames={
[PROTO_ENUM.ENUM_UNDERWEAR_POS.UNDERWEAR_BRA]="UICommonOther/IC_neiyi_neiyicaikong4",
[PROTO_ENUM.ENUM_UNDERWEAR_POS.UNDERWEAR_KNICKERS]="UICommonOther/IC_neiyi_neiyicaikong5",
[PROTO_ENUM.ENUM_UNDERWEAR_POS.UNDERWEAR_COSMETICS]="UICommonOther/IC_neiyi_neiyicaikong2",
[PROTO_ENUM.ENUM_UNDERWEAR_POS.UNDERWEAR_SOCKS]="UICommonOther/IC_neiyi_neiyicaikong3",
[PROTO_ENUM.ENUM_UNDERWEAR_POS.UNDERWEAR_PERFUME]="UICommonOther/IC_neiyi_neiyicaikong1",
[PROTO_ENUM.ENUM_UNDERWEAR_POS.UNDERWEAR_SHOES]="UICommonOther/IC_neiyi_neiyicaikong6"
}
BagInfoBg={
[EquipQulity.White]="T_zhuangbeitubiaoban1_beiban",
[EquipQulity.Green]="T_zhuangbeitubiaoban5_beiban",
[EquipQulity.Blue]="T_zhuangbeitubiaoban2_beiban",
[EquipQulity.Purple]="T_zhuangbeitubiaoban3_beiban",
[EquipQulity.Orange]="T_zhuangbeitubiaoban4_beiban",
[EquipQulity.Gold]="T_zhuangbeitubiaoban6_beiban",
[EquipQulity.Colorful]="T_zhuangbeitubiaoban7_beiban",
}
BagInfoWordColor={
[EquipQulity.White]=DefaultColor.white,
[EquipQulity.Green]=DefaultColor.green,
[EquipQulity.Blue]=DefaultColor.blue,
[EquipQulity.Purple]=DefaultColor.purple,
[EquipQulity.Orange]=DefaultColor.orange,
[EquipQulity.Gold]=DefaultColor.red
}
EGuildPosData={
[0]={langKey="UI.guild.Manage.57",icon="UIGuild/IC_chengyuan"},
[1]={langKey="UI.guild.Manage.56",icon="UIGuild/IC_jingying"},
[2]={langKey="UI.guild.Manage.55",icon="UIGuild/IC_fuhuizhang"},
[3]={langKey="UI.guild.Join.06",icon="UIGuild/IC_huizhang"}
}
EItemFlyType={
GameItem=1,
Image=2
}
EItemFlyAnimType={
Normal=1,
Flower=2,
Fleeting=3,
}
EItemFlyTargetType={
Bag=1
}
EBattleItemFlyTargetType={
BattleBox=1,
}
EHintSizeType={
Small="Small",
Standard="Standard",
Big="Big",
}
EHintPageDir={
Up="Up",
Down="Down",
Left="Left",
Right="Right"
}
EHintArrowAlign={
Horizontal_Left="Horizontal_Left",
Horizontal_Center="Horizontal_Center",
Horizontal_Right="Horizontal_Right",
Vertical_Upper="Vertical_Upper",
Vertical_Middle="Vertical_Middle",
Vertical_Down="Vertical_Down"
}
RelicColorIcon={
[EQualityType.Color3]="UIMazeArti/artirar_rare",
[EQualityType.Color4]="UIMazeArti/artirar_epic",
[EQualityType.Color5]="UIMazeArti/artirar_ledg"
}
EMoveingDir={
Stop="Stop",
Left="Left",
Right="Right",
}
CurrencyType={
Gold="Gold",
Diamond="Diamond",
FightValue="FightValue",
Others="Others"
}
GemEmptyFrame="UILineup/BG_baoshi"
EDigit={
WanMill=1000000000000,
HundredMill=100000000,
Thousand=1000,
Wan=10000,
Hundred=100,
Ten=10,
}
function UIUtil.SetHeroFrameGemstone(e,t)
if e and BreakCardGemstoneCount[t]>0 then
LuaUtils.SetActive(e,true)
local n=BreakCardGemstoneCount[t]
local a=LuaUtils.GetChildrenCount(e)
local o=i("UICommonOther/%s",BreakCardGemstoneIcon[t])
for t=1,a do
local e=UIUtil.GetChild(e,t-1)
if t<=n then
GameTools:SetImageSprite(e,o,false)
LuaUtils.SetActive(e,true)
else
LuaUtils.SetActive(e,false)
end
end
else
if e then
LuaUtils.SetActive(e,false)
end
end
end
function UIUtil.CheckCloseUIForm(e)
if GameEntry.UI:IsExists(e)then
GameTools.CloseUIForm(e,true)
return true
end
return false
end
function UIUtil.ShowCommonTips(e,t)
if not GameEntry.UI:IsExists(UIFormId.UI_CommonTips)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonTips,{msgContent=e,waitTime=t})
else
EventSystem.SendEvent(CommonEventId.CommonTipsShow,{msgContent=e,waitTime=t})
end
end
function UIUtil.ShowCommonItemTips(e)
if not GameEntry.UI:IsExists(UIFormId.UI_ItemTips)then
GameEntry.UI:OpenUIForm(UIFormId.UI_ItemTips,e)
else
EventSystem.SendEvent(CommonEventId.OnItemTips,e)
end
end
function UIUtil.ShowCommonTips3(e)
if not GameEntry.UI:IsExists(UIFormId.UI_CommonTips)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonTips,{event=CommonEventId.CommonTipsShow3,msgContent=e})
else
EventSystem.SendEvent(CommonEventId.CommonTipsShow3,{msgContent=e})
end
end
function UIUtil.ShowItemNotEnough(e)
local e=ModulesInit.BagManager:GetBaseInfo(e,true)
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Maze.Main.01",LanguageCategory.LangCommon,e.name))
end
function UIUtil.ShowCommonItemFly(e)
local e={itemFlyEvent=CommonEventId.CommonItemFly,flyContentArr=e}
UIUtil.checkShowUI(UIFormId.UI_CommonItemFly,e,CommonEventId.CommonItemFly)
end
function UIUtil.ShowHint(e)
UIUtil.checkShowUI(UIFormId.UI_CommonHint,e,CommonEventId.OnEventCommonHint)
end
function UIUtil.ShowDanmuView(e,t)
if e then
UIUtil.checkShowUI(UIFormId.UI_DanmuView,t,CommonEventId.OnEventCommonDanmu)
else
UIUtil.CheckCloseUIForm(UIFormId.UI_DanmuView)
end
end
function UIUtil.ShowItemTip(e)
local a=true
if e and BagUtil.IsEquip(e.thingDid)then
GameEntry.UI:OpenUIForm(UIFormId.UI_EquipInfo,{equipDid=e.thingDid,equipId=e.id,isMagicNor=e.isMagicNor,isAdvMagic=e.isAdvMagic})
elseif e and BagUtil.IsUnderwear(e.thingDid)then
GameEntry.UI:OpenUIForm(UIFormId.UI_UnderwearInfo,{underwearDid=e.thingDid})
elseif e and BagUtil.IsAmuletGift(e.thingDid)then
GameEntry.UI:OpenUIForm(UIFormId.UI_AmuletdentifyView,{amuletGiftDid=e.thingDid})
elseif e and BagUtil.IsAmulet(e.thingDid)then
GameEntry.UI:OpenUIForm(UIFormId.UI_AmuletTipsView,{amuletId=e.thingId,amuletDid=e.thingDid,info=e.info})
elseif e and BagUtil.IsTreasure(e.thingDid)then
GameEntry.UI:OpenUIForm(UIFormId.UI_TreasureInfo,{treasureDid=e.thingDid,isMax=e.isMax})
elseif e and BagUtil.IsLuxury(e.thingDid)then
GameEntry.UI:OpenUIForm(UIFormId.UI_LuxuryInfo,{luxuryDid=e.thingDid,luxuryId=e.luxuryId,isMax=e.isMax or false,isTujian=e.isTujian})
elseif e and BagUtil.IsCollectibles(e.thingDid)then
local t={
IsNewGet=e.IsNewGet,
IsActive=true,
ShowLevel=e.ShowLevel,
IsShowCompare=false,
}
ModulesInit.CollectiblesDetailsMgr:EnterCollectiblesDetailsView(e.thingDid,t)
elseif e and BagUtil.IsSummonPetEquip(e.thingDid)then
UIUtil.checkShowUI(UIFormId.UI_SummonPetEquip_Info,{petEqiupDid=e.thingDid,petEqiupId=e.petEqiupId,isMax=e.isMax or false})
else
UIUtil.checkShowUI(UIFormId.UI_GameItemInfoView,e,CommonEventId.OnEventItemInfoShow)
end
if a then
UIUtil.isShowingItemTip=true
end
end
function UIUtil.CloseItemTip()
if GameEntry.UI:IsExists(UIFormId.UI_EquipInfo)then
GameTools.CloseUIForm(UIFormId.UI_EquipInfo)
end
if GameEntry.UI:IsExists(UIFormId.UI_UnderwearInfo)then
GameTools.CloseUIForm(UIFormId.UI_UnderwearInfo)
end
if GameEntry.UI:IsExists(UIFormId.UI_GameItemInfoView)then
GameTools.CloseUIForm(UIFormId.UI_GameItemInfoView)
end
UIUtil.isShowingItemTip=false
end
function UIUtil.ShowBoxTip(e)
UIUtil.checkShowUI(UIFormId.UI_GameBoxInfoView,e,CommonEventId.OnEventGameBoxShow)
end
function UIUtil.ShowGuildBoxTip(e)
UIUtil.checkShowUI(UIFormId.UI_GuildBoxInfoView,e,CommonEventId.OnEventGuildBoxInfoShow)
end
function UIUtil.ShowGuildBoxTip2(e)
UIUtil.checkShowUI(UIFormId.UI_GameGuildBoxInfoView,e,CommonEventId.OnEventGameGuildBoxShow)
end
function UIUtil.ShowOpenFuncTip(e)
UIUtil.checkShowUI(UIFormId.UI_GameFuncTipView,e,CommonEventId.OnEventFuncTipShow)
end
function UIUtil.checkShowUI(e,t,a)
if not GameEntry.UI:IsExists(e)then
GameEntry.UI:OpenUIForm(e,t)
else
if a then
EventSystem.SendEvent(a,t)
end
end
end
function UIUtil.forceShowUI(e,t)
if not GameEntry.UI:IsExists(e)then
GameEntry.UI:OpenUIForm(e,t)
else
GameTools.CloseUIForm(e,true)
GameEntry.UI:OpenUIForm(e,t)
end
end
function UIUtil.ShowAwardTips(e)
local t={}
for a,e in ipairs(e or{})do
local a=ModulesInit.BagManager:GetBaseInfo(e.itemDid)
local o=ModulesInit.BagManager:GetLocalType(e.itemDid)
local a=GameTools.GetLocalize(a.name,o)
local e=a.."×"..e.count
table.insert(t,e)
end
UIUtil.ShowCommonTips(t)
end
function UIUtil.ShowCommonTipsForCode(e)
UIUtil.ShowCommonTipsForLocalize("errCode"..e)
end
function UIUtil.ShowCommonTipsForLocalize(a,e,...)
if not e then
e=LanguageCategory.LangCommon
end
local t
if...then
t=GameTools.GetLocalize(a,e,...)
else
t=GameTools.GetLocalize(a,e)
end
if not t then
UIUtil.ShowCommonTips("id:"..a.." not define")
return
end
UIUtil.ShowCommonTips(t)
end
function UIUtil.SetIsShowAttrTips(e)
UIUtil.isShowAttrTips=e
end
function UIUtil.ShowAttrTips(e)
if not UIUtil.isShowAttrTips then
return
end
if PlayerMgr.loginLoadComplete==false then
return
end
if not GameEntry.UI:IsExists(UIFormId.UI_FightAttrTips)then
GameEntry.UI:OpenUIForm(UIFormId.UI_FightAttrTips,e)
else
EventSystem.SendEvent(CommonEventId.OnFightAttrChange,e)
end
end
function UIUtil.ShowMessageBox(e)
if not GameEntry.UI:IsExists(UIFormId.UI_CommonBox)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonBox,e)
end
end
function UIUtil.ShowMessageBox2(e)
if not GameEntry.UI:IsExists(UIFormId.UI_CommonBox2)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonBox2,e)
end
end
function UIUtil.ShowMessageBox3(e)
if not GameEntry.UI:IsExists(UIFormId.UI_CommonBox3)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonBox3,e)
end
end
function UIUtil.ShowItemCommonBuy(e)
if not GameEntry.UI:IsExists(UIFormId.UI_ItemCommonBuy)then
GameEntry.UI:OpenUIForm(UIFormId.UI_ItemCommonBuy,e)
end
end
function UIUtil.ShowItemCommonSale(e)
if not GameEntry.UI:IsExists(UIFormId.UI_ItemCommonSale)then
GameEntry.UI:OpenUIForm(UIFormId.UI_ItemCommonSale,e)
end
end
function UIUtil.CloseItemCommonBuy()
GameTools.CloseUIForm(UIFormId.UI_ItemCommonBuy)
end
function UIUtil.SetHeroHead2(t,e)
local e=HeroMgr:GetHeroSkinHeroDidByData(e)
local e=UIUtil.GetHeroModelCfgData(e)
local e=i("UIHeroHead/%s",e.head)
GameTools:SetImageSprite(t,e,false)
end
function UIUtil.SetHeroEmpty(e)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
LuaUtils.SetImageSprite(e["im_bg"],"UICommonOther/BG_zhuangbeikuang_0",false)
LuaUtils.SetImageSprite(e["im_frame"],"UICommonOther/T_zhuangbeikuang_0",false)
LuaUtils.SetImageSprite(e["im_touxiang"],"UIHeroHead/UIHeroHead_1/head990",false)
end
function UIUtil.SetHeroEmpty(e)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
LuaUtils.SetImageSprite(e["im_bg"],"UICommonOther/BG_zhuangbeikuang_0",false)
LuaUtils.SetImageSprite(e["im_frame"],"UICommonOther/T_zhuangbeikuang_0",false)
LuaUtils.SetImageSprite(e["im_touxiang"],"UIHeroHead/UIHeroHead_1/head990",false)
end
function UIUtil.SetHeroHead(e,t,l)
local a=d.GetEntity(t.heroDid)
local n=BreakCardQuailtyBgs[t.lockLevel]
local h=t.lockLevel
local o=false
local s=HeroMgr:GetHeroRingForHeroDid(t.heroDid)
if not s then
GameInit.LogError('这里设置英雄头像时没有传戒指id:'..debug.traceback())
end
if s and s~=0 then
o=true
end
if t.ringShow or t.ringShow==nil then
elseif t.ringShow==false then
o=false
end
if n==nil then
n=BreakCardQuailtyBgs[1]
h=1
end
local d=i("UICommonOther/%s",n)
local r=i("UICommonOther/%s",CardQuailtyFont[a.star])
local n=t.heroDid
if l~=false then
n=HeroMgr:GetHeroSkinHeroDidByData(t)
end
local n=UIUtil.GetHeroModelCfgData(n)
local s=i("UIHeroHead/%s",n.head)
local i=i("UICommonOther/%s",ProfessionIcons[a.profession])
local n=LuaUtils.GetLuaComBinder(e)
if not n then
if e:Find("ring")then
LuaUtils.SetChildActive(e,'ring',o)
end
GameTools:SetImageSprite(e:Find("im_frame"),d,false)
UIUtil.SetHeroFrameGemstone(e:Find("gemstoneLayout"),h)
GameTools:SetImageSprite(e:Find("im_touxiang"),s,false)
GameTools:SetImageSprite(e:Find("im_quality"),r,true)
GameTools:SetImageSprite(e:Find("im_occupation"),i,false)
LuaUtils.SetActive(e:Find("im_xuanzhong2"),false)
LuaUtils.SetActive(e:Find("im_hongdian"),false)
LuaUtils.SetChildActive(e,"im_zhezhao",false)
UIUtil.HandlerHeroQualityImgEff(e:Find("im_quality"),a.star,HeroMgr:checkHasHero(a.id))
else
local t=n:GetComponents()
if t['ring']then
LuaUtils.SetActive(t['ring'],o)
end
GameTools:SetImageSprite(t["im_frame"],d,false)
UIUtil.SetHeroFrameGemstone(e:Find("gemstoneLayout"),h)
GameTools:SetImageSprite(t["im_touxiang"],s,false)
GameTools:SetImageSprite(t["im_quality"],r,true)
GameTools:SetImageSprite(t["im_occupation"],i,false)
LuaUtils.SetActive(e:Find("im_xuanzhong2"),false)
LuaUtils.SetActive(t["im_hongdian"],false)
LuaUtils.SetActive(t["im_zhezhao"],false)
UIUtil.HandlerHeroQualityImgEff(t["im_quality"],a.star,HeroMgr:checkHasHero(a.id))
end
local o=t.rankLevel
local t=e:Find("stars")
local e=LuaUtils.GetChildrenCount(t)
for e=1,e do
local t=UIUtil.GetChild(t,e-1)
if e<=o then
LuaUtils.SetActive(t,true)
else
LuaUtils.SetActive(t,false)
end
end
return a
end
function UIUtil.SetSuperHeroHead(n,a,s,t)
local o=d.GetEntity(a.heroDid)
local h=BreakCardQuailtyBgs[a.lockLevel]
local d=a.lockLevel
local r=false
local e=HeroMgr:GetHeroRingForHeroDid(a.heroDid)
if not e then
GameInit.LogError('这里设置英雄头像时没有传戒指id:'..debug.traceback())
end
if e and e~=0 then
r=true
end
if a.ringShow or a.ringShow==nil then
elseif a.ringShow==false then
r=false
end
if h==nil then
h=BreakCardQuailtyBgs[1]
d=1
end
local l=i("UICommonOther/%s",h)
local u=i("UICommonOther/%s",CardQuailtyFont[o.star])
local e=a.heroDid
if s.useSkin~=false then
e=HeroMgr:GetHeroSkinHeroDidByData(a)
end
local e=UIUtil.GetHeroModelCfgData(e)
local h=i("UIHeroHead/%s",e.head)
local i=i("UICommonOther/%s",ProfessionIcons[o.profession])
local e=LuaUtils.GetLuaComBinder(n)
local e=e:GetComponents()
if e['ring']then
LuaUtils.SetActive(e['ring'],r and t==nil)
end
LuaUtils.SetImageSprite(e["im_frame"],l,false)
if t then
LuaUtils.SetActive(n:Find("gemstoneLayout"),false)
else
LuaUtils.SetActive(n:Find("gemstoneLayout"),true)
UIUtil.SetHeroFrameGemstone(n:Find("gemstoneLayout"),d)
end
LuaUtils.SetImageSprite(e["im_touxiang"],h,false)
if t==nil or t[EHeroAttrType.Quality]then
LuaUtils.SetActive(e['im_quality'],true)
LuaUtils.SetImageSprite(e["im_quality"],u,true)
UIUtil.HandlerHeroQualityImgEff(e["im_quality"],o.star,s.showEffect~=true and HeroMgr:checkHasHero(o.id),s.isUseSpine==true)
else
LuaUtils.SetActive(e['im_quality'],false)
end
if t==nil or t[EHeroAttrType.Profession]then
LuaUtils.SetActive(e['im_occupation'],true)
LuaUtils.SetImageSprite(e["im_occupation"],i,false)
else
LuaUtils.SetActive(e['im_occupation'],false)
end
LuaUtils.SetActive(n:Find("im_xuanzhong2"),false)
LuaUtils.SetActive(e["im_hongdian"],false)
LuaUtils.SetActive(e["im_zhezhao"],s.showMask==true)
LuaUtils.SetActive(e["im_zhan"],false)
if t==nil or t[EHeroAttrType.Star]then
LuaUtils.SetActive(e['stars_trans'],true)
local t=EHeroAttrType2Attr[EHeroAttrType.Star]
local t=a[t]
LuaUtils.SetTextMeshText(e["text_star_num"],GameTools.GetLocalize("UI.Campaign.Battle.04",LanguageCategory.LangCommon,t))
else
LuaUtils.SetActive(e['stars_trans'],false)
end
if t==nil or t[EHeroAttrType.Favorability]then
LuaUtils.SetActive(e['favorability_trans'],true)
local t=EHeroAttrType2Attr[EHeroAttrType.Favorability]
local t=a[t]
LuaUtils.SetTextMeshText(e["text_facorability_num"],tostring(t))
else
LuaUtils.SetActive(e['favorability_trans'],false)
end
if t==nil or t[EHeroAttrType.LockLevel]then
LuaUtils.SetActive(e['text_count'].transform,true)
local t=EHeroAttrType2Attr[EHeroAttrType.LockLevel]
local t=math.max((a[t]-1),0)
LuaUtils.SetTextMeshText(e["text_count"],"+"..t)
else
LuaUtils.SetActive(e['text_count'].transform,false)
end
if t and t[EHeroAttrType.FireLevel]then
LuaUtils.SetActive(e['fire_trans'],true)
local t=EHeroAttrType2Attr[EHeroAttrType.FireLevel]
local a=a[t]
local t=LuaUtils.GetChildrenCount(e["fire_trans"].transform)
for t=1,t do
local e=UIUtil.GetChild(e["fire_trans"].transform,t-1)
if t<=a then
LuaUtils.SetActive(e,true)
else
LuaUtils.SetActive(e,false)
end
end
else
LuaUtils.SetActive(e['fire_trans'],false)
end
if t and t[EHeroAttrType.BeanLevel]then
LuaUtils.SetActive(e['bean_trans'],true)
local t=EHeroAttrType2Attr[EHeroAttrType.BeanLevel]
local a=a[t]
local t=LuaUtils.GetChildrenCount(e["bean_trans"].transform)
for t=1,t do
local e=UIUtil.GetChild(e["bean_trans"].transform,t-1)
if t<=a then
LuaUtils.SetActive(e,true)
else
LuaUtils.SetActive(e,false)
end
end
else
LuaUtils.SetActive(e['bean_trans'],false)
end
return o
end
function UIUtil.SetSummonPetHead(e,t,a)
a=a or{}
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
local o=t==nil or t.petDid==0
LuaUtils.SetActive(e["NotEmpty"].transform,not o)
LuaUtils.SetActive(e["Empty"].transform,o)
if o then
return
end
LuaUtils.SetActive(e["stars"].transform,a.showStars and t.star>0)
if a.showStars then
LuaUtils.SetTextMeshText(e["text_star"],"x"..t.star)
end
local o=SummonPetMgr:GetSummonpetCfgDataById(t.petDid)
local i=UIUtil.GetSummonPetFramePath(o.color)
LuaUtils.SetImageSprite(e["im_frame"],i,false)
local i=UIUtil.GetPetModelCfgData(t.petDid)
LuaUtils.SetImageSprite(e["im_touxiang"],i.head,false)
LuaUtils.SetActive(e["im_zhezhao"].transform,false)
LuaUtils.SetActive(e["im_xuanzhong"].transform,false)
LuaUtils.SetImageSprite(e["im_quality"],UIUtil.GetEquipSuitStarPath(o.color,o.mainPetSwitch),true)
UIUtil.HandlerHeroQualityImgEff(e["im_quality"],o.color,true)
LuaUtils.SetActive(e["im_hongdian"].transform,false)
if a.showBattleImg==nil then
local t=SummonPetMgr:GetSummonPetFormationDataByPetId(t.petId)
if t then
LuaUtils.SetActive(e["im_zhan"].transform,true)
local t=SummonPetMgr:IsMainStation(t.pos)
local t=UIUtil.GetSummonPetStationPath(t)
LuaUtils.SetImageSprite(e["im_zhan"],t,true)
else
LuaUtils.SetActive(e["im_zhan"].transform,false)
end
else
LuaUtils.SetActive(e["im_zhan"].transform,a.showBattleImg)
if a.showBattleImg then
local t=ESummonPetPosType.Sub
if a.isMainStation==1 then
t=ESummonPetPosType.Main
end
local t=UIUtil.GetSummonPetStationPath(t)
LuaUtils.SetImageSprite(e["im_zhan"],t,true)
end
end
if t.level then
LuaUtils.SetActive(e["text_level"].transform,true)
LuaUtils.SetTextMeshText(e["text_level"],GameTools.GetLocalize("UI.Equip.Common.06",LanguageCategory.LangCommon,t.level))
else
LuaUtils.SetActive(e["text_level"].transform,false)
end
if hideBattleImg then
LuaUtils.SetActive(e["im_zhan"].transform,false)
end
end
function UIUtil.GetSummonPetFramePath(e)
return i("UICommonOther/%s",SummonPetQuailtyBgs[e])
end
function UIUtil.RefreshStar(t,i,n,s)
local e=LuaUtils.GetChildrenCount(t)
for e=1,e do
local o=UIUtil.GetChild(t,e-1)
local a=o:Find("IC_star")
local t=o:Find("xingzha1")
if t then
LuaUtils.SetActive(t.transform,e<=i)
local e=t:Find("Particle System").transform:GetComponent(typeof(CS.Coffee.UIExtensions.UIParticle))
e:Play()
end
if e<=i then
LuaUtils.SetImageSprite(a,"UICommonOther/IC_xingxing",false)
else
if n==1 then
LuaUtils.SetImageSprite(a,"UICommonOther/IC_xingxing_1",false)
else
LuaUtils.SetImageSprite(a,"UICommonOther/IC_xingxing_2",false)
end
end
LuaUtils.SetActive(o.transform,s>=e)
end
end
function UIUtil.RefreshPetSkill(e,a,t)
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
local o=SummonPetMgr:GetPetSkillDid(a.petDid,a.star,t)
local n=SummonPetMgr:GetPetSkillCfg(o,t)
local i=UIUtil.GetSummonPetStationPath(t)
LuaUtils.SetImageSprite(e["im_skill"],n.skillIcon,false)
LuaUtils.SetImageSprite(e["im_fight_icon"],i,false)
e["btn_skill"].onClick:RemoveAllListeners()
e["btn_skill"].onClick:AddListener(function()
local e={
skillDid=o or 0,
star=a.star or 0,
petDid=a.petDid or 0,
}
if e.skillDid==0 or e.star==0 or e.petDid==0 then

end
GameEntry.UI:OpenUIForm(UIFormId.UI_SummonPetSkillDetailView,{skillData=e,PetPosType=t})
end)
end
function UIUtil.GetPetModelCfgData(e)
local e=SummonPetMgr:GetSummonpetCfgDataById(e)
local e=r.GetEntity(e.modelID)
return e
end
function UIUtil.GetSummonPetStationPath(e)
if e==ESummonPetPosType.Main then
return"UICommonOther/zhs_tcbtn2"
elseif e==ESummonPetPosType.Sub then
return"UICommonOther/zhs_tcbtn3"
else
return"UICommonOther/zhs_tcbtn5"
end
end
function UIUtil.GetSummonPetStationDesPath(e)
if e==ESummonPetPosType.Main then
return"UISummonPet/zhs_tcmsz4"
elseif e==ESummonPetPosType.Sub then
return"UISummonPet/zhs_tcmsz5"
else
return"UISummonPet/zhs_tcmsz5"
end
end
function UIUtil.RefreshPetAttr(a,t,e)
local n=e and e or 1
local o=#t
local e=LuaUtils.GetChildrenCount(a)
for e=1,e do
local i=UIUtil.GetChild(a,e-1)
local a=LuaUtils.GetLuaComBinder(i.transform)
local a=a:GetComponents()
if o>=e then
local o=t[e][1]
local t=t[e][2]
local e=b.GetEntity(o)
LuaUtils.SetTextMeshText(a["text_name"],GameTools.GetLocalize(e.attrName,LanguageCategory.LangBattle))
LuaUtils.SetTextMeshText(a["text_value"],m:clientAttrShowValue(o,t*n))
end
LuaUtils.SetActive(i.transform,o>=e)
end
end
function UIUtil.SetMonsterHead(e,a,t)
local t=m.GetMonsterCfgData(t)
local t=t.GetEntity(a)
if not t then
GameInit.LogError("找不到Monster配置：%d",a)
return
end
local a=r.GetEntity(t.modelID)
local s=string.format('UIHeroHead/%s',a.head)
local h=i("UICommonOther/%s",BreakCardQuailtyBgs[1])
local n=i("UICommonOther/%s",CardQuailtyFont[t.star])
local o=i("UICommonOther/%s",ProfessionIcons[t.profession])
local a=LuaUtils.GetLuaComBinder(e)
if not a then
if e:Find("ring")then
LuaUtils.SetChildActive(e,'ring',false)
end
LuaUtils.SetChildActive(e,"im_zhezhao",false)
LuaUtils.SetImageSprite(e:Find("im_frame"),h,false)
LuaUtils.SetImageSprite(e:Find("im_touxiang"),s,false)
LuaUtils.SetImageSprite(e:Find("im_quality"),n,true)
LuaUtils.SetImageSprite(e:Find("im_occupation"),o,false)
UIUtil.HandlerHeroQualityImgEff(e:Find("im_quality"),t.star,true)
else
local e=a:GetComponents()
if e['ring']then
LuaUtils.SetActive(e['ring'],false)
end
if e['im_hongdian']then
LuaUtils.SetActive(e['im_hongdian'].transform,false)
end
if e['im_xuanzhong2']then
LuaUtils.SetActive(e['im_xuanzhong2'].transform,false)
end
LuaUtils.SetActive(e["im_zhezhao"],false)
LuaUtils.SetImageSprite(e["im_frame"],h,false)
LuaUtils.SetImageSprite(e["im_touxiang"],s,false)
LuaUtils.SetImageSprite(e["im_quality"],n,true)
LuaUtils.SetImageSprite(e["im_occupation"],o,false)
UIUtil.HandlerHeroQualityImgEff(e["im_quality"],t.star,true)
end
end
function UIUtil.SetMonsterHead2(e,t,a)
local a=m.GetMonsterCfgData(a)
local a=a.GetEntity(t)
if not a then
GameInit.LogError("找不到Monster配置：%d",t)
return
end
local s=r.GetEntity(a.modelID)
local t=BreakCardQuailtyBgs[a.lockLevel]
local o=a.lockLevel
if t==nil then
o=1
t=BreakCardQuailtyBgs[1]
end
local n=i("UICommonOther/%s",t)
local t=i("UICommonOther/%s",CardQuailtyFont[a.star])
local s=i("UIHeroHead/%s",s.head)
local i=i("UICommonOther/%s",ProfessionIcons[a.profession])
local t=LuaUtils.GetLuaComBinder(e)
if not t then
if e:Find("ring")then
LuaUtils.SetChildActive(e,'ring',false)
end
GameTools:SetImageSprite(e:Find("im_frame"),n,false)
UIUtil.SetHeroFrameGemstone(e:Find("gemstoneLayout"),o)
GameTools:SetImageSprite(e:Find("im_touxiang"),s,false)
LuaUtils.SetActive(e:Find("im_quality").transform,false)
GameTools:SetImageSprite(e:Find("im_occupation"),i,false)
LuaUtils.SetActive(e:Find("im_xuanzhong2"),false)
LuaUtils.SetActive(e:Find("im_hongdian"),false)
LuaUtils.SetChildActive(e,"im_zhezhao",false)
else
local t=t:GetComponents()
if t['ring']then
LuaUtils.SetActive(t['ring'],false)
end
GameTools:SetImageSprite(t["im_frame"],n,false)
UIUtil.SetHeroFrameGemstone(e:Find("gemstoneLayout"),o)
GameTools:SetImageSprite(t["im_touxiang"],s,false)
LuaUtils.SetActive(t["im_quality"].transform,false)
GameTools:SetImageSprite(t["im_occupation"],i,false)
LuaUtils.SetActive(e:Find("im_xuanzhong2"),false)
LuaUtils.SetActive(t["im_hongdian"],false)
LuaUtils.SetActive(t["im_zhezhao"],false)
end
local a=a.rankLevel
local e=e:Find("stars")
local t=LuaUtils.GetChildrenCount(e)
for t=1,t do
local e=UIUtil.GetChild(e,t-1)
if t<=a then
LuaUtils.SetActive(e,true)
else
LuaUtils.SetActive(e,false)
end
end
end
function UIUtil.SetProfessionIcon(t,e)
if type(e)~="number"then
GameInit.LogError("type error")
return
end
local e=i("UICommonOther/%s",ProfessionIcons[e])
GameTools:SetImageSprite(t:Find("im_occupation"),e,false)
end
function UIUtil.RefreshEmbattleName(a,t,o)
local e=LuaUtils.GetLuaComBinder(a.transform)
local e=e:GetComponents()
LuaUtils.SetLabelText(e["nameLabel"],t[1])
if type(tonumber(t[2]))~="number"then
return
end
UIUtil.SetProfessionIconInEmbattle(e["im_occupation"],tonumber(t[2]))
UIUtil.SetCampionDataInEmbattle(a.transform,tonumber(t[3]),false)
if o then
LuaUtils.SetActive(e["UI_Common_HeadHpItem"].transform,true)
else
LuaUtils.SetActive(e["UI_Common_HeadHpItem"].transform,false)
end
local t=e["nameLabel"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
t:SetLayoutHorizontal()
local e=e["node_name"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutHorizontal()
LuaUtils.RebuildLayout(a.transform)
end
function UIUtil.SetProfessionIconInEmbattle(t,e)
if type(e)~="number"then
GameInit.LogError("type error")
return
end
local e=i("UICommonOther/%s",ProfessionIcons[e])
GameTools:SetImageSprite(t,e,false)
end
function UIUtil.RefreshEmbattleCampion(a,o,t,e)
local e=UIUtil.GetEmbattleCampionData(a,e)
UIUtil.RefreshEmbattleCampionWithCampionData(o,t,e)
end
function UIUtil.GetEmbattleCampionData(o,t)
local i=0
local n=0
local a={}
local e=nil
if t then
e={1,4,2,5,3,6}
else
e={1,2,3,4,5,6}
end
for t=1,#e do
local o=UIUtil.GetChild(o,e[t]-1)
local o=o:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local e={
campionType=EBattleSkillAfterActionType.Normal,
isShow=false,
orderIndex=e[t],
}
if o.param3 then
local a=string.split(o.param3,"&")
e.campionType=tonumber(a[3])or 0
local a=false
if e.campionType==EBattleSkillAfterActionType.CampionAfter then
if n==0 then
n=t
e.isShow=true
end
elseif e.campionType==EBattleSkillAfterActionType.CampionFront then
if i==0 then
i=t
e.isShow=true
end
end
end
table.insert(a,e)
end
table.sort(a,function(e,t)
return e.orderIndex<t.orderIndex
end)
return a
end
function UIUtil.RefreshEmbattleCampionByHeroData(a,t,e)
local e=UIUtil.GetEmbattleCampionDataByHeroData(e)
UIUtil.RefreshEmbattleCampionWithCampionData(a,t,e)
end
function UIUtil.RefreshEmbattleCampionWithCampionData(a,o,t)
for e=1,#t do
local a=UIUtil.GetChild(a,e-1)
local e=t[e]
UIUtil.SetCampionDataInEmbattle(a,e.campionType,e.isShow and o==FormationType.Pre)
end
end
function UIUtil.GetEmbattleCampionDataByHeroData(t)
local o=0
local i=0
local n={}
for a=1,6 do
local e={
campionType=EBattleSkillAfterActionType.Normal,
isShow=false
}
local t=t[a]
if t and t.heroDid>0 then
local t=d.GetEntity(t.heroDid)
if t then
e.campionType=t.leaderType or 0
local t=false
if e.campionType==EBattleSkillAfterActionType.CampionAfter then
if i==0 then
i=a
e.isShow=true
end
elseif e.campionType==EBattleSkillAfterActionType.CampionFront then
if o==0 then
o=a
e.isShow=true
end
end
end
end
table.insert(n,e)
end
return n
end
function UIUtil.SetCampionDataInEmbattle(e,t,a)
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
if t==EBattleSkillAfterActionType.CampionFront or t==EBattleSkillAfterActionType.CampionAfter then
LuaUtils.SetActive(e["spine_campion"].transform,true)
local e=e["spine_campion"]:GetComponent(typeof(CS.YouYou.UISpineCtr))
if a==true then
e:PlayAnimation(1,"A",true)
else
e:PlayAnimation(1,"A1",true)
end
else
LuaUtils.SetActive(e["spine_campion"].transform,false)
end
end
function UIUtil.GetProfessionIcon(e)
return i("UICommonOther/%s",ProfessionIcons[e])
end
function UIUtil.SetWeaponeCell(t,e)
local t=LuaUtils.GetLuaComBinder(t)
local t=t:GetComponents()
local a
local i
local o=e.itemDid
local a=e.id
local e=j.GetEntity(o)
if a~=nil then
i=EquipMgr:GetEquipServerData(a)
end
GameTools:LoadSpriteWithFullPath(t["IC_icon"],e.icon)
LuaUtils.SetActive(t["root_rankstar3"].transform,e.weaponStar==3)
LuaUtils.SetActive(t["root_rankstar4"].transform,e.weaponStar==4)
LuaUtils.SetActive(t["root_rankstar5"].transform,e.weaponStar==5)
LuaUtils.SetActive(t["root_rankstar6"].transform,e.weaponStar==6)
LuaUtils.SetActive(t["root_rankstar7"].transform,e.weaponStar==7)
end
function UIUtil.RemoveItemCellEffect(e)
local t=LuaUtils.GetLuaComBinder(e)
local e=t:GetComponents()
if e["p_magic"]then
UIUtil.CleanChildrenAndDespawn(e["p_magic"])
end
if e["p_urEff"]then
UIUtil.CleanChildrenAndDespawn(e["p_urEff"])
end
t.UserObjectData=nil
end
function UIUtil.RemoveBicomsItemCellEffect(e,t)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
if e[t]then
UIUtil.RemoveItemCellEffect(e[t].transform)
end
end
function UIUtil.RemoveAllItemCellEffectInScroview(t,e)
local t=UIUtil.GetListViewAllItemAndCache(t)
for a,t in pairs(t)do
UIUtil.RemoveBicomsItemCellEffect(t.transform,e)
end
end
function UIUtil.RemoveAllItemChildCellEffectInScroview(t,e)
local t=UIUtil.GetListViewAllItemAndCache(t)
for a,t in pairs(t)do
local t=LuaUtils.GetLuaComBinder(t)
local t=t:GetComponents()
if t[e]then
local a=LuaUtils.GetChildrenCount(t[e].transform)
if a>0 then
for a=1,a do
local e=UIUtil.GetChild(t[e].transform,a-1)
UIUtil.RemoveItemCellEffect(e.transform)
end
end
end
end
end
function UIUtil.SetItemCell(f,a,s,m)
local i=LuaUtils.GetLuaComBinder(f)
local e=i:GetComponents()
local t
local n
local o=a.itemDid
local h=a.id
local b=false
local v=false
local p=false
local c=false
local u=false
local r=false
local l=false
local k=false
local g=false
local y=false
local z=a.isGoldTree
local q=a.isSeasonEquip
local O=a.isExtAdd
local d=false
if BagUtil.IsCurrency(o)then
t=x.GetEntity(o)
elseif BagUtil.IsActPoint(o)then
t=A.GetEntity(o)
elseif BagUtil.IsItem(o)then
t=w.GetEntity(o)
if a.isPrinting then
t=H.GetEntity(o)
end
if not t then
GameInit.LogError('找不到道具id%d',o)
end
if ModulesInit.BagManager:IsUnderwearItemType(t.type)then
b=true
elseif t.type==PROTO_ENUM.ENUM_ITEM_TYPE.ITEM_TYPE_WEAPON_CHIP then
p=true
elseif t.type==PROTO_ENUM.ENUM_ITEM_TYPE.ITEM_TYPE_GEM then
l=true
elseif t.type==PROTO_ENUM.ENUM_ITEM_TYPE.ITEM_TYPE_BOX_SELECT_ONE then
if a.showSelectBox then
y=true
end
elseif t.type==PROTO_ENUM.ENUM_ITEM_TYPE.ITEM_TYPE_SUIT_GACHA_NEW_COMPOSE then
if a.isEffect then
a.isMagic=1
a.isNormlMagic=true
end
end
if a.isSpEffect then
a.isMagic=1
a.isAdvMagic=true
end
if t.isHideCount==1 then
a.count=nil
end
elseif BagUtil.IsEquip(o)then
t=j.GetEntity(o)
if not t then
GameInit.LogError('找不到装备id%d',o)
else
if t.heroId~=0 then
v=true
end
end
if h then
if h>0 then
n=EquipMgr:GetEquipServerData(h)
end
else
n=a.info
end
if a.isShowEquipLevel==true then
g=true
end
elseif BagUtil.IsUnderwear(o)then
t=_.GetEntity(o)
if h then
n=UnderwearMgr:GetUnderwearServerData(h)
else
n=a.info or{}
end
UIUtil.SetUnderwearCell(e,a,t,n,a.isSquareUnderWear)
return
elseif BagUtil.IsAmuletGift(o)then
t=E.GetEntity(o)
if not t then
GameInit.LogError('找不到护符礼包id%d',o)
end
elseif BagUtil.IsAmulet(o)then
t=T.GetEntity(o)
if not t then
GameInit.LogError('找不到护符id%d',o)
end
if h and h>0 then
local e=AmuletMgr:GetAmuletGroupByAmuletId(h)
if e.amuletId==h then
n=e
end
else
n=a.info
end
if n==nil then
n={starLevel=1}
end
elseif BagUtil.IsTreasure(o)then
t=N.GetEntity(o)
if not t then
GameInit.LogError('找不到宝具id%d',o)
end
c=true
if h then
if h>0 then
n=TreasureMgr:GetTreasureServerData(h)
end
else
n=a.info
end
elseif BagUtil.IsLuxury(o)then
t=S.GetEntity(o)
if not t then
GameInit.LogError('找不到奢侈品id%d',o)
end
u=true
if h then
if h>0 then
n=LuxuryMgr:GetLuxuryServerData(h)
end
else
n=a.info
end
elseif BagUtil.IsCollectibles(o)then
local e=ModulesInit.CollectiblesDetailsMgr:GetCollectiblesInfo(o)
if not e then
GameInit.LogError('找不到收藏品id%d',o)
end
t=e.cfg
r=true
if h then
if h>0 then
n=ModulesInit.CollectiblesDetailsMgr:GetCollectiblesMsgInfoById(h)
end
else
n=a.info
end
elseif BagUtil.IsSummonPetEquip(o)then
t=SummonPetEquipMgr:GetPetEquipCfgByDid(o)
if not t then
GameInit.LogError('找不到召唤兽装备id%d',o)
end
d=true
if h then
if h>0 then
n=SummonPetEquipMgr:GetBagPetEquipInfo(h)
end
else
n=a.info
end
elseif BagUtil.IsActCellSuvivorCollectFakeItem(o)then
t=ModulesInit.ActCellSuvivorGameMgr:GetCollectionCfgById(o)
if not t then
GameInit.LogError('找不到逢魔之时收集物道具id%d',o)
end
k=true
end
if t==nil then return end
if a.isShowSelect==true then
UIUtil.setCellSelected(e,true,true)
else
UIUtil.setCellSelected(e,false)
end
if s then
UIUtil.SetGroupVisible(e["btn_icon"].transform,true)
local t=e["btn_icon"].transform:GetComponent(typeof(CS.YouYou.UIEventListener))
if not t then
t=e["btn_icon"].gameObject:AddComponent(typeof(CS.YouYou.UIEventListener))
end
t.onClick=function()
if s==nil then
return
end
if#s>=2 then
local e={
itemArr=s,
worldPos=f.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
else
s.worldPos=e["btn_icon"].transform.position
UIUtil.ShowItemTip(s)
end
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="ON_CLICK_ITEMTIPS_SUC"})
end
else
UIUtil.SetGroupVisible(e["btn_icon"].transform,false)
end
if e["im_redpoint"]then
UIUtil.SetGroupVisible(e["im_redpoint"].transform,false)
end
if e["btn_jian"]then
UIUtil.SetGroupVisible(e["btn_jian"].transform,false)
end
local s={}
if not a.isPrinting then
s=ModulesInit.BagManager:GetBaseInfo(o)
end
if p or v then
LuaUtils.SetImageSprite(e["im_quality_frame"],"UICommonOther/T_zhuangbeikuang_9",false)
elseif a.isPrinting then
LuaUtils.SetImageSprite(e["im_quality_frame"],UIUtil.GetEquipFramePath(t.rarity),false)
elseif c then
LuaUtils.SetImageSprite(e["im_quality_frame"],UIUtil.GetTreasureFramePath(s.color),false)
elseif u then
LuaUtils.SetImageSprite(e["im_quality_frame"],"UICommonOther/Image_blank",false)
elseif r then
LuaUtils.SetImageSprite(e["im_quality_frame"],UIUtil.GetEquipFramePath(t.color),false)
else
GameTools:SetImageSprite(e["im_quality_frame"],UIUtil.GetEquipFramePath(s.color),false)
end
if b then
if e["im_quality"]then
UIUtil.SetGroupVisible(e["im_quality"].transform,false)
end
else
if s.star and UIUtil.GetEquipSuitStarPath(s.star)and a.star~=""then
LuaUtils.SetImageSprite(e["im_quality"],UIUtil.GetEquipSuitStarPath(s.star),true)
UIUtil.HandlerHeroQualityImgEff(e["im_quality"],s.star,true)
UIUtil.SetGroupVisible(e["im_quality"].transform,true)
else
UIUtil.SetGroupVisible(e["im_quality"].transform,false)
end
end
if IsNil(e["im_petEquip_icon"])==false then
UIUtil.SetGroupVisible(e["im_petEquip_icon"].transform,d==true)
end
if d==true then
local a=t.iconBg==""and"UICommonOther/Image_blank"or t.iconBg
LuaUtils.SetImageSprite(e["im_prop"],a,false)
if IsNil(e["im_petEquip_icon"])==false then
local t=t.icon==""and"UICommonOther/Image_blank"or t.icon
LuaUtils.SetImageSprite(e["im_petEquip_icon"],t,false)
end
else
if a.isPrinting then
LuaUtils.SetImageSprite(e["im_prop"],t.cardImage,false)
else
LuaUtils.SetImageSprite(e["im_prop"],s.icon,false)
end
end
if p or v then
LuaUtils.SetImageSprite(e["im_bg"],"UICommonOther/BG_zhuangbeikuang_9",false)
elseif a.isPrinting then
LuaUtils.SetImageSprite(e["im_bg"],UIUtil.GetEquipBaseboardPath(t.rarity),false)
elseif c then
LuaUtils.SetImageSprite(e["im_bg"],UIUtil.GetTreasureBaseboardPath(s.color),false)
elseif u then
LuaUtils.SetImageSprite(e["im_bg"],UIUtil.GetLuxuryBaseboardPath(s.color),false)
elseif r then
LuaUtils.SetImageSprite(e["im_bg"],UIUtil.GetEquipBaseboardPath(t.color),false)
else
GameTools:SetImageSprite(e["im_bg"],UIUtil.GetEquipBaseboardPath(s.color),false)
end
LuaUtils.SetTextMeshText(e["text_level"],"")
local s=t.level or(n and n.level)
if not c and not u and not r then
if(g or(a.level and a.level~=""))and s then
LuaUtils.SetTextMeshText(e["text_level"],GameTools.GetLocalize("UI.Equip.Common.06",LanguageCategory.LangCommon,s))
end
end
LuaUtils.SetTextMeshText(e["text_qianghua"],"")
if n and n.strength and n.strength>0 then
LuaUtils.SetTextMeshText(e["text_qianghua"],"+"..n.strength)
end
LuaUtils.SetTextMeshText(e["text_num"],"")
if c or u then
if a.level and a.level~=""and a.level>0 then
LuaUtils.SetTextMeshText(e["text_num"],GameTools.GetLocalize("UI.Equip.Common.06",LanguageCategory.LangCommon,a.level))
end
else
if a.count then
if l and a.count>=3 then
LuaUtils.SetTextMeshText(e["text_num"],UIUtil.GetGreenTichText("×"..UIUtil.toBigNum(a.count)))
else
if a.count>0 then
LuaUtils.SetTextMeshText(e["text_num"],"×"..UIUtil.toBigNum(a.count))
elseif a.count<0 then
LuaUtils.SetTextMeshText(e["text_num"],"×".. 0)
elseif a.count==0 then
if a.mustShowCount then
LuaUtils.SetTextMeshText(e["text_num"],UIUtil.GetNewRedTichText("×".. 0))
end
end
end
end
end
if e["im_gem1"]then
for i=PROTO_ENUM.ENUM_GEM_POS.POS1,PROTO_ENUM.ENUM_GEM_POS.POS4 do
local a=false
local s=e["im_gem"..i]
if BagUtil.IsEquip(o)and n and t.heroId==0 then
local t=EquipMgr:GetEquipGemDIdByPos(n,i)
a=t>=0
local e=GemEmptyFrame
if t>0 then
local t=w.GetEntity(t)
e=UIUtil.GetItemIconPath(t.itemIcon)
local t=string.len(e)
local t=string.sub(e,t-4,t)
e=UIUtil.GetItemIconPath("itemicon_"..t.."_small")
end
GameTools:SetImageSprite(s,e,false)
end
UIUtil.SetGroupVisible(s.transform,a)
end
end
if e["im_zhuanwusuipian"]then
local t=BagUtil.IsItem(o)and(t.type==PROTO_ENUM.ENUM_ITEM_TYPE.ITEM_TYPE_WEAPON_CHIP or t.type==PROTO_ENUM.ENUM_ITEM_TYPE.ITEM_TYPE_EQUIP_MAKE_DRAWING_CHIP)
UIUtil.SetGroupVisible(e["im_zhuanwusuipian"].transform,t)
end
local d=function(s,c)
if e["p_magic"]then
local function u(e)
UIUtil.CleanChildrenAndDespawn(e)
end
if s==false then
u(e["p_magic"])
else
local r=true
local d=false
local s=nil
local l=m
if c~=true then
if((n and BagUtil.IsEquip(o))or a.isMagic)then
local e=0
if a.isMagic then
if a.isNormlMagic==true then
e=e+1
end
if a.isAdvMagic==true then
e=e+2
end
else
local t=EquipMgr:getEquipMagicByType(n,1)
if t.level>0 then
e=e+1
end
local t=EquipMgr:getEquipMagicByType(n,2)
if t.level>0 then
e=e+2
end
end
if e==1 then
s=SysPrefabId.EquipMagic1
elseif e==2 then
s=SysPrefabId.EquipMagic2
elseif e==3 then
s=SysPrefabId.EquipMagic3
end
if s then
if i.UserObjectData==nil then
i.UserObjectData={}
end
if i.UserObjectData.p==s then
r=false
else
d=true
end
end
elseif BagUtil.IsTreasure(o)then
if t.specialEffects==1 then
s=SysPrefabId.TreasureEffect1
elseif t.specialEffects==2 then
s=SysPrefabId.TreasureEffect2
elseif t.specialEffects==3 then
s=SysPrefabId.TreasureEffect3
end
if s then
if i.UserObjectData==nil then
i.UserObjectData={}
end
if i.UserObjectData.p==s then
r=false
else
d=true
end
end
elseif BagUtil.IsLuxury(o)then
if t.specialEffects==1 then
s=SysPrefabId.TreasureEffect1
elseif t.specialEffects==2 then
s=SysPrefabId.TreasureEffect2
end
if s then
if i.UserObjectData==nil then
i.UserObjectData={}
end
if i.UserObjectData.p==s then
r=false
else
d=true
end
end
elseif BagUtil.IsCollectibles(o)then
if t.specialEffects==1 then
s=SysPrefabId.TreasureEffect1
elseif t.specialEffects==2 then
s=SysPrefabId.TreasureEffect2
end
if s then
if i.UserObjectData==nil then
i.UserObjectData={}
end
if i.UserObjectData.p==s then
r=false
else
d=true
end
end
end
i.UserObjectData={id=h,p=s,ownPrefabId=s,effectScale=m,ownEffectScale=m}
end
if c==true then
if i.UserObjectData then
if i.UserObjectData.ownPrefabId then
s=i.UserObjectData.ownPrefabId
end
l=i.UserObjectData.ownEffectScale
if i.UserObjectData.p==s then
r=false
elseif s then
d=true
end
i.UserObjectData.p=s
i.UserObjectData.effectScale=l
end
end
if r then
u(e["p_magic"])
end
if d then
u(e["p_magic"])
GameTools:PoolGameObjectSpawn(
s,
nil,
function(t,a,a)
local t=t
LuaUtils.SetParent(t,e["p_magic"])
LuaUtils.SetLocalPos(t,0,0,0)
if l then
local e=t:GetComponent(typeof(CS.Coffee.UIExtensions.UIParticle))
e.scale=l
else
local t=t:GetComponent(typeof(CS.YouYou.UIParticleSizeAdapt))
t.rect=e["im_quality_frame"].transform
end
end
)
end
end
end
end
local h=function(a,l)
if e["p_urEff"]then
local function h(e)
UIUtil.CleanChildrenAndDespawn(e)
end
if a==false then
h(e["p_urEff"])
else
local r=true
local d=false
local a=nil
local s=m
if l~=true then
if((n and BagUtil.IsEquip(o)))then
if t.color==EquipQulity.Gold and n.exclusiveDid~=0 then
a=SysPrefabId.TreasureEffect1
end
if a then
if i.UserObjectData==nil then
i.UserObjectData={}
end
if i.UserObjectData.urp==a then
r=false
else
d=true
end
end
end
if i.UserObjectData then
i.UserObjectData.urp=a
i.UserObjectData.ownURPrefabId=a
end
end
if l==true then
if i.UserObjectData then
if i.UserObjectData.ownURPrefabId then
a=i.UserObjectData.ownURPrefabId
end
s=i.UserObjectData.ownEffectScale
if i.UserObjectData.urp==a then
r=false
elseif a then
d=true
end
i.UserObjectData.urp=a
i.UserObjectData.effectScale=s
end
end
if r then
h(e["p_urEff"])
end
if d then
h(e["p_urEff"])
GameTools:PoolGameObjectSpawn(
a,
nil,
function(t,a,a)
local t=t
LuaUtils.SetParent(t,e["p_urEff"])
LuaUtils.SetLocalPos(t,0,0,0)
if s then
local e=t:GetComponent(typeof(CS.Coffee.UIExtensions.UIParticle))
e.scale=s
else
local t=t:GetComponent(typeof(CS.YouYou.UIParticleSizeAdapt))
t.rect=e["im_quality_frame"].transform
end
end
)
end
end
end
end
if e["im_gematr"]then
UIUtil.SetGroupVisible(e["im_gematr"].transform,l)
if l then
local a=t.gemPos[1]
local t
if a==1 or a==2 or a==6 then
t="UICommonOther/jb_gong"
else
t="UICommonOther/jb_fang"
end
GameTools:SetImageSprite(e["im_gematr"],t,false)
end
end
if e["text_baoshi"]then
UIUtil.SetGroupVisible(e["text_baoshi"].transform,l)
if l then
LuaUtils.SetTextMeshText(e["text_baoshi"],"Lv"..t.itemLv)
end
end
if e["btn_item_seach"]then
UIUtil.SetGroupVisible(e["btn_item_seach"].transform,y)
if y then
local t=e["btn_item_seach"].transform:GetComponent(typeof(CS.YouYou.UIEventListener))
if not t then
t=e["btn_item_seach"].gameObject:AddComponent(typeof(CS.YouYou.UIEventListener))
end
t.onClick=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Item_Select_DescView,{itemDid=o})
end
end
end
if e["im_star_level"]and e["text_star_level"]then
if n and n.starLevel then
UIUtil.SetGroupVisible(e["im_star_level"].transform,true)
LuaUtils.SetTextMeshText(e["text_star_level"],n.starLevel)
else
UIUtil.SetGroupVisible(e["im_star_level"].transform,false)
end
end
if e["im_goldTree"]then
if z and ModulesInit.MagicOrchardMgr:GetGoldTreeIsShow(o)then
UIUtil.SetGroupVisible(e["im_goldTree"].transform,true)
else
UIUtil.SetGroupVisible(e["im_goldTree"].transform,false)
end
end
if e["im_SeasonEquip"]then
LuaUtils.SetActive(e["im_SeasonEquip"].transform,q)
end
if e["im_ExtAdd"]then
LuaUtils.SetActive(e["im_ExtAdd"].transform,O)
end
if e["im_break_1"]then
for o=1,3 do
local i=e["im_break_"..o]
local s=false
if c and o<=t.maxBreakTime then
s=true
local t=false
if a.breakLevel then
if o<=a.breakLevel then
t=true
end
elseif n then
if o<=n.breakLevel then
t=true
end
end
local e=nil
if t then
e=string.format("UICommonOther/%s",TreasureBreakImage)
else
e=string.format("UICommonOther/%s",TreasureBreakImageBg)
end
LuaUtils.SetImageSprite(i,e,false)
elseif u and t then
local t=LuxuryMgr:IsLuxuryGoodsCanBreak(t.id)
if t then
local e=0
if a.breakLevel then
e=a.breakLevel
elseif n then
e=n.breakLevel
end
if e==nil or type(e)~="number"or e<0 then
e=0
end
local e,t=LuxuryMgr:GetLuxuryGoodsBreakStageIconPathAndStageLv(e)
if t<o then
e=LuxuryBreakImageBg
end
LuaUtils.SetImageSprite(i,e,false)
end
s=t==true
end
UIUtil.SetGroupVisible(i.transform,s)
end
end
d(true)
h(true)
if BuildPatchMgr:CanUseLuaMonoBehaviour()then
local e=f.gameObject:GetComponent(typeof(CS.YouYou.LuaMonoBehaviour))
if LuaUtils.IsNull(e)then
e=f.gameObject:AddComponent(typeof(CS.YouYou.LuaMonoBehaviour))
e.CallLua=function(e)
if e=="OnEnable"then
d(true,true)
h(true,true)
elseif e=="OnDisable"then
d(false)
h(false)
if i.UserObjectData then
i.UserObjectData.p=nil
i.UserObjectData.urp=nil
i.UserObjectData.effectScale=nil
end
end
end
end
end
return t
end
function UIUtil.setCellSelected(e,t,a)
if e["im_zhezhao"]then
LuaUtils.SetActive(e["im_zhezhao"].transform,a and true or false)
end
if e["im_duigou"]then
LuaUtils.SetActive(e["im_duigou"].transform,t)
end
if e["im_xuanzhong"]then
LuaUtils.SetActive(e["im_xuanzhong"].transform,false)
end
end
function UIUtil.SetUnderwearCell(e,i,t,a,o)
if o==true then
GameTools:SetImageSprite(e["bg_ditu"],UIUtil.GetEquipBaseboardPath(t.color),false)
GameTools:SetImageSprite(e["im_quality_frame"],UIUtil.GetEquipFramePath(t.color),false)
else
GameTools:SetImageSprite(e["bg_ditu"],UIUtil.GetUnderwearFrame(t.color))
end
GameTools:SetImageSprite(e["im_neiyi"],t.icon)
LuaUtils.SetTextMeshText(e["text_qianghua"],"")
if a.level and a.level>0 then
LuaUtils.SetTextMeshText(e["text_qianghua"],"+"..a.level)
end
local a=t.star
for t=1,3 do
LuaUtils.SetActive(e["im_start"..t].transform,t<=a)
end
LuaUtils.SetActive(e["im_jianhao"].transform,false)
UIUtil.SetGroupVisible(e["btn_icon"].transform,false)
end
function UIUtil.NumericalUnitConvert(e)
if e<=u[1]then
return tostring(e),""
elseif e>=u[2]and e<u[3]then
return g(e/u[2]),l[1]
elseif e>=u[4]then
return g(e/u[4]),l[2]
end
end
function UIUtil.NumericalUnitConvert2(e)
if e<=u[1]then
return tostring(e),""
elseif e>=u[2]and e<u[3]then
return UIUtil.FormatNum(e/u[2]),l[1]
elseif e>=u[4]then
return UIUtil.FormatNum(e/u[4]),l[2]
end
end
function UIUtil.FormatNum(e,t)
if t then
if e<0 then
return e
else
local a,t=math.modf(e)
if t>0 then
return e
else
return a
end
end
else
if e<=0 then
return 0
else
local a,t=math.modf(e)
if t>0 then
return e
else
return a
end
end
end
end
function UIUtil.NumTrim(e)
return UIUtil.toBigNum(e)
end
function UIUtil.toBigNum(t,o,a)
a=a or""
local e=t;
if t>=10000000000 then
e=math.floor(t/100000000)..l[2];
e=e..a
elseif t>=100000000 then
local o=t%100000000
e=math.floor(t/100000000)..l[2];
if o>=10000 then
e=e..math.floor(o/10000)..l[1]
end
e=e..a
else
o=o or 100000
if t>=o then
e=math.floor(t/10000)..l[1]
e=e..a
end
end
return e;
end
function UIUtil.toBigNum2(o)
local a=""
local t={}
if o>999 then
function numToStr(o)
local e=o%1000
local o=math.floor(o/1000)
if o>0 then
if e==0 then
e="000"
elseif e<10 then
e="00"..e
elseif e<100 then
e="0"..e
end
table.insert(t,e)
numToStr(o)
else
table.insert(t,e)
for e=#t,1,-1 do
if e==#t then
a=t[e]
else
a=a..","..t[e]
end
end
end
end
numToStr(o)
return a
else
return o;
end
end
function UIUtil.toBigNum3(t,o,a)
a=a or""
local e=t;
if t>=1000000000 then
e=math.floor(t/100000000)..l[2];
e=e..a
elseif t>=100000000 then
local o=t%100000000
e=math.floor(t/100000000)..l[2];
if o>=1000000 then
e=e..math.floor(o/10000)..l[1]
end
e=e..a
else
o=o or 1000000
if t>=o then
e=math.floor(t/10000)..l[1]
e=e..a
end
end
return e;
end
function UIUtil.toBigNum4(e,a,o)
o=o or""
local t=e;
a=a or 100000
if e>=a then
if e%10000==0 then
t=math.floor(e/10000)..l[1]
else
t=(e/10000)..l[1]
end
t=t..o
end
return t;
end
function UIUtil.SetGray2(e,t,a)
local e=LuaUtils.GetChildrenImages(e)
for o=1,#e do
local e=e[o]
if e.transform.tag~=a then
if t then
e.material=GameInit.Gray
else
e.material=nil
end
end
end
end
function UIUtil.SetGray(a,t,o,i)
local e=LuaUtils.GetChildrenImages(a)
for a=1,#e do
local e=e[a]
if t then
e.material=GameInit.Gray
else
e.material=nil
end
if o then
LuaUtils.SetGraphicRaycastTarget(e,not t)
end
end
if not i then
local e=LuaUtils.GetChildrenTMPs(a)
for a=1,#e do
local e=e[a]
if t then
local t=tostring(e.font)
if string.find(t,"EPM")then
UIUtil.SetFontMaterial(e,GameInit.GrayFont2)
elseif string.find(t,"num")then
UIUtil.SetFontMaterial(e,GameInit.GrayFont3)
else
UIUtil.SetFontMaterial(e,GameInit.GrayFont)
end
else
UIUtil.SetFontMaterial(e)
end
end
end
end
function UIUtil.SetFontMaterial(e,a)
local t=e.gameObject:GetComponent(typeof(CS.LuaComponentBinder.LuaComBinder))
if t==nil then
t=e.gameObject:AddComponent(typeof(CS.LuaComponentBinder.LuaComBinder))
t.UserObjectData=e.fontMaterial
end
if a==nil then
if t.UserObjectData~=nil then
e.fontMaterial=t.UserObjectData
end
else
e.fontMaterial=a
end
end
function UIUtil.SetGray3(a,t,i,o)
local e=LuaUtils.GetChildrenImages(a)
for a=1,#e do
local e=e[a]
if t then
e.material=GameInit.Gray_for_kr1101
else
e.material=nil
end
if i then
LuaUtils.SetGraphicRaycastTarget(e,not t)
end
end
if not o then
local e=LuaUtils.GetChildrenTMPs(a)
for a=1,#e do
local e=e[a]
if t then
local t=tostring(e.font)
if string.find(t,"EPM")then
UIUtil.SetFontMaterial(e,GameInit.GrayFont2)
elseif string.find(t,"num")then
UIUtil.SetFontMaterial(e,GameInit.GrayFont3)
else
UIUtil.SetFontMaterial(e,GameInit.GrayFont)
end
else
UIUtil.SetFontMaterial(e)
end
end
end
end
function UIUtil.SetGray4(i,t,n,s,o)
local e=LuaUtils.GetChildrenImages(i)
for a=1,#e do
local e=e[a]
local a=true
for o,t in pairs(o)do
if t==e.transform then
a=false
end
end
if a then
if t then
e.material=GameInit.Gray
else
e.material=nil
end
end
if n then
LuaUtils.SetGraphicRaycastTarget(e,not t)
end
end
if not s then
local e=LuaUtils.GetChildrenTMPs(i)
for a=1,#e do
local e=e[a]
local a=true
for o,t in pairs(o)do
if t==e.transform then
a=false
end
end
if a then
if t then
local t=tostring(e.font)
if string.find(t,"EPM")then
UIUtil.SetFontMaterial(e,GameInit.GrayFont2)
elseif string.find(t,"num")then
UIUtil.SetFontMaterial(e,GameInit.GrayFont3)
else
UIUtil.SetFontMaterial(e,GameInit.GrayFont)
end
end
else
UIUtil.SetFontMaterial(e)
end
end
end
end
function UIUtil.SetGray4(a,t,n,i,o)
local e=LuaUtils.GetChildrenImages(a)
for a=1,#e do
local e=e[a]
local a=true
for o,t in pairs(o)do
if t==e.transform then
a=false
end
end
if a then
if t then
e.material=GameInit.Gray
else
e.material=nil
end
end
if n then
LuaUtils.SetGraphicRaycastTarget(e,not t)
end
end
if not i then
local e=LuaUtils.GetChildrenTMPs(a)
for a=1,#e do
local e=e[a]
local a=true
for o,t in pairs(o)do
if t==e.transform then
a=false
end
end
if a then
if t then
local t=tostring(e.font)
if string.find(t,"EPM")then
LuaUtils.SetFont(e,GameInit.GrayFont2)
elseif string.find(t,"num")then
LuaUtils.SetFont(e,GameInit.GrayFont3)
else
LuaUtils.SetFont(e,GameInit.GrayFont)
end
else
LuaUtils.SetFont(e)
end
end
end
end
end
function UIUtil.SetGrayByFont(e,t,a,o)
UIUtil.SetGray(e,t,a,false)
end
function UIUtil.SetSpriteRenderGray(e,a)
local e=LuaUtils.GetChildrenSpriteRenders(e)
for t=1,#e do
if a then
e[t].material=GameInit.Gray
else
e[t].material=GameInit.SpriteDefaultMat
end
end
end
function UIUtil.SetSpriteRenderGray2(e,t)
if t then
e.material=GameInit.Gray
else
e.material=nil
end
end
function UIUtil.SetSpineRenderGray(e,t)
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if not e then
return
end
if t then
e.material=GameInit.GraySpine
else
e.material=GameInit.SpineDefaultMat
end
end
function UIUtil.GetPaintingBg(e)
if GameTools:IsReview()then
return"Assets/Download/UICommonBg/UICommonBG8/noalphabg_NeiyiBG_02.png"
else
local e=UIUtil.GetHeroModelId(e)
local e=r.GetEntity(e)
return string.format("Assets/Download/RolePrefabsAndRes/PaintingPrefabAndRes/%d/%s.png",e.id,e.paintingBg)
end
end
function UIUtil.GetProfessionPath(e)
return i("UICommonOther/%s",ProfessionIcons[e])
end
function UIUtil.GetEquipFramePath(e)
return i("UICommonOther/%s",EquipQuailtyBgs[e])
end
function UIUtil.GetEquipBaseboardPath(e)
return i("UICommonOther/%s",EquipQuailtyBaseboard[e])
end
function UIUtil.GetTreasureFramePath(e)
return i("UICommonOther/%s",TreasureQuailtyBgs[e])
end
function UIUtil.GetTreasureBaseboardPath(e)
return i("UICommonOther/%s",TreasureQuailtyBaseboard[e])
end
function UIUtil.GetLuxuryBaseboardPath(e)
return i("UICommonOther/%s",LuxuryQuailtyBaseboard[e])
end
function UIUtil.GetEquipGemEffects(e)
return EquipGemEffects[e]
end
function UIUtil.GetEquipSuitStarPath(e,t)
if e==Quality.SSR then
if t==1 then
return"UICommonOther/IC_SSRS"
end
end
if CardQuailtyFont[e]then
return i("UICommonOther/%s",CardQuailtyFont[e])
else
return nil
end
end
function UIUtil.GetSkillIconPath(e)
return e
end
function UIUtil.getBagInfoBg(e)
return i("UIBag/%s",BagInfoBg[e])
end
function UIUtil.getBagTreasureInfoBg(e)
if e<EquipQulity.Orange then
e=EquipQulity.Orange
end
return i("UIBag/%s",BagInfoBg[e])
end
function UIUtil.GetTeamSpinePool(e,t,o,a,i)
local e=d.GetEntity(e)
return UIUtil.GetPlayerBigSpine(e.modelID,t,o,a,i)
end
function UIUtil.GetPlayerBigSpine(t,o,a,s,i)
if i==nil then
i=true
end
local e=r.GetEntity(t)
if not e then
e=UIUtil.GetHeroModelCfgData(t)
end
if not e then
GameInit.LogError('找不到model:%d',t)
end
local t=e.painting
GameTools:PoolGameObjectSpawn(
t,
nil,
function(t,n,n)
LuaUtils.SetParent(t,o)
LuaUtils.SetLocalEulerAngles(t,0,0,0)
if a then
local i=e[a][1]
local s=e[a][2]
local h=e[a][3]
local n=0
local o=1
if a=='herodivinationPara'then
o=e[a][4]
if e[a][5]then
n=e[a][5]
end
else
if e[a][4]then
o=-1
end
end
LuaUtils.SetLocalPos(t,s,h,0)
LuaUtils.SetLocalScale(t,i*o,i,i)
LuaUtils.SetLocalRotation(t,0,0,n)
else
LuaUtils.SetLocalPos(t,0,0,0)
LuaUtils.SetLocalScale(t,1,1,1)
end
LuaUtils.SetLayer(t,"UI")
local e=t:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
if i then
local t
t=function(o)
local a="A"
if o=="A"then
a="A1"
end
return e:PlayAnimation(0,a,false,t)
end
local a="A"
e:PlayAnimation(0,a,false,t)
else
local t="A"
e:PlayAnimation(0,t,true)
end
local e=t
if s then
s(e)
end
end
)
end
function UIUtil.PlaySpineA1(e)
local t=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
local e
e=function(o)
local a="A"
if o=="A"then
a="A1"
end
return t:PlayAnimation(0,a,false,e)
end
local a="A1"
t:PlayAnimation(0,a,false,e)
end
function UIUtil.GetPlayerUnderwearSpine(e,o,t,n)
local a=UIUtil.GetHeroModelCfgData(e)
local e=a.painting2
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,i,i)
LuaUtils.SetParent(e,o)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
if t then
local o=a[t][1]
local s=a[t][2]
local n=a[t][3]
local i=1
if a[t][4]then
i=-1
end
LuaUtils.SetLocalPos(e,s,n,0)
LuaUtils.SetLocalScale(e,o*i,o,o)
else
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
end
LuaUtils.SetLayer(e,"UI")
local e=e
if n then
n(e)
end
end
)
end
function UIUtil.ResetUISpineBaseData(e)
if not IsNil(e)then
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e then
e.uihide=false
e.timeScale=1
end
end
end
function UIUtil.GetUrBackPlayerBigSpineAll(e,a,o,n,i)
if i==nil then
i=true
end
local e=d.GetEntity(e)
local e=r.GetEntity(e.modelID)
local t=e.paintingGroup
local s=e.paintingGroup_A2
local s=e.paintingGroup_A2_front
GameEntry.Pool:GameObjectSpawn(
t,
nil,
function(t,s,s)
LuaUtils.SetParent(t,a)
LuaUtils.SetLocalPos(t,0,0,0)
LuaUtils.SetLocalEulerAngles(t,0,0,0)
local a=t:Find("Painting_"..e.id)
if o then
local t=e[o][1]
local s=e[o][2]
local n=e[o][3]
local i=1
if e[o][4]then
i=-1
end
LuaUtils.SetLocalPos(a,s,n,0)
LuaUtils.SetLocalScale(a,t*i,t,t)
else
LuaUtils.SetLocalPos(a,0,0,0)
LuaUtils.SetLocalScale(a,1,1,1)
end
LuaUtils.SetLayer(t,"UI")
local o=a:GetComponent(typeof(CS.YouYou.UISpineCtr))
o:SetToSetupPose()
o:ClearTracks()
if i then
local e
e=function(a)
local t="A"
if a=="A"then
t="A1"
end
return o:PlayAnimation(0,t,false,e)
end
local t="A"
o:PlayAnimation(0,t,false,e)
else
local e="A"
o:PlayAnimation(0,e,true)
end
UIUtil.ResetUISpineBaseData(a)
local o=t:Find("Painting_"..e.id.."_back")
if o then
local e=o:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
if i then
local t
t=function(a)
local o="A"
if a=="A"then
end
return e:PlayAnimation(0,o,false,t)
end
local a="A"
e:PlayAnimation(0,a,false,t)
else
local t="A"
e:PlayAnimation(0,t,true)
end
else
end
local o=t:Find("Painting_"..e.id.."_front")
if o then
LuaUtils.SetActive(t:Find("Painting_"..e.id.."_front"),true)
local e=o:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
if i then
local t
t=function(o)
local a="A"
if o=="A"then
end
return e:PlayAnimation(0,a,false,t)
end
local a="A"
e:PlayAnimation(0,a,false,t)
else
local t="A"
e:PlayAnimation(0,t,true)
end
end
local e=t
if n then
n(e,a)
end
end
)
end
function UIUtil.GetHeroModelId(t)
local e
if PlayerMgr:IsLordProfile(t)then
local t=PlayerMgr:GetProfileCfgData(t)
e=t.profile
else
local t=d.GetEntity(t)
e=t.modelID
end
return e
end
function UIUtil.GetPlayerBigSpineAll(e,a,i,n,o)
if o==nil then
o=true
end
local e=UIUtil.GetHeroModelId(e)
local e=r.GetEntity(e)
local t=e.paintingGroup
local s=e.paintingGroup_A2
local h=e.paintingGroup_A2_front
GameTools:PoolGameObjectSpawn(
t,
nil,
function(t,r,r)
LuaUtils.SetParent(t,a)
LuaUtils.SetLocalPos(t,0,0,0)
LuaUtils.SetLocalEulerAngles(t,0,0,0)
local a=t:Find("Painting_"..e.id)
if i then
local t=e[i][1]
local s=e[i][2]
local n=e[i][3]
local o=1
if e[i][4]then
o=-1
end
LuaUtils.SetLocalPos(a,s,n,0)
LuaUtils.SetLocalScale(a,t*o,t,t)
else
LuaUtils.SetLocalPos(a,0,0,0)
LuaUtils.SetLocalScale(a,1,1,1)
end
LuaUtils.SetLayer(t,"UI")
local i=a:GetComponent(typeof(CS.YouYou.UISpineCtr))
i:SetToSetupPose()
i:ClearTracks()
if o then
local t
t=function(a)
local e="A"
if a=="A"then
e="A1"
if s==2 then
e="A2"
end
end
return i:PlayAnimation(0,e,false,t)
end
local e="A"
i:PlayAnimation(0,e,false,t)
else
local e="A"
i:PlayAnimation(0,e,true)
end
UIUtil.ResetUISpineBaseData(a)
local i=t:Find("Painting_"..e.id.."_back")
if i then
local e=i:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
if o then
local t
t=function(o)
local a="A"
if o=="A"then
if s==2 then
a="A2"
end
end
return e:PlayAnimation(0,a,false,t)
end
local a="A"
e:PlayAnimation(0,a,false,t)
else
local t="A"
e:PlayAnimation(0,t,true)
end
else
end
local i=t:Find("Painting_"..e.id.."_front")
if i then
LuaUtils.SetActive(t:Find("Painting_"..e.id.."_front"),true)
local e=i:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:SetToSetupPose()
e:ClearTracks()
if o then
local t
t=function(o)
local a="A"
if o=="A"then
if h==2 then
a="A2"
end
end
return e:PlayAnimation(0,a,false,t)
end
local a="A"
e:PlayAnimation(0,a,false,t)
else
local t="A"
e:PlayAnimation(0,t,true)
end
end
local e=t
if n then
n(e,a)
end
end
)
end
function UIUtil.GetPlayerBigSpineAllHeroShow(t,i,n,l,s,h,o,u,e)
if h==nil then
h=true
end
local t=d.GetEntity(t)
local a=r.GetEntity(t.modelID)
local t=a.paintingGroup
local r=a.paintingGroup_A2
local d=a.paintingGroup_A2_front
GameTools:PoolGameObjectSpawn(
t,
nil,
function(t,c,c)
LuaUtils.SetParent(t,i)
LuaUtils.SetLocalPos(t,0,0,0)
LuaUtils.SetLocalEulerAngles(t,0,0,0)
local i=t:Find("Painting_"..a.id)
if n then
local e=a[n][1]
local s=a[n][2]
local o=a[n][3]
local t=1
if a[n][4]then
t=-1
end
LuaUtils.SetLocalPos(i,s,o,0)
LuaUtils.SetLocalScale(i,e*t,e,e)
else
LuaUtils.SetLocalPos(i,0,0,0)
LuaUtils.SetLocalScale(i,1,1,1)
end
LuaUtils.SetLayer(t,"UI")
if l then
l()
end
local n=i:GetComponent(typeof(CS.YouYou.UISpineCtr))
n:SetToSetupPose()
n:ClearTracks()
if h then
if not o then
o="A"
end
n:PlayAnimation(0,o,false,function()
if o=="in"then
return n:PlayAnimation(0,"A",true)
elseif o=="A"then
local e="A1"
if r==2 then
e="A2"
end
return n:PlayAnimation(0,e,false)
end
end)
else
if not o then
o="A"
end
n:PlayAnimation(0,o,true)
end
UIUtil.ResetUISpineBaseData(i)
if u then
local o=t:Find("Painting_"..a.id.."_back")
local o=o:GetComponent(typeof(CS.YouYou.UISpineCtr))
o:SetToSetupPose()
o:ClearTracks()
if not e then
e="A"
o:PlayAnimation(0,e,true)
else
if not e then
e="A"
end
if e=="in"then
o:PlayAnimation(0,e,false,function()
if e=="in"then
if s then
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(
0,
1,
1,
nil,
nil,
function()
s(t,i)
end
)
e:Run()
end
o:PlayAnimation(0,"A",true)
end
end)
else
if s then
s(t,i)
end
if h then
o:PlayAnimation(0,e,false,function()
if e=="A"then
local e="A"
if r==2 then
e="A2"
end
o:PlayAnimation(0,e,false)
end
end)
else
o:PlayAnimation(0,"A",true)
end
end
end
local t=t:Find("Painting_"..a.id.."_front")
if t then
local t=t:GetComponent(typeof(CS.YouYou.UISpineCtr))
t:SetToSetupPose()
t:ClearTracks()
if not e then
e="A"
t:PlayAnimation(0,e,true)
else
if not e then
e="A"
end
if e=="in"then
t:PlayAnimation(0,e,false,function()
if e=="in"then
if s then
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(
0,
1,
1,
nil,
nil,
function()
end
)
e:Run()
end
t:PlayAnimation(0,"A",true)
end
end)
else
if h then
t:PlayAnimation(0,e,false,function()
if e=="A"then
local e="A"
if d==2 then
e="A2"
end
t:PlayAnimation(0,e,false)
end
end)
else
o:PlayAnimation(0,"A",true)
end
end
end
end
end
local e=t
end
)
end
function UIUtil.SpinePoolDespawnAll(t,e)
if(not IsNil(t))then
GameEntry.Pool:GameObjectDespawn(t)
if e==nil then
e=t
end
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
local a=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
if a then
a:StopAnimation()
a:ClearComplete()
else
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if e then
e.AnimationState:SetEmptyAnimation()
end
end
UIUtil.SetSpineRenderGray(e,false)
e=nil
t=nil
end
end
function UIUtil.PreloadLive2dRes(t,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_Live2dPreload,{heroDid=t,callback=e})
end
local e=9990000
function UIUtil.GetLive2dModel(i,o,s,n,a)
if not GameTools:ClientIsSupportLive2D()then
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,t,t)
if o then
LuaUtils.SetParent(e,o)
end
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLayer(e,"UI")
local t=LuaUtils.GetLuaComBinder(e)
local t=t:GetComponents()
if s then
local e=d.GetEntity(n)
local e=r.GetEntity(e.modelID)
GameTools:SetImageSprite(t["im_bg"],e.tujianUnlockMarryBg)
else
end
if CS.UnityEngine.Application.platform==CS.UnityEngine.RuntimePlatform.Android then
LuaUtils.SetActive(t["messageBox"].transform,true)
t["btn_ok"].onClick:RemoveAllListeners()
t["btn_ok"].onClick:AddListener(
function()
ModulesInit.ScoreManager:ToPhoneUpVersion()
end
)
local e=e
if a then
a(e,nil)
end
else
LuaUtils.SetActive(t["messageBox"].transform,false)
end
end
)
else
local e=function()
GameTools:PoolGameObjectSpawn(
i,
nil,
function(e,t,i)
if o then
LuaUtils.SetParent(e,o)
end
local o=LuaUtils.GetChild(e,1)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLayer(e,"UI")
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalScale(o,1,1,1)
if t then
local a=0
local t=0
local e=e:Find("live2d_Canvas")
local e=e:Find("cannot_Img")
if e then
a,t=LuaUtils.GetScreenWidthAndHeight(a,t)
e.anchoredPosition=Vector2(-a/2,-t/2)

end
end
local e=e
if a then
a(e,o)
end
end
)
end
if s then
DynamicModuleRes.CheckResAndDownload({[10]={n}},e)
else
DynamicModuleRes.loadPrefabsABAssets({i},e)
end
end
end
local e=9990000
function UIUtil.GetPlayerLive2dModel(o,i,a,n)
if not GameTools:ClientIsSupportLive2D()then
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,t,t)
if i then
LuaUtils.SetParent(e,i)
end
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLayer(e,"UI")
local t=LuaUtils.GetLuaComBinder(e)
local t=t:GetComponents()
local a=d.GetEntity(o)
local a=r.GetEntity(a.modelID)
LuaUtils.SetImageSprite(t["im_bg"],a.tujianUnlockMarryBg)
if CS.UnityEngine.Application.platform==CS.UnityEngine.RuntimePlatform.Android then
LuaUtils.SetActive(t["messageBox"].transform,true)
t["btn_ok"].onClick:RemoveAllListeners()
t["btn_ok"].onClick:AddListener(
function()
ModulesInit.ScoreManager:ToPhoneUpVersion()
end
)
else
LuaUtils.SetActive(t["messageBox"].transform,false)
end
local e=e
if n then
n(e,nil)
end
end
)
else
DynamicModuleRes.CheckResAndDownload(
{
[10]={o}
},
function()
local e=d.GetEntity(o)
local t=r.GetEntity(e.modelID)
local e=t.live2d
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,s,h)
if i then
LuaUtils.SetParent(e,i)
end
local o=e:Find("Live2d_"..o)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLayer(e,"UI")
if a then
local i=t[a][1]
local n=t[a][2]
local t=t[a][3]
LuaUtils.SetLocalPos(e,n,t,0)
LuaUtils.SetLocalScale(o,i,i,i)
else
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalScale(o,1,1,1)
end
if s then
local a=0
local t=0
local e=e:Find("live2d_Canvas")
local e=e:Find("cannot_Img")
if e then
a,t=LuaUtils.GetScreenWidthAndHeight(a,t)
e.anchoredPosition=Vector2(-a/2,-t/2)
end
end
local e=e
if n then
n(e,o)
end
end
)
end
)
end
end
function UIUtil.Live2dPoolDespawnAll(t,e)
if(not IsNil(t))then
GameEntry.Pool:GameObjectDespawn(t)
if e==nil then
e=t
end
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
local a=e:GetComponent(typeof(CS.YouYou.Live2DHelper))
if a then
a:SetDepth(0)
end
e=nil
t=nil
end
end
function UIUtil.GetHeroModelCfgData(t)
local a=d.GetEntity(t)
local e=nil
if a==nil then
e=r.GetEntity(t)
else
e=r.GetEntity(a.modelID)
end
return e
end
function UIUtil.GetUISmallSpinePool(a,i,e,o,t)
if e==nil then
e=0
end
local n=d.GetEntity(a)
local a=UIUtil.GetHeroModelCfgData(a)
if t and t>0 then
local e=ModulesInit.HeroSymphonyMgr:GetHeroSymphonyCfg(t)
a=r.GetEntity(e.modelID)
end
UIUtil.GetUISmallSpinePoolByModel(a,i,e,o)
end
function UIUtil.GetUISmallSpinePoolByModel(t,a,n,e)
if e==nil then
e=false
end
if e then
local e=t.prefabId
return UIUtil.GetSpinePrefabFromPool(e,function(e,h,s)
local o=nil
local t=nil
o=e
local i=e:Find("pet_root")
if i then
t=LuaUtils.GetChild(e:Find("pet_root"),0)
end
if t then
LuaUtils.SetActive(i,n>0)
end
if a then
a(e,o,t,h,s)
end
end)
else
local i=t.prefabUiGroupId>0
local e=i and t.prefabUiGroupId or t.prefabUiId
return UIUtil.GetSpinePrefabFromPool(e,function(t,h,s)
local o=nil
local e=nil
if i then
o=LuaUtils.GetChild(t:Find("hero_root"),0)
e=LuaUtils.GetChild(t:Find("pet_root"),0)
else
o=t
end
if e then
LuaUtils.SetActive(e,n>0)
end
if a then
a(t,o,e,h,s)
end
end)
end
end
function UIUtil.GetPetSpine(e)
if not IsNil(e)then
local t=e:Find("pet_root")
if t~=nil then
local e=LuaUtils.GetChild(e:Find("pet_root"),0)
return e
end
end
return nil
end
function UIUtil.GetSmallUISpinePool(e,t)
local e=d.GetEntity(e)
local e=r.GetEntity(e.modelID)
return UIUtil.GetSpinePrefabFromPool(e.prefabUiId,t)
end
function UIUtil:getStoryPaintingPrefabId(e)
local e=d.GetEntity(e)
local e=r.GetEntity(e.modelID)
local e=e.storyPainting
return e
end
function UIUtil.getBigSpinePrefabId(e)
local e=d.GetEntity(e)
local e=r.GetEntity(e.modelID)
local e=e.paintingGroup
return e
end
function UIUtil.GetSmallSpinePrefabFromPool(e,o,t,i,a)
t=t or 1
a=a or"idle"
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,n,n)
local n=e
LuaUtils.SetActive(e,true)
LuaUtils.SetParent(e,o)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
local t=t*50
LuaUtils.SetLocalScale(e,t,t,t)
local t=o:GetComponent(typeof(CS.UnityEngine.Canvas)).sortingOrder
LuaUtils.SetMeshRenderer(e,t)
LuaUtils.SetLayer(e,LayerName.UI)
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
e.skeleton:SetToSetupPose()
e.state:ClearTracks()
e.AnimationState:SetAnimation(0,a,true)
if i then
i(n)
end
end
)
end
function UIUtil.handleSpineScaleParam(o,a,e,t)
local o=d.GetEntity(o)
local o=r.GetEntity(o.modelID)
if e then
local e=o[e]
e=e*t
LuaUtils.SetLocalScale(a,e,e,e)
else
LuaUtils.SetLocalScale(a,t,t,t)
end
end
function UIUtil.GetSpinePrefabFromPool(t,e)

GameTools:PoolGameObjectSpawn(
t,
nil,
function(t,o,a)
local t=t
if e then
e(t,o,a)
end
end
)
end
function UIUtil.GetSpineOffsetXY(t,e)
local a=t or 1
local o=0
local t=0
if e then
o=a*(e[2]or 0)
t=a*(e[3]or 0)
end
return o,t
end
function UIUtil.HandlePoolSpinePrefab(e,o,t)
local a=t.scale or 1
local n,i=UIUtil.GetSpineOffsetXY(a,t.offsetParam)
local s=t.addSortingOrder or 10
local h=e
LuaUtils.SetParent(e,o)
LuaUtils.SetActive(e,true)
LuaUtils.SetLocalPos(e,n,i,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalScale(e,a,a,a)
local a=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if a then
local o=o:GetComponent(typeof(CS.UnityEngine.Canvas)).sortingOrder
LuaUtils.SetMeshRenderer(e,o+s)
LuaUtils.SetLayer(e,LayerName.UI)
local e=t.animName or"idle"
a.skeleton:SetToSetupPose()
a.state:ClearTracks()
if a.AnimationState then
a.AnimationState:SetAnimation(0,e,true)
end
else
local a=t.animName or"A"
local t=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
if t then
t:SetToSetupPose()
t:ClearTracks()
t:PlayAnimation(0,a,true)
else
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e then
e.AnimationState:ClearTracks()
e.AnimationState:SetAnimation(0,a,true)
end
end
LuaUtils.SetLayer(e,"UI")
end
end
function UIUtil.HandlePoolUISmallRolePrefab(a,n,o,d,e)
local t=e.scale or Vector3.one
local r=e.petScale or Vector3.one
local s=e.localPos or Vector3.zero
local h=e.timeScale or 1
local i=true
if e.playAnim then
i=e.playAnim
end
LuaUtils.SetParent(a,d)
LuaUtils.SetActive(a,true)
LuaUtils.SetLocalEulerAngles(a,0,0,0)
LuaUtils.SetLocalPos(a.transform,s.x,s.y,0)
LuaUtils.SetLocalScale(a.transform,t.x,t.y,t.z)
local s=e.animName or"stand"
local t=n:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if t==nil then
t=n:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
t.skeleton:SetToSetupPose()
t.state:ClearTracks()
else
t.AnimationState:ClearTracks()
end
if i then
t.AnimationState:SetAnimation(0,s,true)
end
t.AnimationState.TimeScale=h
if o then
o.localScale=r
local t=e.animName_pet or"stand"
local e=o:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e==nil then
e=o:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
e.skeleton:SetToSetupPose()
e.state:ClearTracks()
else
e.AnimationState:ClearTracks()
end
if i then
e.AnimationState:SetAnimation(0,t,true)
end
e.AnimationState.TimeScale=h
end
LuaUtils.SetLayer(a,"UI")
end
function UIUtil.SetMultipTipsSpine(t,i,e,o,a,n)
if e==nil or e==""or e=="0"then
LuaUtils.SetActive(t.transform,false)
else
LuaUtils.SetActive(t.transform,true)
UIUtil.SpineCheckPlayAnimation(t.transform,i,e,o,a,n)
end
end
function UIUtil.SpineCheckPlayAnimation(e,a,t,i,o,n)
local s=UIUtil.GetCurAnimName(e,a)
if s~=t then
UIUtil.SpinePlayAnimation(e,a,t,i,o,n)
end
end
function UIUtil.SpinePlayAnimation(e,i,a,t,h,n,s)
if e then
local o=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if o and o.AnimationState then
o.AnimationState:SetAnimation(i,a,t)
else
local o=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
if o then
o:PlayAnimation(i,a,t,h,n)
else
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e then
if(not IsNil(e.AnimationState))then
e.AnimationState:SetAnimation(0,a,t)
else
GameInit.LogErrorAndUpdate("SpinePlayAnimation = "..tostring(s))
end
end
end
end
end
end
function UIUtil.SpineSetAnimSkipDelta(t,o,e)
e=e or 0
if t then
local a=t:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if a and a.AnimationState then
local e=a.AnimationState:GetCurrent(e)
if e then
e.AnimationStart=o
end
else
local t=t:GetComponent(typeof(CS.YouYou.UISpineCtr))
if t then
t:SetAnimSkipDelta(o,e)
end
end
end
end
function UIUtil.GetPrefabFromPool(t,e)
GameTools:PoolGameObjectSpawn(
t,
nil,
function(t,o,a)
local i=t
if e then
e(t,o,a)
end
end
)
end
function UIUtil.HandlePoolPrefab(e,a,t)
local t=t.scale or 1
local o=e
LuaUtils.SetActive(e,true)
LuaUtils.SetParent(e,a)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalScale(e,t,t,t)
LuaUtils.SetLayer(e,LayerName.UI)
end
function UIUtil.SpinePoolDespawn(e)
if(not IsNil(e))then
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
local t=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
if t then
t:StopAnimation()
t:ClearComplete()
else
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if e then
e.AnimationState:SetEmptyAnimation()
end
end
UIUtil.SetSpineRenderGray(e,false)
GameEntry.Pool:GameObjectDespawn(e)
e=nil
end
end
function UIUtil.SmallSpinePoolDespawn(e)
if e==nil then
return
end
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalEulerAngles(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
local a=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
local t=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if a then
a.AnimationState:SetEmptyAnimation()
UIUtil.SetSpineRenderGray(a.transform,false)
end
if t then
t.AnimationState:SetEmptyAnimation()
UIUtil.SetSpineRenderGray(t.transform,false)
end
local a=e:Find("hero_root")
local t=e:Find("pet_root")
if a then
local e=LuaUtils.GetChild(a,0)
if e then
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
e.AnimationState:SetEmptyAnimation()
UIUtil.SetSpineRenderGray(e.transform,false)
end
end
if t then
local t=LuaUtils.GetChild(t,0)
if t then
local e=t:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
local t=t:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e then
e.AnimationState:SetEmptyAnimation()
UIUtil.SetSpineRenderGray(e.transform,false)
end
if t then
t.AnimationState:SetEmptyAnimation()
UIUtil.SetSpineRenderGray(t.transform,false)
end
end
end
GameEntry.Pool:GameObjectDespawn(e)
e=nil
end
function UIUtil.SetPlayerBattleHead(o,e,a)
if e and e~=0 then
local t=c.GetEntity(e)
if not t then
GameEntry.LogError("找不到头像信息:",e)
return
end
local e=string.gsub(
t.head,
"UIHeroHead/UIHeroHead_1/",
function(e)
return"UIHeroHeadBattle/battle"
end
)
GameTools:SetImageSprite(o,i("%s",tostring(e)),false)
return
end
if a then
local e=string.gsub(
a,
"UIHeroHead_1/",
function(e)
return"UIHeroHeadBattle/battle"
end
)
GameTools:SetImageSprite(o,i("%s",e),false)
end
end
function UIUtil.SetPlayerHead(t,e,a)
if e and e~=0 then
local a=c.GetEntity(e)
if not a then
GameEntry.LogError("找不到头像信息:",e)
return
end
GameTools:SetImageSprite(t,i("%s",a.head),false)
return
end
if a then
GameTools:SetImageSprite(t,i("UIHeroHead/%s",a),false)
end
end
function UIUtil.GetPlayerHead(a)
local e=c.GetList()
for t=1,#e do
if e[t].heroId==a then
return e[t]
end
end
end
function UIUtil.GetMarryHead(a)
local e=c.GetList()
for t=1,#e do
if e[t].headType==4 and e[t].heroId==a then
return e[t]
end
end
return nil
end
function UIUtil.SetPlayerFrame(e,t)
local t=UIUtil.GetPlayerFrame(t)
GameTools:SetImageSprite(e,t,false)
end
function UIUtil.NumRoll(e,n,t,a,o,l,d,i,s)
local r=0
if a==nil then
a=tonumber(e.text)or 0
end
local h=o-a
local e=CS.DG.Tweening.DOTween.To(
function()
return r
end,
function(o)
local a=a+math.floor(o*h)
if t~=nil then
a=GameTools.GetLocalize(t,LanguageCategory.LangCommon,a)
end
if n then
LuaUtils.SetTextMeshText(e,a)
else
LuaUtils.SetLabelText(e,a)
end
end,
1,
d
):OnComplete(
function()
local a=o
if t~=nil then
a=GameTools.GetLocalize(t,LanguageCategory.LangCommon,a)
end
if n then
LuaUtils.SetTextMeshText(e,a)
else
LuaUtils.SetLabelText(e,a)
end
if s then
s()
end
end
):OnStart(
function()
if i then
i()
end
end
):SetDelay(l)
return e
end
function UIUtil.PlayWinPageFanAudio(t)
t=t or 65*0.0333
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(t)
e:AppendCallback(function()
GameTools:PlayAudioLua(403)
end)
return e
end
function UIUtil.FightRoll(a,t,e,o,n,s)
local i=0
local o=e-t
local e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(
n,
0.5,
1,
function()
CS.DG.Tweening.DOTween.To(
function()
return i
end,
function(e)
LuaUtils.SetTextMeshText(a,t+math.floor(e*o))
end,
1,
s
)
end,
nil,
function()
end
)
e:Run()
return e
end
function UIUtil.GetBigPaintingPath(t,e)
return i("Assets/Download/RolePrefabsAndRes/RoleBigSetPainting/%d/%s.png",t,e)
end
function UIUtil.GetArenaBigPaintingMaskPath(t,e)
return i("Assets/Download/RolePrefabsAndRes/RoleBigSetPainting/%d/%s.mat",t,e)
end
function UIUtil.GetHeroFramentBuyPath(t,e)
return i("Assets/Download/RolePrefabsAndRes/RoleBigSetPainting/%d/%s.png",t,e)
end
function UIUtil.GetArenaBigPaintingBGPath(e)
return i("UIJingjichang/%s",e)
end
function UIUtil.GetStoryPaintingPath(t,e)
return i("Assets/Download/RolePrefabsAndRes/StoryPrefabAndRes/%d/%s.png",t,e)
end
function UIUtil.GetMateialFullPath(e)
return i("Assets/Download/CommonPrefabsAndRes/CusMaterial/%s.mat",e)
end
function UIUtil.GetRedGreenTichTextByCount(t,a,e)
if t>=a then
return UIUtil.GetDeepGreenTichText(e)
else
return UIUtil.GetNewRedTichText(e)
end
end
function UIUtil.GetRedGreenDifferentTichTextByCount(o,a,t,e)
if o>=a then
return UIUtil.GetDeepGreenTichText(UIUtil.toBigNum(t)).."/"..UIUtil.toBigNum(e)
else
return UIUtil.GetNewRedTichText(UIUtil.toBigNum(t)).."/"..UIUtil.toBigNum(e)
end
end
function UIUtil.GetRedAndDefaultTichTextByCount(a,o,t)
local e=""
if a>=o then
e=tostring(t)
else
e=UIUtil.GetNewRedTichText(t)
end
return e
end
function UIUtil.GetTransparentText(e)
return"<color=#00000000>"..e.."</color>"
end
function UIUtil.GetRedTichText(e)
return"<color=#F53125>"..e.."</color>"
end
function UIUtil.GetNewRedTichText(e)
return"<color=#fb5960>"..e.."</color>"
end
function UIUtil.GetGreenTichText(e)
return"<color=#70C764>"..e.."</color>"
end
function UIUtil.GetLowGreenTichText(e)
return"<color=#00ff00>"..e.."</color>"
end
function UIUtil.GetJadeGreenTichText(e)
return"<color=#00c496>"..e.."</color>"
end
function UIUtil.GetDeepGreenTichText(e)
return"<color=#1AB700>"..e.."</color>"
end
function UIUtil.GetOrangeTichText(e)
return"<color=#DD6518>"..e.."</color>"
end
function UIUtil.GetOrangeTichText2(e)
return"<color=#FEA13C>"..e.."</color>"
end
function UIUtil.GetDarkBrownTichText(e)
return"<color=#9F5B16>"..e.."</color>"
end
function UIUtil.GetWhiteTichText(e)
return"<color=#FFFFFF>"..e.."</color>"
end
function UIUtil.GetBlackTichText(e)
return"<color=#473E36>"..e.."</color>"
end
function UIUtil.GetLightGoldTichText(e)
return"<color=#FBDC96>"..e.."</color>"
end
function UIUtil.GetDarkGoldTichText(e)
return"<color=#D4BB81>"..e.."</color>"
end
function UIUtil.GetGreyTichText(e)
return"<color=#CDCDCD>"..e.."</color>"
end
function UIUtil.GetGreyTichText2(e)
return"<color=#858585>"..e.."</color>"
end
function UIUtil.GetTichTextWithSize(e,t)
return"<size="..t..">"..e.."</size>"
end
function UIUtil.GetRichTextColorQuality(t,e,a)
if a then
return UIUtil.GetRichTextLightColorQuality(t,e)
else
return UIUtil.GetRichTextDarkColorQuality(t,e)
end
end
function UIUtil.GetRichTextLightColorQuality(e,t)
if t==nil or t==0 then
return"<color=#CDCDCD>"..e.."</color>"
elseif t==1 then
return"<color=#FFFFFF>"..e.."</color>"
elseif t==2 then
return"<color=#7ACB71>"..e.."</color>"
elseif t==3 then
return"<color=#5990F1>"..e.."</color>"
elseif t==4 then
return"<color=#AA75CF>"..e.."</color>"
elseif t==5 then
return"<color=#F2A552>"..e.."</color>"
elseif t==6 then
return"<color=#E86B5E>"..e.."</color>"
else
return e
end
end
function UIUtil.GetRichTextDarkColorQuality(e,t)
if t==nil or t==0 then
return"<color=#726868>"..e.."</color>"
elseif t==1 then
return"<color=#D4CBCB>"..e.."</color>"
elseif t==2 then
return"<color=#248519>"..e.."</color>"
elseif t==3 then
return"<color=#255CBC>"..e.."</color>"
elseif t==4 then
return"<color=#904DBF>"..e.."</color>"
elseif t==5 then
return"<color=#D78E40>"..e.."</color>"
elseif t==6 then
return"<color=#C8574B>"..e.."</color>"
else
return e
end
end
function UIUtil.GetPlayerIcon(e)
local e=c.GetEntity(e)
if e==nil then
local e=c.GetEntity(1)
return e.head
end
return e.head
end
function UIUtil.GetPlayerFrame(e)
local e=k.GetEntity(e)
if e then
return e.headFrame
end
local e=k.GetEntity(1)
return e.headFrame
end
function UIUtil.GetUnderwearFrame(e)
return i("UICommonOther/%s",UnderwearQuailtyBgs[e])
end
function UIUtil.GetVipNumPath(e)
return i("UIMainInterface/vip_lv_%s",e)
end
function UIUtil.GetOfficerCapPath(e)
if e<1 then
return"UICommonOther/guanzhi_maozi1"
end
local e=z.GetEntity(e)
local e="UICommonOther/"..e.capIcon
return e
end
function UIUtil.GetOfficerNumPath(e)
if e<1 then
return"guanzhi_1"
end
local e=z.GetEntity(e)
return e.officerName
end
function UIUtil.SetPlayerIconFrame(a,e,i,o)
local t=LuaUtils.GetLuaComBinder(a.transform)
local t=t:GetComponents()
if e.head then
local a=UIUtil.GetPlayerIcon(e.head)
local e=t["btn_head"]:GetComponent(typeof(CS.UnityEngine.UI.Image))
GameTools:SetImageSprite(e,a,false)
end
if e.headFrame then
local e=UIUtil.GetPlayerFrame(e.headFrame)
if e then
GameTools:SetImageSprite(t["im_kuang"],e,false)
end
end
if i then
t["btn_head"].onClick:RemoveAllListeners()
if o then
t["btn_head"].onClick:AddListener(handler(a,o))
else
t["btn_head"].onClick:AddListener(
handler(
e,
function(e)
if e.playerId then
UIUtil.showPlayerInfo(e.playerId,e.serverId)
end
end
)
)
end
end
end
function UIUtil.SetNPCIconFrame(e,t,a)
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
local a=m.GetMonsterCfgData(a)
local t=a.GetEntity(t)
local t=r.GetEntity(t.modelID)
local o=string.format("UIHeroHead/%s",t.head)
local a=UIUtil.GetPlayerFrame(1)
local t=e["btn_head"]:GetComponent(typeof(CS.UnityEngine.UI.Image))
GameTools:SetImageSprite(t,o,false)
GameTools:SetImageSprite(e["im_kuang"],a,false)
end
function UIUtil.SetMarquee(i,e,t,o,a,n)
if i==nil or e==nil then

return
end
t=t or 70
t=math.max(1,t)
o=o or false
a=a or false
n=n or 0
local i=LuaUtils.GetRectTransformWidth(i)/2
local h=-i
local s=e.preferredWidth
local r=i
local d=h-s
local l=math.abs(d-r)
local t=l/t
t=math.max(0.01,t)
if s>i*2 or o then
LuaUtils.SetLocalPos(e.transform,r)

local e=e.transform:DOLocalMoveX(d,t):SetEase(CS.DG.Tweening.Ease.Linear):SetLoops(-1)
else
if a==true then
LuaUtils.SetLocalPos(e.transform,-s/2)
else
LuaUtils.SetLocalPos(e.transform,h+n)
end
end
end
function UIUtil.SetMarqueeWithOption(t,o,a,e)
local e=e or{}
local i=e.speed or 100
local n=e.forceMove or false
local h=e.isMiddleAlgn or false
local s=e.isMeshText or false
local e=e.indent or 10
UIUtil.SetMarqueeWithDesc(t,o,i,a,n,h,s,e)
end
function UIUtil.SetMarqueeWithDesc(s,e,i,t,n,a,h,o)
if s==nil or e==nil then

return
end
i=i or 70
t=t or""
n=n or false
a=a or false
o=o or 0
local r=e.text
if h==true then
LuaUtils.SetTextMeshText(e,t)
else
LuaUtils.SetLabelText(e,t)
end
if r~=t or CS.DG.Tweening.DOTween.IsTweening(e.transform)==false then
e.transform:DOKill()
UIUtil.SetMarquee(s,e,i,n,a,o)
end
end
function UIUtil.SetMarqueeWithToAndFro(o,e,t,a)
local i=e.text
local a=a or{}
local a=a.isMeshText or false
if a then
LuaUtils.SetTextMeshText(e,t)
else
LuaUtils.SetLabelText(e,t)
end
local t=e.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
t:SetLayoutHorizontal()
local t=o.transform.sizeDelta.x
local a=e.transform.sizeDelta.x
local a=e.transform.sizeDelta.x
local a=a-t
if a>0 then
e.transform:DOKill()
local a=e.transform.sizeDelta.x
local t=a-t
LuaUtils.DoTweenDLocalPosMoveX(e.transform,-t,5):SetEase(CS.DG.Tweening.Ease.Linear):SetLoops(-1,CS.DG.Tweening.LoopType.Yoyo)
else
e.transform:DOKill()
local o,a,t=LuaUtils.GetLocalPos(e.transform)
LuaUtils.SetLocalPos(e.transform,0,a,t)
end
end
function UIUtil.getGuildPosIcon(e)
local t=EGuildPosData[e]
local e=""
if t~=nil then
e=t.icon
end
return e
end
function UIUtil.getGuildPosLang(e)
local e=EGuildPosData[e]
local t=""
if e~=nil then
t=GameTools.GetLocalize(e.langKey,LanguageCategory.LangCommon)
end
return t
end
function UIUtil.setGuildPosData(t,e)
LuaUtils.SetTextMeshText(t["text_touxian"],UIUtil.getGuildPosLang(e))
GameTools:SetImageSprite(t["im_tubiao"],UIUtil.getGuildPosIcon(e),false)
end
function UIUtil.showPlayerInfo(t,e,a)
if t==PlayerMgr.PlayerInfo.uid then
return
end
if e and e>0 then
e=e
else
e=UserAccountInfo.serverId
end
if GameFunction:IsSameSeverNewGuideByFunc4(UserAccountInfo.serverId,e)==false then
return
end
UIUtil.isGuildManageMode=a
local e={
playerId=t,
serverId=e
}
NetManager.Send(ProtoId.PRT_PLAYER_VIEW_REQ,e)
end
function UIUtil.showPrivateChat(e,t)
if e.name==nil then
ErrInfoCollectMgr:AddInfo("default","CHAT_DATA_ERROR",debug.traceback("===CHAT===",1))
return
end
if e.playerId==nil then
ErrInfoCollectMgr:AddInfo("default","CHAT_DATA_ERROR",debug.traceback("===CHAT===",1))
return
end
EventSystem.SendEvent(
CommonEventId.OnShowChatView,
{
type=PROTO_ENUM.ENUM_CHAT_TYPE.CHAT_PRIVATE,
icon=e.head or e.icon,
name=e.name,
frame=e.headFrame or e.frame,
serverId=t,
playerId=e.playerId
}
)
end
function UIUtil.getRankIcon(e)
if e>=1 and e<=3 then
return"UICommonOther/IC_paihangbang_tubiao"..tostring(e)
end
end
function UIUtil.SetToggleExState(e,t)
e:SetIsOnWithoutNotify(t)
local e=e:GetComponent(typeof(CS.YouYou.ToggleEx))
if e then
if e.active then
LuaUtils.SetActive(e.active.transform,t==true)
end
if e.notActive then
LuaUtils.SetActive(e.notActive.transform,t==false)
end
end
end
function UIUtil.SetToggleExTrue(t,e)
if type(e)~="table"then
return
end
local t=e[t]
if t==nil then
return
end
LuaUtils.SetToggleValue(t,true)
for a=1,#e do
local a=e[a]
local e=a:GetComponent(typeof(CS.YouYou.ToggleEx))
if e then
if e.active then
LuaUtils.SetActive(e.active.transform,a==t)
end
if e.notActive then
LuaUtils.SetActive(e.notActive.transform,a~=t)
end
end
end
end
function UIUtil.GetListViewAllItemAndCache(e)
local t={}
if e and e.ScrollRect then
local e=e.ScrollRect.content
local a=LuaUtils.GetChildrenCount(e.transform)
if a>0 then
for a=1,a do
local e=UIUtil.GetChild(e.transform,a-1)
table.insert(t,e)
end
end
end
return t
end
function UIUtil.GetListViewAllItem(e)
if e==nil then
return{}
end
local t=e.ItemList
local e={}
for a,t in pairs(t)do
table.insert(e,t)
end
return e
end
function UIUtil.GetGridViewAllItem(e)
if e==nil then
return{}
end
local t=e:GetAllItemList()
local e={}
for a,t in pairs(t)do
table.insert(e,t)
end
return e
end
function UIUtil.GetScrollViewItem(e)
if e==nil then
return nil
end
local e=e:GetAllItemList()
for t,e in pairs(e)do
return e
end
end
function UIUtil.moveScrollViewOneCell(e,o)
if o==nil then
o=true
end
local t=UIUtil.GetScrollViewItem(e)
if t==nil then
return
end
local a=t.CachedRectTransform
local n=a.rect.width
local i=a.rect.height
local a=e.ContainerTrans
local a=a.anchoredPosition3D
local s=e:GetContentSize()
local s=e.ViewPortSize
local s=e.IsVertList
local h=e.ArrangeType
if s then
if o then
e:MovePanelToItemIndex(t.ItemIndex,a.y+t.TopY+i)
else
e:MovePanelToItemIndex(t.ItemIndex,a.y+t.TopY-i)
end
else
if o then
e:MovePanelToItemIndex(t.ItemIndex,a.x+t.LeftX+n)
else
e:MovePanelToItemIndex(t.ItemIndex,a.x+t.LeftX-n)
end
end
end
function UIUtil.moveScrollViewByOffset(t,a,o)
if a==nil then
a=true
end
local e=UIUtil.GetScrollViewItem(t)
if e==nil then
return
end
local i=e.CachedRectTransform
local n=i.rect.width
local i=i.rect.height
local i=t.ContainerTrans
local i=i.anchoredPosition3D
local n=t:GetContentSize()
local n=t.ViewPortSize
local n=t.IsVertList
if n then
if a then
local a=(i.y+e.TopY)+o
t:MovePanelToItemIndex(e.ItemIndex,a)
else
local a=(i.y+e.TopY)-o
t:MovePanelToItemIndex(e.ItemIndex,a)
end
else
if a then
local a=-(i.x+e.LeftX)+o
t:MovePanelToItemIndex(e.ItemIndex,a)
else
local a=-(i.x+e.LeftX)-o
t:MovePanelToItemIndex(e.ItemIndex,a)
end
end
end
function UIUtil.isScrollViewStart(t,e)
e=e or 0.1
local a=t.ContainerTrans
local o=a.anchoredPosition3D
local i=a.rect.width
local n=a.rect.height
local a=t.ViewPortSize
local t=t.IsVertList
if t then
if n>a then
if o.y<=e then
return true
end
else
return true
end
else
if i>a then
if o.x>=-e then
return true
end
else
return true
end
end
return false
end
function UIUtil.isScrollViewEnd(t)
local e=t.ContainerTrans
local o=e.anchoredPosition3D
local a=e.rect.width
local i=e.rect.height
local e=t.ViewPortSize
local t=t.IsVertList
if t then
if i>e then
if o.y>=i-e-0.1 then
return true
end
else
return true
end
else
if a>e then
if o.x<=-(a-e)+0.1 then
return true
end
else
return true
end
end
return false
end
function UIUtil.isScrollItemShow(a,n,e)
e=e or 0
local t=a.viewport
local i=t.rect.width
local o=t.rect.height
local t=a.content
local h=t.rect.width
local s=t.rect.height
local t=t.anchoredPosition3D
local n=n.transform.anchoredPosition3D
local a=a.vertical
if a then
if s>o then
local e=t.y+n.y
if e<2 and e>-o then
return true
end
else
return true
end
else
if h>i then
local t=t.x+n.x
if t+e<i and t+e>0 then
return true
end
else
return true
end
end
return false
end
function UIUtil.isScrollRectStart(a,e)
e=e or 0.1
local t=a.viewport
local i=t.rect.width
local o=t.rect.height
local t=a.content
local n=t.rect.width
local s=t.rect.height
local t=t.anchoredPosition3D
local a=a.vertical
if a then
if s>o then
if t.y<=e then
return true
end
else
return true
end
else
if n>i then
if t.x>=-e then
return true
end
else
return true
end
end
return false
end
function UIUtil.isScrollRectEnd(t,e)
e=e or 0.1
local a=t.viewport
local s=a.rect.width
local i=a.rect.height
local a=t.content
local n=a.rect.width
local o=a.rect.height
local a=a.anchoredPosition3D
local t=t.vertical
if t then
if o>i then
if a.y>=o-i-e then
return true
end
else
return true
end
else
if n>s then
if a.x<=-(n-s)+e then
return true
end
else
return true
end
end
return false
end
function UIUtil.MoveScrollGridStart(e)
local t=e.vertical
local e=e.content
if t then
e.anchoredPosition3D=Vector3(0,0,0)
else
e.anchoredPosition3D=Vector3(0,0,0)
end
return false
end
function UIUtil.MoveScrollGridEnd(t)
local a=t.viewport
local e=t.content
local t=t.vertical
if t then
local a=a.rect.height
local t=e.rect.height
local t=t-a
t=math.max(0,t)
e.anchoredPosition3D=Vector3(0,t,0)
else
local t=a.rect.width
local a=e.rect.width
local t=t-a
t=math.min(0,t)
e.anchoredPosition3D=Vector3(t,0,0)
end
return false
end
function UIUtil.MoveScrollRectToStart(e)
local t=e.viewport
local a=t.rect.width
local t=t.rect.height
local t=e.content
local a=t.rect.width
local a=t.rect.height
local t=t.anchoredPosition3D
local e=e.vertical
end
function UIUtil.getValidContainerPos(a,e)
local t=a.ContainerTrans
local o=t.rect.width
local i=t.rect.height
local t=a.ViewPortSize
local a=a.IsVertList
if a then
if i>t then
e.y=math.max(0,e.y)
e.y=math.min(i-t,e.y)
else
e.y=0
end
else
if o>t then
e.x=math.min(0,e.x)
e.x=math.max(t-o,e.x)
else
e.x=0
end
end
return e
end
function UIUtil.setScrollViewAutoByContainerSize(e,i)
local e=e:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
if e then
local t=e.viewport
local o=t.rect.width
local s=t.rect.height
local t=e.content
local a=t.rect.width
local h=t.rect.height
local n=t.anchoredPosition3D
local n=e.vertical
if n then
if h>s then
e.enabled=true
if i then
t.anchoredPosition3D=Vector3((a-o)/2,0,0)
end
else
e.enabled=false
end
else
if a>o then
e.enabled=true
if i then
t.anchoredPosition3D=Vector3((a-o)/2,0,0)
end
else
e.enabled=false
end
end
end
end
function UIUtil.getScrollViewContainerSize(e)
local e=e:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
if e then
local t=e.viewport
local a=t.rect.width
local t=t.rect.height
local e=e.content
local e=e.rect.width
return e
end
return 0
end
function UIUtil.setScrollViewMaxWidth(e,t)
local a=e.transform.sizeDelta
LuaUtils.SetRectTransformSizeDelta(e.transform,t,a.y)
end
function UIUtil.getScrollViewContainerOffset(e)
local e=e.ContainerTrans
return e.anchoredPosition
end
function UIUtil.setScrollViewContainerOffset(e,t)
local a=e.ContainerTrans
a.anchoredPosition=UIUtil.getValidContainerPos(e,t)
end
function UIUtil.setScrollViewMoveAnim(a,o,t)
t=t or 0.3
local e=100
local i=a.ItemList
local i=i[1]
if not IsNil(i)then
local t=i.CachedRectTransform
if not IsNil(t)then
local a=a.IsVertList
if a then
e=t.rect.height
else
e=t.rect.width
end
end
end
if o==EDirection.Left or o==EDirection.Down then
e=-e
end
UIUtil.setScrollViewMoveAnimWithDistance(a,e,t)
end
function UIUtil.setScrollViewMoveAnimWithDistance(a,i,o)
local t=a.ContainerTrans
local e=t.anchoredPosition
local e=Vector2(e.x,e.y+i)
e=UIUtil.getValidContainerPos(a,e)
t.transform:DOKill()
t.transform:DOLocalMoveY(e.y,o):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(
function()
end)
end
function UIUtil.setScrollViewInContainerScreenByIndex(e,a,t)
local t=t or 100
local a=-(a-1)*t
local n=a-t
local t=e.ContainerTrans
local i=t.anchoredPosition3D
local o=e.ViewPortSize
if(a+i.y)>0 then
UIUtil.setScrollViewContainerOffset(e,Vector2(t.anchoredPosition.x,-a))
elseif(n+i.y)<-o then
UIUtil.setScrollViewContainerOffset(e,Vector2(t.anchoredPosition.x,-n-o))
end
end
function UIUtil.RefreshRedPoint2(a,e)
if e>0 then
LuaUtils.SetActive(a.transform,true)
local t=LuaUtils.GetLuaComBinder(a.transform)
local t=t:GetComponents()
if e<10 then
LuaUtils.SetActive(t["im_qipao1"].transform,true)
LuaUtils.SetActive(t["im_qipao2"].transform,false)
LuaUtils.SetLabelText(t["text_num1"],e)
else
LuaUtils.SetActive(t["im_qipao1"].transform,false)
LuaUtils.SetActive(t["im_qipao2"].transform,true)
if e>=100 then
e="99+"
end
LuaUtils.SetLabelText(t["text_num2"],e)
end
else
LuaUtils.SetActive(a.transform,false)
end
end
function UIUtil.SetCurrencyIcon(t,a,e)
if e==nil then
e=true
end
GameTools:SetImageSprite(t,UIUtil.GetItemSmallIconById(a),e)
end
function UIUtil.SetCurrency(e,a,o,t)
if e==nil or a==nil then
return
end
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
if t==nil then
t=true
end
LuaUtils.SetActive(e["btn_jia"].transform,t)
UIUtil.SetCurrencyIcon(e["im_zuanshi"],a,o)
local t=ModulesInit.BagManager:GetItemCountById(a)
LuaUtils.SetTextMeshText(e["txt_act_name"],UIUtil.toBigNum3(t))
end
function UIUtil.SetCurrencySourceEvent(e,t)
if e==nil or t==nil then
return
end
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
e["btn_jia"].onClick:RemoveAllListeners()
e["btn_jia"].onClick:AddListener(t)
end
function UIUtil.SetCurrency(a,t,o,e)
if a==nil or t==nil then
return
end
local a=LuaUtils.GetLuaComBinder(a)
local a=a:GetComponents()
if e==nil then
e=true
end
LuaUtils.SetActive(a["btn_jia"].transform,e)
UIUtil.SetCurrencyIcon(a["im_zuanshi"],t,o)
local e=ModulesInit.BagManager:GetItemCountById(t)
LuaUtils.SetTextMeshText(a["txt_act_name"],UIUtil.toBigNum3(e))
end
function UIUtil.SetCurrencyCount(e,a,t)
if e==nil or a==nil then
return
end
local e=LuaUtils.GetLuaComBinder(e)
local o=e:GetComponents()
local e=ModulesInit.BagManager:GetItemCountById(a)
if t~=nil then
e=math.min(t,e)
end
LuaUtils.SetTextMeshText(o["txt_act_name"],UIUtil.toBigNum3(e))
end
function UIUtil.SetCurrencySourceEvent(e,t)
if e==nil or t==nil then
return
end
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
e["btn_jia"].onClick:RemoveAllListeners()
e["btn_jia"].onClick:AddListener(t)
end
function UIUtil.SetItemIcon(t,a,e)
if e==nil then
e=true
end
local a=ModulesInit.BagManager:GetBaseInfo(a)
GameTools:SetImageSprite(t,a.icon,e)
end
function UIUtil.PlayTransitionEffect(t,a)
GameTools:PoolGameObjectSpawn(
200074,
nil,
function(e,o,o)
e:GetComponent(typeof(CS.YouYou.YouYouCanvasHelper)):ResetDepth(t)
e.position=GameEntry.Instance.UIRoot.transform.position
LuaUtils.SetParent(e,GameEntry.Instance.UIEffectContainer)
local t=ModulesInit.TimeActionMgr:CreateTimeAction()
t:Init(0.4,1,1,
function()
if a then
a()
end
end,
nil,
function()
GameEntry.Pool:GameObjectDespawn(e)
end
)
t:Run()
end
)
end
function UIUtil.GetConsumeStr(a,t)
local e=""
local a=ModulesInit.BagManager:GetItemCountById(a)
e=UIUtil.GetConsumeStrByCount(a,t)
return e
end
function UIUtil.GetConsumeStrByCount(e,t)
local a=""
if e>=t then
a=string.format("%d/%d",e,t)
else
a=string.format("<color=#FF2323>%d</color>/%d",e,t)
end
return a
end
function UIUtil.GetTaskNumStrByCount(e,t)
local a=""
e=math.min(e,t)
if e>=t then
a=string.format("<color=#31FF31>%d</color><color=#323232>/%d</color>",e,t)
else
a=string.format("<color=#FF2323>%d</color><color=#323232>/%d</color>",e,t)
end
return a
end
function UIUtil.GetConsumeStr2(a,e)

local t=""
local a=ModulesInit.BagManager:GetItemCountById(a)
if a>=e then
t=string.format("<color=#31FF31>%d</color>",e)
else
t=string.format("<color=#FF2323>%d</color>",e)
end
return t
end
function UIUtil.GetBlackConsumeStr(a,e)
local t=""
local a=ModulesInit.BagManager:GetItemCountById(a)
if a>=e then
t=string.format("<color=#493E35>%d</color>",e)
else
t=string.format("<color=#FF2323>%d</color>",e)
end
return t
end
function UIUtil.GetConsumeAutoStr(o,e,t)
local t=""
local a=""
local o=ModulesInit.BagManager:GetItemCountById(o)
if o>=e then
t=a..tostring(e)
else
t=string.format("<color=#FF2323>%s%d</color>",a,e)
end
return t
end
function UIUtil.GetConsumeAutoStr2(e,a,t)
local e=ModulesInit.BagManager:GetItemCountById(e)
local e=UIUtil.GetRedAndDefaultTichTextByCount(e,a,t)
return e
end
function UIUtil.GetLeftCountStr(t)
local e=""
if t>0 then
e=string.format("%s",t)
else
e=string.format("<color=#FF2323>%s</color>",t)
end
return e
end
function UIUtil.GetLeftCountStr2(e,a)
local t=""
if e>=a then
t=string.format("%s/%s",e,a)
else
t=string.format("<color=#FF2323>%d</color><color=#323232>/%d</color>",e,a)
end
return t
end
function UIUtil.GetLeftCountStr3(a,t)
local e=""
if a>=t then
e=string.format("<color=#31FF31>%d</color><color=#FFFFFF>/%d</color>",a,t)
else
e=string.format("<color=#FF2323>%d</color><color=#FFFFFF>/%d</color>",a,t)
end
return e
end
function UIUtil.GetLeftCountStr4(e,t)
local a=""
if e>=t then
a=string.format("<color=#31FF31>%d</color><color=#323232>/%d</color>",e,t)
else
a=string.format("<color=#FF2323>%d</color><color=#323232>/%d</color>",e,t)
end
return a
end
function UIUtil.GetLightGreenText(e)
return"<color=#31FF31>"..e.."</color>"
end
function UIUtil.GetRedText(e)
return"<color=#FF2323>"..e.."</color>"
end
function UIUtil.FitScrollView(e,a)
a=a or Vector2(0,0)
local t=e.ContainerTrans
local o=t.anchoredPosition3D
local i=t.rect.width
local h=t.rect.height
local o=e.ViewPortSize
local s=e.IsVertList
local t=e.transform
local r,n,r=LuaUtils.GetLocalScale(e.transform,sx,sy,sz)
if s then
if h>o then
t.localPosition=Vector3(t.localPosition.x,a.y,0)
e.ScrollRect.enabled=true
else
t.localPosition=Vector3(t.localPosition.x,a.y+(o/2-i/2)*n,0)
e.ScrollRect.enabled=false
end
else
if i>o then
t.localPosition=Vector3(a.x,t.localPosition.y,0)
e.ScrollRect.enabled=true
else
t.localPosition=Vector3(a.x+(o/2-i/2)*n,t.localPosition.y,0)
e.ScrollRect.enabled=false
end
end
return false
end
function UIUtil.SetHpBar(t,e)
local t=LuaUtils.GetLuaComBinder(t)
local t=t:GetComponents()
LuaUtils.SetImageFillAmount(t["imgHP"],e.curHp/e.maxHp)
LuaUtils.SetImageFillAmount(t["imgFury"],e.curMp/e.maxMp)
UIUtil.SetHpBarColor(t["imgHP"],e.curHp/e.maxHp)
end
function UIUtil.SetHpBarColor(e,t)
if t<0.3 then
LuaUtils.SetImageColor(e,210/255,19/255,15/255,1)
else
LuaUtils.SetImageColor(e,150/255,219/255,23/255,1)
end
end
function UIUtil.GetNameWithServer(e,t)
return"[S"..tostring(t).."]"..tostring(e)
end
function UIUtil.GetNameWithFrontServerAndBlue(a,e,t)
return UIUtil.GetNameWithFrontServer(a,e,"#337096",t)
end
function UIUtil.GetServerStr(e,t,a)
local e="[S"..tostring(e).."]"
if t then
e=string.format("<color=%s>%s</color>",t,e)
end
if a then
e=string.format("<size=%s>%s</size>",a,e)
end
return e
end
function UIUtil.GetNameWithFrontServer(o,a,t,e)
local e=UIUtil.GetServerStr(a,t,e)
return e.." "..tostring(o)
end
function UIUtil.GetNameWithBackServerAndBlue(e,t,a)
return UIUtil.GetNameWithBackServer(e,t,"#337096",a)
end
function UIUtil.GetNameWithBackServer(e,t,a,o)
local t=UIUtil.GetServerStr(t,a,o)
return tostring(e).." "..t
end
function UIUtil.GetGuildNameWithId(e,t)
return tostring(e).."("..tostring(t)..")"
end
function UIUtil.GetPlayerNameWithLevel(t,e)
return tostring(t).."(Lv."..tostring(e)..")"
end
function UIUtil.GetHeroRowAndColumn(e)
local t=math.ceil((e+1)/3)
local e=e%3+1
return t,e
end
function UIUtil.RefreshScrollView(e,a,t)
t=t or false
if a==e.ItemTotalCount then
e:RefreshAllShownItem()
if t==true then
e:MovePanelToItemIndex(0,0)
end
else
e:SetListItemCount(a,t)
e:RefreshAllShownItem()
end
end
function UIUtil.RefreshScrollViewHorizontalLayout(e,o,i,t)
local a=e.transform.sizeDelta
local t=i*t
if t>o then
e.ScrollRect.enabled=true
LuaUtils.SetRectTransformSizeDelta(e.transform,o,a.y)
else
e.ScrollRect.enabled=false
LuaUtils.SetRectTransformSizeDelta(e.transform,t,a.y)
end
end
function UIUtil.RefreshScrollViewHorizontalLayoutVertical(e,o,t,i)
local a=e.transform.sizeDelta
local t=t*i
if t>o then
e.ScrollRect.enabled=true
LuaUtils.SetRectTransformSizeDelta(e.transform,a.x,o)
else
e.ScrollRect.enabled=false
LuaUtils.SetRectTransformSizeDelta(e.transform,a.x,t)
end
end
function UIUtil.AddTouchEvent(e,t,o,a)
local e=LuaUtils.GetUIEventListener(e.transform)
if e==nil then
GameInit.LogError("UIUtil AddTouchEvent: 没有添加 组件 UIEventListentr")
return
end
if t then
e.onPointerDown=function(...)
if t then
t(...)
end
end
end
if o then
e.onPointerUp=function(...)
if o then
o(...)
end
end
end
if a then
e.onExit=function(...)
if a then
a(...)
end
end
end
end
function UIUtil.AddTouchEventMulti(e,s,i,a,t,o,n)
local e=LuaUtils.GetUIEventMultiListener(e.transform)
if e==nil then
GameInit.LogError("UIUtil AddTouchEvent: 没有添加 组件 UIEventListentr")
return
end
if s then
e.onPointerDown=function(...)
if s then
s(...)
end
end
end
if i then
e.onPointerUp=function(...)
if i then
i(...)
end
end
end
if a then
e.onBeginDrag=function(...)
if a then
a(...)
end
end
end
if t then
e.onDraging=function(...)
if t then
t(...)
end
end
end
if o then
e.onEndDrag=function(...)
if o then
o(...)
end
end
end
if n then
e.onExit=function(...)
if n then
n(...)
end
end
end
end
function UIUtil.GetShowCountStr(e)
return"x"..tostring(e)
end
function UIUtil.GetItemSmallIconById(e)
if BagUtil.IsItem(e)then
local t=w.GetEntity(e)
if not t.ItemIconSmall or t.ItemIconSmall==""then
GameInit.LogError('%d未配置小icon',e)
end
return UIUtil.GetItemIconPath(t.ItemIconSmall)
else
local t=x.GetEntity(e)
if not t.iconSmall or t.iconSmall==""then
GameInit.LogError('%d未配置小icon',e)
end
return UIUtil.GetItemIconPath(t.iconSmall)
end
end
function UIUtil.GetJyVideoPathById(e)
return"jy_"..tostring(e)
end
function UIUtil.SetHeroPropInfo(a,o,i,u,s)
local e=HeroMgr:GetHeroDataByHeroDId(a)
local t=HeroMgr:GetHeroCfgData(a)
local l=t.rankLevel
local d=0
local r=0
if i and e then
l=e.rankLevel
d=e.magatama
r=e.beansLevel
end
local e=LuaUtils.GetLuaComBinder(o.transform)
local e=e:GetComponents()
UIUtil.HandlerMarryPlusEff(a,o)
local a=string.format("UICommonOther/%s",CardQuailtyFont[t.star])
GameTools:SetImageSprite(e["UI_profession"],UIUtil.GetProfessionPath(t.profession),false)
LuaUtils.SetTextMeshText(e["UI_HeroName"],GameTools.GetLocalize(string.format("%s_1",t.heroName),LanguageCategory.LangBattle))
LuaUtils.SetImageSprite(e["im_quality"],a,true)
UIUtil.HandlerHeroQualityImgEff(e["im_quality"],t.star,true)
LuaUtils.SetTextMeshText(e["UI_HeroLocation"],GameTools.GetLocalize(string.format("%s_1",t.location),LanguageCategory.LangBattle))
if e["UI_element"]then
LuaUtils.SetImageSprite(e["UI_element"].transform,AmuletMgr:GetAmuletGroupIcon(t.camp))
end
local o,n,a
o,n,a=LuaUtils.GetPos(e["UI_HeroName"].transform,o,n,a)
local h=e["UI_HeroName"].preferredHeight
local a,i,o
LuaUtils.SetActive(e["star_root"].transform,false)
if e["fire_root"]then
LuaUtils.SetActive(e["fire_root"].transform,false)
end
if e["dou_root"]then
LuaUtils.SetActive(e["dou_root"].transform,false)
end
if s and t.star>=Quality.UR then
local s=0
if t.star==Quality.UR then
LuaUtils.SetActive(e["fire_root"].transform,true)
a,i,o=LuaUtils.GetPos(e["fire_root"].transform,a,i,o)
LuaUtils.SetPos(e["fire_root"].transform,a,n-h,o)
for t=1,3 do
LuaUtils.SetActive(e["gouyu"..t].transform,d>=t)
if d>=t then
s=s+e["gouyu"..t].transform.sizeDelta.y
end
end
end
local d=0
if t.star==Quality.LR then
LuaUtils.SetActive(e["dou_root"].transform,true)
a,i,o=LuaUtils.GetPos(e["dou_root"].transform,a,i,o)
LuaUtils.SetPos(e["dou_root"].transform,a,n-h-s,o)
for t=1,2 do
LuaUtils.SetActive(e["baodou"..t].transform,r>=t)
if r>=t then
d=d+e["baodou"..t].transform.sizeDelta.y
end
end
end
else
LuaUtils.SetActive(e["star_root"].transform,true)
a,i,o=LuaUtils.GetPos(e["star_root"].transform,a,i,o)
LuaUtils.SetPos(e["star_root"].transform,a,n-h,o)
if u then
for t=1,7 do
LuaUtils.SetActive(e["IC_star"..t].transform,true)
end
else
for t=1,7 do
LuaUtils.SetActive(e["IC_star"..t].transform,l>=t)
end
end
end
end
function UIUtil.SetHeroPropInfo2(e,i,o,t)
local t=HeroMgr:GetHeroDataByHeroDId(e)
local e=HeroMgr:GetHeroCfgData(e)
local a=e.rankLevel
if o and t then
a=t.rankLevel
end
local t=LuaUtils.GetLuaComBinder(i.transform)
local t=t:GetComponents()
local a=string.format("UICommonOther/%s",CardQuailtyFont[e.star])
LuaUtils.SetImageSprite(t["UI_profession"],UIUtil.GetProfessionPath(e.profession),false)
LuaUtils.SetTextMeshText(t["UI_HeroName"],GameTools.GetLocalize(string.format("%s",e.heroName),LanguageCategory.LangBattle))
LuaUtils.SetImageSprite(t["im_quality"],a,true)
UIUtil.HandlerHeroQualityImgEff(t["im_quality"],e.star,true)
LuaUtils.SetTextMeshText(t["UI_HeroLocation"],GameTools.GetLocalize(string.format("%s",e.location),LanguageCategory.LangBattle))
end
function UIUtil.ShowFullScreenEffectNode(a,t)
if t~=""then
local e=a.transform.position
local a=a:GetComponent(typeof(CS.UnityEngine.Canvas)).sortingOrder+60
GameEntry.Effect:ShowUIEffect(t,a,EffectKeepType.AutoRelease,e.x,e.y,e.z,{prefabId=t},function(t,e,t)
LuaUtils.SetLocalScale(e,CS.UnityEngine.Screen.width/GameEntry.Instance.StandardWidth,CS.UnityEngine.Screen.height/GameEntry.Instance.StandardHeight,1)
end)
end
end
function UIUtil.ShowEffectNode(i,o,e,a)
a=a or 60
if o~=""then
local t=i.transform.position
local a=i:GetComponent(typeof(CS.UnityEngine.Canvas)).sortingOrder+a
GameEntry.Effect:ShowUIEffect(o,a,EffectKeepType.AutoRelease,t.x,t.y,t.z,{prefabId=o},function(a,t,a)
if e then
LuaUtils.SetLocalScale(t,e.x,e.y,e.z)
end
end)
end
end
function UIUtil.SetRingItem(e,t)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
LuaUtils.SetImageSprite(e['img_level'],'UIMarry/hjbg_jzddb'..t.level)
LuaUtils.SetImageSprite(e['icon'],t.icon)
if ModulesInit.MarryManager:IsMarryPlus(t.heroId)then
LuaUtils.SetImageSprite(e['bg'],'UIMarry/hjbg_jzddbx',true)
e['bg'].transform.anchoredPosition=Vector2(0,0)
if IsNil(e['un_ActSelfMarry_start'])==false then
LuaUtils.SetActive(e['un_ActSelfMarry_start'].transform,true)
end
else
LuaUtils.SetImageSprite(e['bg'],'UIMarry/hjbg_jzddb',true)
e['bg'].transform.anchoredPosition=Vector2(0,22)
if IsNil(e['un_ActSelfMarry_start'])==false then
LuaUtils.SetActive(e['un_ActSelfMarry_start'].transform,false)
end
end
end
function UIUtil.SetSpineColor(e,t)
local a=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
if IsNil(a)==false then
local o=CS.UnityEngine.Shader.PropertyToID("_Color")
local e=LuaUtils.CreateMaterialPropertyBlock()
e:SetColor(o,t)
a:SetPropertyBlock(e)
else
local e=e:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e then
e.color=t
end
end
end
function UIUtil.SetSpineOpacity(e,a)
if e==nil then
GameInit.LogError("UIUtil.SetSpineOpacity spineTrans should be not nil")
return
end
local t=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
if IsNil(t)==false then
local e=t.material.color
e.a=a
local o=CS.UnityEngine.Shader.PropertyToID("_Color")
local a=LuaUtils.CreateMaterialPropertyBlock()
a:SetColor(o,e)
t:SetPropertyBlock(a)
else
local e=e:GetComponent(typeof(CS.YouYou.UISpineCtr))
if e then
e:SetOpacity(a,0)
end
end
end
function UIUtil.DoSpineFadeAnim(a,e,o,i,t)
local e=e
local o=o
local e=CS.DG.Tweening.DOTween.To(
function()
return e
end,
function(t)
e=t
end,
o,
i
):OnUpdate(
function()
UIUtil.SetSpineOpacity(a,e)
end
):OnComplete(
function()
UIUtil.SetSpineOpacity(a,o)
if t then
t()
end
end)
return e
end
function UIUtil.GetCurAnimName(t,e)
e=e or 0
if t then
local a=t:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
if a and a.AnimationState then
local e=a.AnimationState:GetCurrent(e)
if e then
return e.Animation.Name
end
else
local t=t:GetComponent(typeof(CS.YouYou.UISpineCtr))
if t then
return t:GetCurrentName(e)
end
end
end
return""
end
function UIUtil.WindowsOpenInAnim(a,t)
local e=CS.DG.Tweening.DOTween.Sequence()
LuaUtils.SetLocalScale(t,0.6,0.6,0.6)
local a=a:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
a.alpha=0
e:Append(t:DOScale(1.02,0.1):SetEase(CS.DG.Tweening.Ease.Linear))
e:Join(a:DOFade(1,0.1))
e:Append(t:DOScale(1,0.1):SetEase(CS.DG.Tweening.Ease.Linear))
end
function UIUtil.WindowsCloseOutAnim(o,a)
local e=CS.DG.Tweening.DOTween.Sequence()
LuaUtils.SetLocalScale(a,1,1,1)
local t=o:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
t.alpha=1
e:Append(a:DOScale(0.95,0.1))
e:Join(t:DOFade(0,0.1))
e:OnComplete(function()
GameObject.Destroy(o.gameObject)
end)
end
function UIUtil.OnAddObtainEffect(a,e,t)
EventSystem.SendEvent(CommonEventId.AddObtainEffect,a,e,t)
end
function UIUtil.OnRemoveObtainEffect()
EventSystem.SendEvent(CommonEventId.RemoveObtainEffect)
end
function UIUtil.GetPreciseDecimal(t,e,a)
if type(t)~="number"then
return t;
end
e=e or 0;
e=g(e)
if e<0 then
e=0;
end
local e=10^e
local t=UIUtil.GetFloorNum(t*e)
local e=t/e;
return UIUtil.FormatNum(e,a)
end
function UIUtil.PlayHeroFrontVoice(e)
if UIUtil.prevPlayAudioId~=0 then
GameEntry.Audio:StopAudio(UIUtil.prevPlayAudioId)
end
local e=d.GetEntity(e)
local e=r.GetEntity(e.modelID)
local e=f.GetEntity(e.frontVoice)
UIUtil.prevPlayAudioId=GameTools:PlayAudioWithPathLua(e.voicePath)
end
function UIUtil.PlayHeroSpineVoice(t)
local e=UIUtil.GetHeroModelCfgData(t)
if e==nil then
return
end
local a=HeroMgr:GetHeroDataByHeroDId(t)
local t
if a==nil or a.isUnderwear==false then
t=e.paintingVoice
else
t=e.painting2Voice
end
local t=t[1]
local e=#t
if e<=0 then
return
end
local e=math.random(1,e)
local e=t[e]
local e=I.GetEntity(e)
local e=f.GetEntity(e.voiceID)
if e==nil then
return
end
GameEntry.Audio:StopAllAudio()
return GameTools:PlayAudioWithPathLua(e.voicePath)
end
function UIUtil.PlayHeroMvpVoice(e)
local e=d.GetEntity(e)
local e=r.GetEntity(e.modelID)
local e=f.GetEntity(e.mvpVoice)
return GameTools:PlayAudioWithPathLua(e.voicePath)
end
function UIUtil.PlayHeroDeadVoice(e)
if type(e)~="number"then
return
end
local e=8 ..tostring(e).. 11
local e=f.GetEntity(tonumber(e))
if e then
GameTools:PlayAudioWithPathLua(e.voicePath)
end
end
function UIUtil.PlayRandomHeroAudioByIdArr(e)
local e={8104206,8104207}
local t=math.random(1,#e)
local e=e[tonumber(t)]
UIUtil.PlayHeroAudioById(e)
end
function UIUtil.PlayHeroAudioById(e)
local e=f.GetEntity(e)
if e then
return GameTools:PlayAudioWithPathLua(e.voicePath)
end
return nil
end
function UIUtil.PlayHeroAudioByHeroAndIndex(t,e)
if e<10 then
e="0"..e
end
local e=tonumber("8"..t..e)
return UIUtil.PlayHeroAudioById(e)
end
function UIUtil.TestHasChar(o,t,a)
local e={}
local t=string.str2List(t or"")
for i,t in ipairs(t or{})do
LuaUtils.SetTextMeshText(o,t)
local o=o.preferredWidth
if o<=1 then
table.insert(e,t)
end
if a then
LuaUtils.SetTextMeshText(a,t)
local a=a.preferredWidth
if a<=1 then
table.insert(e,t)
end
end
end
return#e<=0,e
end
function UIUtil.DelayLoad(t,e,a,o)
return R.start(function()
for e=1,e do
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
UIUtil.GetUISmallSpinePoolByModel(t,
function(e,t,o)
a(e,t,o)
end,
o,
true
)
end)
end
function UIUtil.GetUIFormPrefabFullPath(e)
local e=LuaUtils.GetSysUIFormData(e)
local t=e.AssetPathJapanese
if GameEntry.CurrLanguage==CS.YouYou.YouYouLanguage.Chinese then
t=e.AssetPathChinese
elseif GameEntry.CurrLanguage==CS.YouYou.YouYouLanguage.English then
t=e.AssetPathEnglish
elseif GameEntry.CurrLanguage==CS.YouYou.YouYouLanguage.Japanese then
t=e.AssetPathJapanese
elseif GameEntry.CurrLanguage==CS.YouYou.YouYouLanguage.Korean then
t=e.AssetPathKorean
end
local e=string.format('Assets/Download/UI/%s.prefab',t)
return e
end
function UIUtil.CalculateDiffValueWithScreen(o,i)
local n=CS.UnityEngine.Screen.width/CS.UnityEngine.Screen.height
local a=GameEntry.Instance.StandardWidth/GameEntry.Instance.StandardHeight
local t=ScreenDesignWidth/ScreenDesignHeight
local e=0
if a-t~=0 then
e=(n-t)/(a-t)
e=math.min(1,e)
e=math.max(0,e)
end
local e=(i-o)*e+o
return e
end
function UIUtil.RefreshGridItemInfo(t,a,i,o)
function setCell(a,e)
local e=UIUtil.GetChild(t.transform,e-1)
if not e then
e=i()
LuaUtils.SetParent(e.transform,t.transform)
end
if e.gameObject.activeSelf==false then
LuaUtils.SetActive(e.transform,true)
end
if o then
o(e,a)
end
end
for e=1,#a do
local t=a[e]
setCell(t,e)
end
local e=LuaUtils.GetChildrenCount(t.transform)
for e=#a+1,e do
local e=UIUtil.GetChild(t.transform,e-1)
if e.gameObject.activeSelf then
LuaUtils.SetActive(e.transform,false)
end
end
end
function UIUtil.RefreshGridItemInfoSimple(h,s,a,e,t)
local i=e and e.isShowEquipLevel
local n=e and e.mustShowCount
local o=e and e.isGoWay
local r=e and e.isShowSelect
UIUtil.RefreshGridItemInfo(h.transform,a,function()
local e=LuaUtils.Instantiate(s.transform)
local t=e:GetComponent(typeof(CS.YouYou.LuaUnit))
t:Init()
return e
end,function(a,e)
local a=a:GetComponent(typeof(CS.YouYou.LuaUnit))
local e={
itemDid=e[1],
count=e[2],
isShowEquipLevel=i,
mustShowCount=n,
isGoWay=o,
isShowSelect=r,
isMax=t and t.isMax
}
a:Refresh(e)
end)
end
function UIUtil.RefreshGridItemInfoHeroUpgrade(a,o,t)
local e=ModulesInit.HeroQualityUpgradeMgr.UpQualityDataList
UIUtil.RefreshGridItemInfo(a.transform,e,function()
local e=LuaUtils.Instantiate(o.transform)
LuaUtils.SetLocalScale(e,1,1,1)
return e
end,function(o,e)
local a=e.IsCanShowUpSkillBtn(t)
LuaUtils.SetActive(o.transform,a)
if a then
local a=t
if e.quality==Quality.UR then
a=ModulesInit.MagatamaUpgradeMgr:GetOriginParentHeroDid(t)
elseif e.quality==Quality.LR then
a=ModulesInit.ExplosiveBeansUpgradeMgr:GetOriginParentHeroDid(t)
end
UIUtil.RefreshSkillUpgradeBtnItem(o,a,e.quality,e)
end
end)
end
function UIUtil.RefreshSkillUpgradeBtnItem(s,t,a,n)
local h=HeroMgr:GetHeroCfgData(t)
local r=HeroMgr:checkHasHero(t)
local e=LuaUtils.GetLuaComBinder(s)
local o=e:GetComponents()
local function i(e,a,i)
local o=e-1
local t=ModulesInit.HeroQualityUpgradeMgr.UpQualityData[o]
if t then
local e=0
local a=HeroMgr:GetHeroAllParentAndSonArr(a)
for t=1,#a do
if HeroMgr:GetHeroCfgData(a[t]).star==o then
e=a[t]
break
end
end
if e>0 then
if i then
if ModulesInit.HeroQualityUpgradeMgr:IsCanQualityUpgradeRed(e,o)then
return true,t,e
end
else
if t.IsCanUpQuality(e)then
return true,t,e
end
end
end
end
return false,nil,0
end
local e=s:GetComponent(typeof(CS.UnityEngine.UI.Button))
e.onClick:RemoveAllListeners()
e.onClick:AddListener(function()
if r then
n.JumpToUpSkillUI(t)
else
local a,t,e=i(a,t,false)
if a==false then
UIUtil.ShowCommonTips(GameTools.GetLocalize("srUpSsrTips_6",LanguageCategory.LangCommon))
else
t.JumpToUpQualityUI(e)
end
end
end)
local e=i(a,t,true)
local e=n.IsCanUpSkill(t)or e
LuaUtils.SetActive(o["red"].transform,e)
LuaUtils.SetChildrenActive(o["spiconList"],false)
LuaUtils.SetActive(o["sp_icon_"..a].transform,h.star>=a)
LuaUtils.SetTextMeshText(o["name"],GameTools.GetLocalize("UpQualitySkillRuleName_"..a,LanguageCategory.LangCommon))
end
function UIUtil.DelayPlayAudio(t)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.001)
e:AppendCallback(function()
GameTools:PlayAudioLua(t)
end)
end
function UIUtil.GetChild(e,t)
if e==nil or IsNil(e)then
LuaUtils.PrintBuglyLog(5,debug.traceback("===GetChild===",1))
end
local e=LuaUtils.GetChild(e,t)
return e
end
function UIUtil.SetLabelTextForLocalize(e,t,a,...)
if not e or IsNil(e)then
GameInit.LogError('lable is null ')
return
end
local t=GameTools.GetLocalize(t,a,...)
LuaUtils.SetLabelText(e,t)
end
function UIUtil.SetTextMeshTextForLocalize(a,t,e,...)
local e=GameTools.GetLocalize(t,e,...)
a.text=e
end
function UIUtil.GetLocalize(e,t,...)
local e=GameTools.GetLocalize(e,t,...)
return e
end
function UIUtil.SetTextMeshText(e,t)
if e.text==t then
return
end
LuaUtils.SetTextMeshText(e,t)
end
function UIUtil.UIVideoAdapter(h,a)
local n=1560
local o=1680
if a==nil then a=n end
local e=CS.YouYou.GameEntry.Instance.UIRoot.rect
local i=e.width
local e=e.height
local e=n
local t=720
local s=a/720
if a>=o then
e=o
t=720
else
if i>=o then
e=o
t=e/s
elseif i>n then
e=i
t=e/s
else
t=720
e=t*s
end
end
local a=h.transform.sizeDelta
a.x=e
a.y=t
h.transform.sizeDelta=a
end
function UIUtil.HeroCanWatchLover(t)
local e=O.GetList()
for a,e in ipairs(e)do
if e.heroId==t and e.unlock==8 then
return true
end
end
return false
end
function UIUtil.GetFloorNum(t)
local e=tostring(t)
local e=string.split(e,".")
if#e>0 then
return tonumber(e[1])
else
return t
end
end
function UIUtil.GetFloorNum2(t,a)
local e=t
if a then
e=string.format(a,t)
else
e=math.floor(t)
end
local t,a=math.modf(e)
if a>0 then
return e
else
return t
end
end
function UIUtil.GetMonsterName(e,t)
local e=m.GetMonsterCfgData(e)
local e=e.GetEntity(t)
local t=""
if e then
t=GameTools.GetLocalize(e.monName,LanguageCategory.LangBattle)or""
end
return t
end
function UIUtil.SetTextColorQuality(t,e,a)
if a then
if e==nil or ColorQuality2Name[e]==nil then
t.color=ForgeColor["grey"]
else
local e=ColorQuality2Name[e]
t.color=ForgeColor[e]
end
else
if e==nil or ColorQuality2Name[e]==nil then
t.color=DefaultColor["grey"]
else
local e=ColorQuality2Name[e]
t.color=DefaultColor[e]
end
end
end
function UIUtil.GetRichTextByQuality(e,a,t)
local t=UIUtil.GetTextColor16ByQuality(a,t)
local e=string.format("<color=#%s>%s</color>",t,e)
return e
end
function UIUtil.GetTextColor16ByQuality(e,t)
if t then
if e==nil or ColorQuality2Name[e]==nil then
return Forge16Color["grey"]
else
local e=ColorQuality2Name[e]
return Forge16Color[e]
end
else
if e==nil or ColorQuality2Name[e]==nil then
return Default16Color["grey"]
else
local e=ColorQuality2Name[e]
return Default16Color[e]
end
end
end
function UIUtil.SetCommonHeader(a,i,t,o,n)
local e=LuaUtils.GetLuaComBinder(a.transform)
local e=e:GetComponents()
local s={e["currency1"],e["currency2"],e["currency3"]}
if t and string.len(t)>1 then
LuaUtils.SetTextMeshText(e['first_char'],string.sub(t,1,3))
LuaUtils.SetTextMeshText(e['other_char'],string.sub(t,2))
end
e['btn_close'].onClick:AddListener(
function()
GameTools.CloseUIForm(i)
end
)
if o then
e['btn_tanhao'].onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId=o})
end
)
else
LuaUtils.SetActive(e['btn_tanhao'].transform,false)
end
UIUtil.RefreshCommonHeader(a,n)
end
function UIUtil.RefreshCommonHeader(e,t)
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
local o={e["currency1"],e["currency2"],e["currency3"]}
for e=1,3 do
if t[e]then
local a=o[e]:GetComponents()
if t[e].currencyDid and t[e].currencyDid>0 then
local o=ModulesInit.BagManager:GetBaseInfo(t[e].currencyDid,true)
local e=ModulesInit.BagManager:GetItemCountById(t[e].currencyDid)
LuaUtils.SetTextMeshText(a['txt_act_name'],UIUtil.toBigNum3(e))
LuaUtils.SetImageSprite(a["im_zuanshi"],o.icon,false)
else
LuaUtils.SetTextMeshText(a['txt_act_name'],t[e].value)
LuaUtils.SetImageSprite(a["im_zuanshi"],t[e].iconPath,false)
end
if t[e].clickFunc then
a['btn_jia'].onClick:RemoveAllListeners()
a['btn_jia'].onClick:AddListener(t[e].clickFunc)
else
LuaUtils.SetActive(a['btn_jia'].transform,false)
end
else
LuaUtils.SetActive(o[e].transform,false)
end
end
end
function UIUtil.GetParabolaPathByPos(e,t,o,a,h,l)
local i={}
table.insert(i,e)
local r=math.abs(t.y-e.y)
local s,n
if t.y>e.y then
s=r+a
n=a
else
s=a
n=r+a
end
local a=math.sqrt(2*s/o)
local s=math.sqrt(2*n/o)
local n=math.abs(t.x-e.x)
local n=n/(a+s)
if t.x<e.x then
n=-n
end
local r=o*a
for d=1,h do
local a=(a+s)/h*d
local a=Vector3(e.x+n*a,e.y+r*a-o*a*a/2,0)
if l then
local e,t=UIUtil.getSymmetricPoint(a.x,a.y,e.x,e.y,t.x,t.y)
a=Vector3(e,t,0)
end
table.insert(i,a)
end
table.insert(i,t)
return i
end
function UIUtil.getSymmetricPoint(t,o,a,i,e,n)
if e==a then
return 2*a-t,o
end
local e=(n-i)/(e-a)
if e==0 then
return t,2*i-o
end
local i=i-e*a
local a=1+e*e
local n=((1-e*e)*t+2*e*o-2*e*i)/a
local e=(2*e*t-(1-e*e)*o+2*i)/a
return n,e
end
function UIUtil.DoCanvasGroupFade(a,t,i,o,e)
local a=a:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
if t~=nil then
a.alpha=t
end
local e=a:DOFade(i,o):OnComplete(function()
if e then
e()
end
end)
return e
end
function UIUtil.SetGroupVisible(t,a)
if a and not t.gameObject.activeSelf then
LuaUtils.SetActive(t.transform,a)
end
local o=a==true and 1 or 0
local e=t.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
if IsNil(e)then
e=t.gameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
end
e.blocksRaycasts=a
e.alpha=o
end
function UIUtil.SetCanvasGroupAlpha(e,t)
local e=e:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
e.alpha=t
end
function UIUtil.DoCanvasGroupFadeIn(e,a,t)
return UIUtil.DoCanvasGroupFade(e,0,1,a,t)
end
function UIUtil.DoCanvasGroupFadeOut(a,t,e)
return UIUtil.DoCanvasGroupFade(a,1,0,t,e)
end
function UIUtil.SetFormationHeadPos(e)
if e and not LuaUtils.IsNull(e)then
local t=e.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
if t and not LuaUtils.IsNull(t)then
t:SetLayoutHorizontal()
LuaUtils.RebuildLayout(e.transform)
local t=e.transform.pivot
local i,a,o=LuaUtils.GetLocalPos(e.transform)
local i=e.rect.width
LuaUtils.SetLocalPos(e.transform,i*t.x,a,o)
end
end
end
function UIUtil.DelayCall(t,o,a)
if UIUtil.SequenceListMap==nil then
UIUtil.SequenceListMap={}
end
if UIUtil.SequenceListMap[t]==nil then
UIUtil.SequenceListMap[t]={}
end
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(o)
e:AppendCallback(function()
if a then
a()
end
end)
table.insert(UIUtil.SequenceListMap[t],e)
return e
end
function UIUtil.StopSequence(t,a)
local e=nil
if UIUtil.SequenceListMap and UIUtil.SequenceListMap[t]then
e=UIUtil.SequenceListMap[t]
end
if e then
for t,e in pairs(e)do
UIUtil.KillTweener(e)
end
end
e=nil
if a then
a()
end
end
function UIUtil.KillTweener(e)
if e~=nil then
e:Kill()
e=nil
end
end
function UIUtil.GetLocalPosVector(e)
local t,a,e=LuaUtils.GetLocalPos(e)
return Vector3(t,a,e)
end
function UIUtil.SetImageAlpha(e,a)
local t=e.color
t.a=a
e.color=t
end
function UIUtil.ChangeSkeletonGraphic(t,o,a)
LuaUtils.DestroyImmediateChildren(t.transform)
local e=t:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
if e then
e.enabled=false
end
GameTools:PoolGameObjectSpawnWithPath(
o,
nil,
function(e,o,o)
LuaUtils.SetParent(e,t)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
if a then a(e)end
end
)
end
function UIUtil.CleanChildrenAndDespawn(e)
local t=LuaUtils.GetChildrenCount(e.transform)
if t>0 then
for t=t,1,-1 do
local e=UIUtil.GetChild(e.transform,t-1)
GameEntry.Pool:GameObjectDespawn(e)
end
end
end
function UIUtil.GetAttrDesc(t,a)
a=a or","
local e=""
for o=1,#t do
local i=t[o][1]
local o=t[o][2]
local t=b.GetEntity(i)
local t=GameTools.GetLocalize(t.attrName,LanguageCategory.LangBattle)
local o=m:clientAttrShowValue(i,o)
if e==""then
e=t.."+"..o
else
e=e..a..t.."+"..o
end
end
return e
end
function UIUtil.ShowAwardWithServerData(e,i,o)
if e==nil or#e<=0 then
return
end
local t={}
for a=1,#e do
local e=e[a]
table.add(t,{itemDid=e.thingDid,count=e.thingCount,itemId=e.thingId,magicType=e.magicType})
end
GameEntry.UI:OpenUIForm(UIFormId.UI_RewardsShow,{infos=t,isAutoClose=o,isCloseCallBack=i})
end
function UIUtil.ShowAwardWordTip(t,a,e)
local e={settingData=e}
local t={
itemId=t,
itemCount=a,
}
table.insert(e,t)
UIUtil.ShowCommonItemTips(e)
end
function UIUtil.ShowServerAward(e)
local a=e.isOrchardAddGold
local t=e.isOrchardAddSeasonEquip
if ModulesInit.AutoHelperMgr.isAuto==true then
return
end
if e.award.showType==PROTO_ENUM.ENUM_AWARD_SHOW_TYPE.BOX then
local t={}
for a=1,#e.award.rewardThings do
local e=e.award.rewardThings[a]
table.add(t,{itemDid=e.thingDid,count=e.thingCount,itemId=e.thingId,magicType=e.magicType})
end
local o=e.award.addActiveCollectibles
ModulesInit.CollectiblesMgr:OnOneByOneShowCollectibles(o,nil,function()
local o=e.award.sourceType==PROTO_ENUM.ENUM_AWARD_SOURCE_TYPE.MAIL
GameEntry.UI:OpenUIForm(UIFormId.UI_RewardsShow,{infos=t,closeAni=o,isOrchardAddGold=a,
activePetDids=e.award.activePetDids})
end)
if#t<=0 then
GameInit.LogError("服务器发过来的：奖励获得---------------没有物品")
end
elseif e.award.showType==PROTO_ENUM.ENUM_AWARD_SHOW_TYPE.HINT then
local a={}
for t=1,#e.award.rewardThings do
a[t]={}
a[t].itemId=e.award.rewardThings[t].thingDid
a[t].itemCount=e.award.rewardThings[t].thingCount
end
UIUtil.ShowCommonItemTips(a)
end
end
function UIUtil.GetItemIconPath(e,t)
if e==nil or e==""then
return e
end
if q[e]then
return q[e]
else
if t==false then
GameEntry.LogError("图标导出路径表DTItemIconPath中没有查询到道具名称为:"..e.."的配置信息,请检查DTItemIconPath是否需要重新导出更换")
end
return e
end
end
function UIUtil.GuildGiftCfgGetItemIconPath(e)
local e=e
if string.find(e,"itemicon_")then
e=UIUtil.GetItemIconPath(e)
end
return e
end
function UIUtil.FindCircumcenter(t,e,a)
local i=t.x
local r=t.y
local t=e.x
local e=e.y
local h=a.x
local d=a.y
local a=(i+t)/2
local s=(r+e)/2
local o=(t+h)/2
local n=(e+d)/2
local i=(e-r)/(t-i)
local t=(d-e)/(h-t)
local e=-1/i
local t=-1/t
local h=math.abs(e)<=0.000001
local i=math.abs(t)<=0.000001
if h then
if i then
return nil
else
local e=n-t*o
return Vector3(a,t*a+e,0)
end
elseif i then
local t=s-e*a
return Vector3(o,e*o+t,0)
else
local a=s-e*a
local o=n-t*o
local t=(o-a)/(e-t)
local e=e*t+a
return Vector3(t,e,0)
end
end
function UIUtil.GetAngleAroundCenter(e,t)
local e=e-t
local e=Mathf.Atan2(e.y,e.x)*Mathf.Rad2Deg
return e
end
function UIUtil.GetArcRoutePosList(a,t,o,i,e)
local t=UIUtil.FindCircumcenter(a,t,o)
local n=Vector3.Distance(t,a)
local s=UIUtil.GetAngleAroundCenter(a,t)
local a=UIUtil.GetAngleAroundCenter(o,t)
if e==nil then
e={}
end
for o=1,i do
local o=o/i
local a=Mathf.LerpAngle(s,a,o)
local t=t+Quaternion.Euler(0,0,a)*(Vector3.right*n)
table.add(e,t)
end
return e
end
function UIUtil.ToDoubleSize(e)
if e<10 then
return tostring(0 ..e)
else
return tostring(e)
end
end
function UIUtil.HandlerQualityImgShow(t,e,a)
local e=a[e]
if e==nil then
e=a["default"]
end
LuaUtils.SetLocalScale(t.transform,e.scale.x,e.scale.y,e.scale.z)
t.transform.anchoredPosition=Vector2(e.pos.x,e.pos.y)
end
function UIUtil.HandlerHeroQualityImgEff(e,t,i,a)
LuaUtils.SetChildrenActive(e.transform,false)
local o=LuaUtils.GetChildrenCount(e.transform)
if o>0 and i then
if t==Quality.LR then
local o=e.transform:Find("un_quality_"..t)
LuaUtils.SetActive(o.transform,a==nil or a==false)
local e=e.transform:Find("sp_quality_"..t)
LuaUtils.SetActive(e.transform,a==true)
end
end
end
function UIUtil.HandlerMarryPlusEff(a,e)
local e=LuaUtils.GetLuaComBinder(e.transform)
local t=e:GetComponents()
if t["YouYouImage"]then
local e=""
if ModulesInit.MarryManager:IsMarryPlus(a)then
e="UIMarry/hjbk_mzbgx"
else
e="UIMarry/hjbk_mzbg"
end
LuaUtils.SetImageSprite(t["YouYouImage"],e,false)
end
end
function UIUtil.SetImageColor(t,e)
t.color=e
end
function UIUtil.OnGapTimePrintLog(o,a,t,e)
UIUtil.OnGapTimeDoCallBak(o,a,t,function()

end)
end
function UIUtil.OnGapTimeDoCallBak(t,i,a,o)
if UIUtil.printTimeCacheMap==nil then
UIUtil.printTimeCacheMap={}
end
local e=false
if UIUtil.printTimeCacheMap[t]==nil then
UIUtil.printTimeCacheMap[t]={lastPrintTime=0,comperValue=a,}
e=true
end
local t=UIUtil.printTimeCacheMap[t]
if e==false then
if TimeUtil.GetServerMillTimeStamp()-t.lastPrintTime>=i then
e=true
elseif a~=t.comperValue then
e=true
end
end
if e then
t.lastPrintTime=TimeUtil.GetServerMillTimeStamp()
t.comperValue=a
if o then
o()
end
end
end
function UIUtil.SetPopUILightSMaskTex(e,t,o)
if IsNil(e)or IsNil(t)then
return
end
local a=e.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
if a~=nil then
local e=a:GetComponent(typeof(CS.UnityEngine.ParticleSystemRenderer))
if IsNil(e)==false then
local t=GameTools:LoadOriginSpriteWithFullPath(o)
if t then
GameTools:ReleaseOriginSpriteWithFullPath(o)
e.material:SetTexture("_SMaskTex",t.texture)
end
end
end
e.transform.localScale=Vector3(t.transform.sizeDelta.x,t.transform.sizeDelta.y,1)
end
function UIUtil.GetAttrName(t,a)
local e=b.GetEntity(t)
if e==nil then
return t
end
local t=GameTools.GetLocalize(CampTypeLang[a],LanguageCategory.LangCommon)
local e=GameTools.GetLocalize(e.attrName,LanguageCategory.LangBattle,t)
return e
end
function UIUtil.ShowTransformWithDuration(e,t,a)
e:DOKill()
if t then
LuaUtils.SetActive(e.transform,t)
local t,o,o=LuaUtils.GetLocalPos(e)
e:DOLocalMoveX(t,a):OnComplete(
function()
LuaUtils.SetActive(e.transform,false)
end
)
else
LuaUtils.SetActive(e.transform,false)
end
end
function UIUtil.toRate(o,t,a)
a=a or 2
t=t or 10000
local e=o*100/t
if o*100%t==0 then
e=math.floor(e)
else
e=string.format("%.0"..a.."f",e)
while string.sub(e,-1)=="0"do
e=string.sub(e,1,-2)
end
if string.sub(e,-1)=="."then
e=string.sub(e,1,-2)
end
end
e=e.."%"
return e
end
function UIUtil.toRate2(o,t,a)
a=a or 2
t=t or 10000
local e=o*100/t
if o*100%t==0 then
e=math.floor(e)
else
e=string.format("%.0"..a.."f",e)
while string.sub(e,-1)=="0"do
e=string.sub(e,1,-2)
end
if string.sub(e,-1)=="."then
e=string.sub(e,1,-2)
end
end
return e
end

