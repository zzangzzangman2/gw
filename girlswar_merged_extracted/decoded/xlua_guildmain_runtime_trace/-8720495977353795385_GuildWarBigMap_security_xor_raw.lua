local o=require("Common/cs_coroutine")
local a=table.add
local e=Class("GuildWarBigMap",{})
function e:__init()
self.transform=0
self.COMS={}
self.openData={}
self.units={}
self.unitViews={}
self.unitsPosMap={}
self.CFG={}
self.CurBattleInfo=0
self.prevSelect=0
self.reliveTimerList={}
self.mapCtr=nil
end
function e:Init(e)
self.transform=e
self.CFG=ModulesInit.CSGuildWarManager:GetGuildWarDBCfg()
self.mapCtr=self.transform:GetComponent(typeof(CS.YouYou.GuildWarMapCtr))
local e=LuaUtils.GetLuaComBinder(self.transform)
self.COMS=e:GetComponents()
self.COMS["root"].onClick:AddListener(
function()
if self.prevSelect~=0 then
LuaUtils.SetActive(self.prevSelect["select"],false)
LuaUtils.SetActive(self.prevSelect["btn_root"],false)
end
end
)
end
function e:Open()
self:ReleaseMapRes()
self:OnGuildWarBattleInfoSync()
self:OnCreate()
end
function e:OnCreate()
self.units={our={},enemy={}}
local e=self.COMS["our"]
local t=LuaUtils.GetChildrenCount(e)
for t=1,t do
local e=e:Find(string.format("point_%d",t))
if not e then
GameEntry.LogError("找不到本军团出生点"..t)
else
a(self.units.our,e)
LuaUtils.SetRotation(e,0,0,0)
end
end
local e=self.COMS["enemy"]
t=LuaUtils.GetChildrenCount(self.COMS["enemy"])
for t=1,t do
local e=e:Find(string.format("point_%d",t))
if not e then
GameEntry.LogError("找不到敌人军团出生点"..t)
else
a(self.units.enemy,e)
LuaUtils.SetRotation(e,0,0,0)
end
end
end
function e:CreateUnitViews(a)
return o.start(
function()
self.unitViews={}
local o=function(t,o,a)
local e=LuaUtils.Instantiate(self.COMS["unit"])
LuaUtils.SetParent(e,t)
LuaUtils.SetActive(e,true)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetLocalScale(e,1,1,1)
self:SetUnitView(e,o,a)
self:SetUnitStyle(e,false)
return e
end
local e=self.CurBattleInfo.ownerInfo.players
for t=1,#e do
local e=e[t]
local t=self.units.our[t]
local i=o(t,e,true)
local a,o,t=LuaUtils.GetPos(t)
self.unitViews[e.playerId]=LuaUtils.GetLuaComBinder(i)
self.unitsPosMap[e.playerId]={x=a,y=o,z=t}
end
coroutine.yield(CS.UnityEngine.WaitForSeconds(0.05))
local t=self.CurBattleInfo.targetInfo.players
for a=1,#t do
local e=t[a]
local t=self.units.enemy[a]
local i=o(t,e,false)
local o,a,t=LuaUtils.GetPos(t)
self.unitViews[e.playerId]=LuaUtils.GetLuaComBinder(i)
self.unitsPosMap[e.playerId]={x=o,y=a,z=t}
end
self:SetBound(e,t)
if a then
a()
end
end
)
end
function e:SetBound(e,t)
local a=#e
local o=#t
local t,e,i=0,0,0
local i,i=0,0
if a<=5 then
t=544
else
t=544+math.ceil((a-5)/5)*250
end
if o<=5 then
e=544
else
e=544+math.ceil((o-5)/5)*250
end
local a=414/2
e=e+a
t=-t-a
LuaUtils.SetRectTransformPos(self.COMS["Image_enemy"],0,e,0)
LuaUtils.SetRectTransformPos(self.COMS["Image_owner"],0,t,0)
local o=e+a
local e=-(t-a)
self.mapCtr:SetBound(-10,1,-e,o,o,e)
self:OnUpdateNotBattleImg()
end
function e:SelectUnit(a)
local e=a.playerId

