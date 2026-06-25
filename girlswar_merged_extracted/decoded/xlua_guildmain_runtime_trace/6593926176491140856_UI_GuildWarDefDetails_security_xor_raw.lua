local e=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local a=0
local e=ModulesInit.CSGuildWarManager
local t=nil
function OnInit(a,a)
bg.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarDefDetails)
end
)
btn_ok.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarDefDetails)
end
)
im_record.onClick:AddListener(
function()
local a=e:SendSeePlayerRecordRequest(e.CurReqBattleGroundInfo.battleGroundId,t.playerInfo.playerId)
a.onCompleted=function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarDefDetails)
GameEntry.UI:OpenUIForm(UIFormId.UI_CSGuildWarRecord,{playerInfo=t.playerInfo,isDef=true,records=e.CurReqPlayerRecord.records})
end
end
)
end
function OnOpen(e)
a=#HeroMgr:GetAllBaseHeroCfgList()
t=e
local e=t.playerInfo
if not t.isOnwer then
GameTools:SetImageSprite(bg_camp,'UILegion/juntuan_frame_red',false)
else
GameTools:SetImageSprite(bg_camp,'UILegion/juntuan_frame_blue',false)
end
UIUtil.SetPlayerIconFrame(head_yuan150,e)
LuaUtils.SetLabelTextWrap(txt_lv,e.level)
LuaUtils.SetTextMeshText(txt_name,e.name)
LuaUtils.SetLabelTextWrap(txt_fight,e.fight)
LuaUtils.SetLabelTextWrap(txt_guild,e.guildName)
LuaUtils.SetLabelTextWrap(txt_first,e.ownHeroCount,a)
LuaUtils.SetLabelText(txt_def_fight,e.defFightValue)
LuaUtils.SetLabelText(txt_def_first,e.totalFirstValue)
if e.leftHpGrade<=0 then
LuaUtils.SetLabelText(txt_1,string.format('<color=red>%d</color>',e.leftHpGrade))
else
LuaUtils.SetLabelText(txt_1,string.format('<color=#498CF9>%d</color>',e.leftHpGrade))
end
LuaUtils.SetLabelText(txt_2,e.gainGrade)
SetFormation()
end
function SetFormation()
local t=t.playerInfo
local a=#t.heros+#t.alterHeros
local o=function(e)
for a,t in pairs(t.heros)do
if t.heroId==e then
return t
end
end
for a,t in pairs(t.alterHeros)do
if t.heroId==e then
return t
end
end
return nil
end
LuaUtils.SetChildrenActive(Content,false)
for e=1,a do
local i=t.heroOrders[e]
local o=o(i)
local e=UIUtil.GetChild(Content,e-1)
if not e then
e=LuaUtils.Instantiate(item)
LuaUtils.SetParent(e,Content)
LuaUtils.SetLocalScale(e,0.8,0.8,0.8)
end
LuaUtils.SetActive(e,true)
local a=e:Find('body')
local n=e:Find('enemy')
if o then
LuaUtils.SetActive(a,true)
LuaUtils.SetActive(n,false)
UIUtil.SetHeroHead(a:Find('head90'),o,false)
local e=o.curHp/o.totalHp
if e<0 then
e=0
end
local n=LuaUtils.GetLuaComBinder(a:Find('head90'))
local n=n:GetComponents()
LuaUtils.SetImageFillAmount(a:Find('im_hp_1'):GetComponent(typeof(CS.UnityEngine.UI.Image)),e)
UIUtil.SetGray(a,o.curHp<=0)
local e=false
for a,t in pairs(t.heros)do
if t.heroId==i then
e=true
end
end
if e then
GameTools:SetImageSprite(n["im_zhan"],'UICommonOther/multilang_IC_buzhen_chuzhan')
else
GameTools:SetImageSprite(n["im_zhan"],'UICommonOther/multilang_IC_fuxiaotb')
end
else
LuaUtils.SetActive(a,false)
LuaUtils.SetActive(n,true)
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

