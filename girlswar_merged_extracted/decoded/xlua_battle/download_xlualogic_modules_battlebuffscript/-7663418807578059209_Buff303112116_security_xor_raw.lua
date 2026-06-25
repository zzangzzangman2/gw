local h=require("Modules/Battle/Formula")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,o,n,n,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.AllEnemyAddBuffSepsiss(e)
end
elseif t.buffTriggerTime==BuffTriggerTime.addEnemy then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.AddBuffSepsiss(e,o)
end
elseif t.buffTriggerTime==BuffTriggerTime.HeroDead then
local a=i[1]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
for t=1,#e do
local e=e[t]
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
elseif t.buffTriggerTime==BuffTriggerTime.removeMyMate then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.AllEnemyAddBuffSepsiss(e)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AllEnemyAddBuffSepsiss(t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
for o=1,#e do
local e=e[o]
a.AddBuffSepsiss(t,e)
end
end
function t.AddBuffSepsiss(a,o)
local e=a:GetBuffData()
local i=e[1]
local n=e[2]
local t={}
for a=3,6 do
table.insert(t,e[a])
end
o:AddBuff(a.CurrHeroCtrl,i,n,t)
end
function t.DoActionBigSkill(a,t)
local s=a:GetBuffData()
local i=303112104
local o=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local e={}
local n=303112105
for o=1,#t do
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t[o],BattleHeroType.fHollow)
for o=1,#t do
if h:CalculateCtrlSuccess(n,s[7],a.CurrHeroCtrl,t[o])then
local t=t[o].HeroId
if e[t]==nil then
e[t]=1
else
e[t]=1+e[t]
end
end
end
end
local a=ModulesInit.BattleBuffMgr.GetBuffScript(i)
for i=1,#t do
local t=t[i]
local i=t.HeroId
local e=e[i]
if e then
a.AddBuffLightlessPear(o,t,e)
end
end
end
return enemyBuffFloorsMap
end
return a