if self.prevSelect~=0 then
LuaUtils.SetActive(self.prevSelect["select"],false)
LuaUtils.SetActive(self.prevSelect["btn_root"],false)
end
local t=self.unitViews[e]
if t then
self:SetUnitStyle(t.transform,false)
local t=t:GetComponents()
LuaUtils.SetActive(t["select"],true)
LuaUtils.SetActive(t["btn_root"],true)
local o=ModulesInit.CSGuildWarManager:SelfIsCanJoin()
local n=ModulesInit.CSGuildWarManager:GetGuildWarStage()
local i=ModulesInit.CSGuildWarManager:PlayerIsResurrection(a)
local a=LuaUtils.GetLuaComBinder(t["bg_diban"])
local a=a:GetComponents()
if not self:PlayerIsOnwer(e)and n==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.FIGHTING and o and not i then
LuaUtils.SetActive(a["btn_attr"].transform,true)
UIUtil.SetGray(a["btn_attr"].transform,self.CurBattleInfo.attCount>=self.CFG.attackTime)
else
LuaUtils.SetActive(a["btn_attr"].transform,false)
end
self.prevSelect=t
end
self:MoveToUnit(e)
end
function e:UpdateUnitView(e,t,a)
self:SetUnitView(e,t,a)
end
function e:SetUnitStyle(e,t)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
if t==true then
LuaUtils.SetActive(e["bg_diban"],false)
elseif t==false then
LuaUtils.SetActive(e["bg_diban"],true)
end
LuaUtils.SetActive(e["select"],false)
LuaUtils.SetActive(e["btn_root"],false)
end
function e:SetUnitView(e,t,o)
local a=LuaUtils.GetLuaComBinder(e)
local e=a:GetComponents()
self:SetDetailedUnit(e["bg_diban"],t,o)
self:CheckRelive(t,e,a)
self:CheckUnderAttack(t,e)
LuaUtils.GetUIEventListener(e["click_collider"]).onClick=function()
self:SelectUnit(t)
end
return e
end
function e:SetDetailedUnit(e,a,o)
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
LuaUtils.SetActive(e["im_hp1"],false)
LuaUtils.SetActive(e["im_hp2"],false)
LuaUtils.SetActive(e["im_hp3"],false)
LuaUtils.SetActive(e["online"],false)
LuaUtils.SetActive(e["offline"],false)
LuaUtils.SetActive(e["btn_attr"].transform,false)
LuaUtils.SetLabelText(e["txt_name"],a.name)
LuaUtils.SetLabelText(e["txt_power"],UIUtil.toBigNum(a.fight))
LuaUtils.SetLabelText(e["txt_chance"],a.leftGrade)
LuaUtils.SetChildrenActive(e["hero_grid"],false)
LuaUtils.SetTextMeshText(e["txt_title"],a.leftAttCount)
if not o then
LuaUtils.SetActive(e["im_hp3"],true)
else
if a.playerId~=PlayerMgr.PlayerInfo.uid then
LuaUtils.SetActive(e["im_hp2"],true)
else
LuaUtils.SetActive(e["im_hp1"],true)
end
end
local i=function(e)
for a,t in pairs(a.heros)do
if t.heroId==e then
return t
end
end
for a,t in pairs(a.alterHeros)do
if t.heroId==e then
return t
end
end
return nil
end
LuaUtils.SetChildrenActive(e["hero_grid"],false)
for t=1,6 do
local a=a.heroOrders[t]
local a=i(a)
local t=UIUtil.GetChild(e["hero_grid"],t-1)
if not t then
t=LuaUtils.Instantiate(e["head_item"])
LuaUtils.SetParent(t,e["hero_grid"])
LuaUtils.SetLocalScale(t,1,1,1)
LuaUtils.SetLocalPos(t,0,0,0)
end
LuaUtils.SetActive(t,true)
local e=LuaUtils.GetLuaComBinder(t)
local e=e:GetComponents()
if not a then
LuaUtils.SetChildActive(t,"body",false)
LuaUtils.SetChildActive(t,"select",true)
else
LuaUtils.SetChildActive(t,"body",true)
LuaUtils.SetChildActive(t,"select",false)
UIUtil.SetHeroHead2(e["im_head"],a)
if a.curHp==0 then
LuaUtils.SetActive(e["im_x"],true)
LuaUtils.SetImageFillAmount(e["im_hp"],0)
UIUtil.SetSpriteRenderGray2(e["im_head"],true)
else
LuaUtils.SetActive(e["im_x"],false)
LuaUtils.SetImageFillAmount(e["im_hp"],a.curHp/a.totalHp)
UIUtil.SetSpriteRenderGray2(e["im_head"],false)
end
end
end
LuaUtils.GetUIEventListener(e["btn_detailed"]).onClick=function()
local e=ModulesInit.CSGuildWarManager:GetPlayerInfo(self.CurBattleInfo,a.playerId)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarDefDetails,{playerInfo=e,isOnwer=o})
end
LuaUtils.GetUIEventListener(e["btn_attr"]).onClick=function()
self:OnBattle(a)
end
end
function e:ResetMap()
self.mapCtr:Reset()
if self.prevSelect~=0 then
LuaUtils.SetActive(self.prevSelect["select"],false)
LuaUtils.SetActive(self.prevSelect["btn_root"],false)
end
end
function e:MoveToUnit(e)
local e=self.unitViews[e].transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
self.mapCtr:SlideToSpecificPoint(e)
end
function e:OnGuildWarBattleInfoSync()
self.CurBattleInfo=ModulesInit.CSGuildWarManager.CurBattleInfo
if self.CurBattleInfo~=0 then
local e=self.CurBattleInfo.ownerInfo.players
for e,t in pairs(e)do
local e=self.unitViews[t.playerId]
if e then
self:UpdateUnitView(e.transform,t,true)
end
end
local e=self.CurBattleInfo.targetInfo.players
for t,e in pairs(e)do
local t=self.unitViews[e.playerId]
if t then
self:UpdateUnitView(t.transform,e,false)
end
end
end
self:OnUpdateNotBattleImg()
end
function e:CheckRelive(e,t,o)
local a=ModulesInit.CSGuildWarManager:PlayerIsResurrection(e)
if a then
local i=e.rebornStampTime-TimeUtil.serverTimeStep
self:StopReliveTimer(e.playerId)
local a=ModulesInit.TimeActionMgr:CreateTimeAction()
a:Init(
0,
1,
i,
nil,
function(e)
if not IsNil(t["text_reliving1"])then
LuaUtils.SetLabelText(t["text_reliving1"],TimeUtil.toDHMSStr2(e))
end
end,
function()
self:Relive(e,t,o.transform)
self.reliveTimerList[e.playerId]=nil
end
):Run()
if self.reliveTimerList[e.playerId]then
self.reliveTimerList[e.playerId]:Stop()
end
self.reliveTimerList[e.playerId]=a
LuaUtils.SetActive(t["reliving1"],true)
else
LuaUtils.SetActive(t["reliving1"],false)
end
end
function e:CheckUnderAttack(e,t)
local e=ModulesInit.CSGuildWarManager:PlayerIsUnderAttack(e)
LuaUtils.SetActive(t["fighing"],e)
end
function e:Relive(a,o,t)
for o,e in pairs(self.CurBattleInfo.ownerInfo.players)do
if e.playerId==a.playerId then
e.curHp=e.totalHp
for t=1,#e.heros do
local e=e.heros[t]
e.curHp=e.totalHp
end
self:UpdateUnitView(t,e,true)
return
end
end
for o,e in pairs(self.CurBattleInfo.targetInfo.players)do
if e.playerId==a.playerId then
e.curHp=e.totalHp
for t=1,#e.heros do
local e=e.heros[t]
e.curHp=e.totalHp
end
self:UpdateUnitView(t,e,false)
return
end
end
if not IsNil(o["reliving1"])then
LuaUtils.SetActive(o["reliving1"],false)
end
end
function e:OnBattle(e)
local t=ModulesInit.CSGuildWarManager
if t:PlayerIsUnderAttack(e)then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.battlefield.22")
return
end
if e.curHp<=0 then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.battlefield.20")
return
end
if self.CurBattleInfo.attCount>=self.CFG.attackTime then
UIUtil.ShowCommonTipsForLocalize("UI.guildBattle.battlefield.18")
return
end
DynamicModuleRes.EmbattlePrevDownLoad(false,
e.defMainFormation,
e.defAlterFormation,
e.summonPets,
function()
GameEntry.UI:OpenUIForm(
UIFormId.UI_GuildWarEmbattle,
{
enemyFightTotal=e.fight,
isNpc=false,
enemyFormaData=e.defMainFormation,
enemyFormaData2=e.defAlterFormation,
playerInfo=e,
attHeroIds=self.CurBattleInfo.attHeroIds,
summonPets=e.summonPets,
summonPetFormation=e.summonPetFormation,
onStartBattle=function(a,o)
local a=t:SendStartBattleRequest(self.CurBattleInfo.battleGroundId,a,o,e.playerId)
a.onCompleted=function()
ModulesInit.GuildMgr:ClearWarFightRed()
t:EnterBattle({headPath=nil,headId=e.head,name=e.name,level=e.level})
end
end
}
)
end)
end
function e:OnCutUnitStyle(e)
if e then
for t,e in pairs(self.unitViews)do
self:SetUnitStyle(e.transform,false)
end
if self.prevSelect~=0 then
LuaUtils.SetActive(self.prevSelect["select"],false)
LuaUtils.SetActive(self.prevSelect["btn_root"],false)
end
else
for t,e in pairs(self.unitViews)do
self:SetUnitStyle(e.transform,false)
end
end
end
function e:PlayerIsOnwer(t)
for a,e in pairs(self.CurBattleInfo.ownerInfo.players)do
if e.playerId==t then
return true
end
end
return false
end
function e:OnUpdateNotBattleImg()
local e=ModulesInit.CSGuildWarManager:GetGuildWarStage()
if e==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING then
LuaUtils.SetActive(self.COMS["img_no"],true)
else
LuaUtils.SetActive(self.COMS["img_no"],false)
end
end
function e:OnGuildWarStageSync()
self:ResetMap()
end
function e:Close()
if self.prevSelect and self.prevSelect~=0 then
LuaUtils.SetActive(self.prevSelect["select"],false)
LuaUtils.SetActive(self.prevSelect["btn_root"],false)
end
if self.reliveTimerList then
for t,e in pairs(self.reliveTimerList)do
e:Stop()
end
end
self.reliveTimerList={}
local e={}
for a,t in pairs(self.unitViews)do
table.add(e,t)
end
for t=#e,1,-1 do
GameObject.Destroy(e[t].gameObject)
end
self.prevSelect=0
self.unitViews={}
self:ReleaseMapRes()
end
function e:StopReliveTimer(e)
if e then
local t=self.reliveTimerList[e]
if t then
t:Stop()
self.reliveTimerList[e]=nil
end
end
end
function e:ReleaseMapRes()
end
return e

