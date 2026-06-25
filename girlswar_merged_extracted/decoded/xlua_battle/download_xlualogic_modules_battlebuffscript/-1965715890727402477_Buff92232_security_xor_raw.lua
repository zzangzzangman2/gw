local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[4]
local o=t[5]
if o==1 then
o=0
for o=1,#a do
local a=a[o]
local o=a.floors
if o>=t[1]then
local s=a.buff_pro
local o=t[2]
local n=t[3]
local n=e.CurrHeroCtrl:CheckAddBuff(s,e.CurrHeroCtrl,o,n)
if e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
i.ClearAllMatesCurseFloors(e,t,a.treasureHeroId)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.ClearAllMatesCurseFloors(t,e,o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for a=1,#e do
local e=e[a]
if e.HeroBattleInfo then
local t=t.buffId
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
local t=t[4]
for a=1,#t do
local t=t[a]
if t.treasureHeroId==o then
t.floors=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
break
end
end
end
end
end
end
return i

