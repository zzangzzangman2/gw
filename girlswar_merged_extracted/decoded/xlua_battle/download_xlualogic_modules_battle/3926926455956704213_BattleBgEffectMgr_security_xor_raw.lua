local e=Class("BattleBgEffectMgr",{})
local a={
None=0,
LoadEffect=1,
UnloadEffect=2,
}
function e:Create()
local e=e:New()
e:Init()
return e
end
function e:Init()
self:ResetData()
end
function e:ResetData()
self.effectDataList={}
self.hideEffectDataList={}
self.effectPrefabDic={}
self.effectData=nil
self.isAutoRunning=false
self.bgIndex=0
self.timerMap={}
end
function e:Dispose()
self:StopAllTimer()
self:CleanEffect()
self:ResetData()
end
function e:CleanEffect()
for t,e in pairs(self.effectPrefabDic)do
self:UnloadEffect(e.prefabId,0,false)
end
end
function e:SetAutoRunning(e)
self.isAutoRunning=e
end
function e:ResortAndShowBgEffect()
self:ResortBgEffect()
self:CheckShowBgEffect()
end
function e:ResortBgEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
table.sort(self.effectDataList,function(t,e)
if t.TeamId~=e.TeamId then
return t.TeamId>e.TeamId
end
if t.battleStationIndex~=e.battleStationIndex then
return t.battleStationIndex>e.battleStationIndex
end
if t.HeroId~=e.HeroId then
return t.HeroId>e.HeroId
end
return t.bgIndex<e.bgIndex
end)
end
function e:ShowBgEffect(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
e.bgIndex=self:GetNextBgIndex()
self.isEffectChange=true
table.insert(self.effectDataList,e)
end
function e:HideBgEffect(e)
if(GameInit.IsClient==false)then
return
end
self.isEffectChange=true
table.insert(self.hideEffectDataList,e)
for t=1,#self.effectDataList do
local a=self.effectDataList[t]
if self:IsSameEffectData(a,e)then
table.remove(self.effectDataList,t)
break
end
end
end
function e:IsSameEffectData(t,e)
if t.HeroId==e.HeroId
and t.buffId==e.buffId
and t.prefabId==e.prefabId then
return true
end
return false
end
function e:FindHideEffectData(t)
for e=1,#self.hideEffectDataList do
local e=self.hideEffectDataList[e]
if self:IsSameEffectData(e,t)then
return e
end
end
end
function e:OnUpdate()
if GameInit.IsClient==false then
return
end
if self.isAutoRunning==false then
return
end
if self.isEffectChange==false then
return
end
self:ResortAndShowBgEffect()
end
function e:CheckShowBgEffect()
if GameInit.IsClient==false then
return
end
self.isEffectChange=false
local e=#self.effectDataList
local e=self.effectDataList[e]
local t=a.None
if e==nil then
if self.effectData then
t=a.UnloadEffect
end
elseif self.effectData==nil then
t=a.LoadEffect
else
if self:IsSameEffectData(self.effectData,e)==false then
t=a.LoadEffect
end
end
if t==a.LoadEffect then
ModulesInit.ProcedureNormalBattle.ShowScenePrefabTrans(true)
self:RemoveCurEffect()
self.effectData=e
self:LoadEffect(e.prefabId,
e.targetPosX,
e.targetPosY,
e.targetPosZ,
e.delay,
e.fadeIn,
e.bShowSpeed,
function(t)
if e.onComplete then
e.onComplete(t)
end
if e.isEnvironmentEffect~=true then
ModulesInit.ProcedureNormalBattle.ShowScenePrefabTrans(false)
end
end
,
e.isFlip)
elseif t==a.UnloadEffect then
ModulesInit.ProcedureNormalBattle.ShowScenePrefabTrans(true)
self:RemoveCurEffect()
end
self.hideEffectDataList={}
end
function e:RemoveCurEffect()
if self.effectData then
local e=self:FindHideEffectData(self.effectData)
if e then
self:UnloadEffect(e.prefabId,e.fadeOut,e.bShowSpeed)
else
self:UnloadEffect(self.effectData.prefabId,0,self.effectData.bShowSpeed)
end
self.effectData=nil
end
end
function e:LoadEffect(t,l,d,o,s,h,r,n,i)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=self.effectPrefabDic[t]
if(e==nil)then
e={prefabId=t,
trans=nil,
effectId=0
}
self.effectPrefabDic[t]=e
local a=ModulesInit.TimeActionMgr.CreateTimeAction()
ModulesInit.ProcedureNormalBattle.AddTimer(a)
a:Init(
0,
s,
1,
nil,
nil,
function()
ModulesInit.ProcedureNormalBattle.RemoveTimer(a)
GameEntry.Effect:ShowBuffEffect(
t,
0,
0,
l,
d,
o,
nil,
function(s,t,a)
if type(i)=="boolean"then
local e,o,a
e,o,a=LuaUtils.GetLocalScale(t,e,o,a)
if(e>0 and i==true)or(e<0 and i==false)then
e=-e
end
LuaUtils.SetLocalScale(t,e,o,a)
end
e.trans=t
e.effectId=s
local a=t:GetComponent(typeof(CS.YouYou.ScrollScene))
if not IsNil(a)then
local e=1
if ModulesInit.ProcedureNormalBattle.CurrBattleRow then
e=ModulesInit.ProcedureNormalBattle.CurrBattleRow.PreloadMapItemCount
end
a:SetPreloadCount(e)
end
self:SetEffectAnimIdle(e)
if(n)then
n(e)
end
if r~=false then
ModulesInit.BattleSkillEffectManager.FadeInSpeedLine(t.gameObject,h)
end
end
)
end
):Run()
end
end
function e:UnloadEffect(t,a,o)
if(GameInit.IsClient==false)then
return
end
local e=self.effectPrefabDic[t]
if(e)then
self:StopTimer(t)
if a<=0 then
GameEntry.Effect:RemoveEffect(e.effectId)
self.effectPrefabDic[t]=nil
if o~=false and e.trans then
ModulesInit.BattleSkillEffectManager.FadeOutSpeedLine(e.trans.gameObject,a)
end
else
if o~=false and e.trans then
ModulesInit.BattleSkillEffectManager.FadeOutSpeedLine(e.trans.gameObject,a)
end
local o=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(t,o)
o:Init(
a,
1,
1,
nil,
nil,
function()
self:RemoveTimer(t)
GameEntry.Effect:RemoveEffect(e.effectId)
self.effectPrefabDic[t]=nil
end
):Run()
end
end
end
function e:SetEffectMaterialPropertyFloatByData(e,t,a)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(e and e.trans)then
if e.prefabId==Constant.zhugeliang_rain_effect then
LuaUtils.SetMaterialPropertyFloat(e.trans,t,a)
end
end
end
function e:SetEffectMaterialPropertyFloat(t,a,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local t=self.effectPrefabDic[t]
self:SetEffectMaterialPropertyFloatByData(t,a,e)
end
function e:SetCurBgEffectAnimRun(t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if self.effectData then
local e=self.effectPrefabDic[self.effectData.prefabId]
self:SetBgEffectAnimRun(e,t)
end
end
function e:SetBgEffectAnimRun(e,t)
self:SetEffectMaterialPropertyFloatByData(e,"_Speed",0.2)
if e and e.trans then
local e=e.trans:GetComponent(typeof(CS.YouYou.ScrollScene))
if not IsNil(e)then
e:Move(true,t)
end
end
end
function e:SetCurEffectAnimIdle()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if self.effectData then
local e=self.effectPrefabDic[self.effectData.prefabId]
self:SetEffectAnimIdle(e)
end
end
function e:SetEffectAnimIdle(e)
self:SetEffectMaterialPropertyFloatByData(e,"_Speed",0)
end
function e:GetNextBgIndex()
self.bgIndex=self.bgIndex+1
return self.bgIndex
end
function e:AddTimer(e,t)
self.timerMap[e]=t
end
function e:StopTimer(e)
if self.timerMap[e]then
self.timerMap[e]:Stop()
self.timerMap[e]=nil
end
end
function e:RemoveTimer(e)
self.timerMap[e]=nil
end
function e:StopAllTimer()
if(GameInit.IsClient)then
for t,e in pairs(self.timerMap)do
e:Stop()
end
self.timerMap={}
end
end
return e 
