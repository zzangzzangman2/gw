local i=require("Modules/Battle/BattleUtil")
local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,n,a,n,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eBack)
local a,o=i:FindMostSmallDef(a)
if a then
local o=e[1]
local i=e[2]
local e={e[3],e[4],e[5],0,0}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
a.isTriggerAllHeroLockHpForEver=true
end
elseif o.buffTriggerTime==BuffTriggerTime.attack then
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[10]==1 and a then
local o=302108309
local o=a.HeroBattleInfo:GetBuff(o)
if(o)then
local i=e[6]
local o=a.HeroBattleInfo:GetBuff(i)
if o then
local t=o:GetBuffData()
local t=t[1]
if#t<e[11]then
table.insert(t,e[8])
local e=#t
a:ModifyBuffWithFinalFloor(o,e)
end
else
local o=e[7]
local e={{e[8]},e[9]}
a:AddBuff(t.CurrHeroCtrl,i,o,e,1)
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or o.buffTriggerTime==BuffTriggerTime.enemyTeamHeroLockHp then
if a and a.HeroBattleInfo and a.HeroBattleInfo.CurrHP>0 then
local a=e[12]
local o=e[13]
local i={e[14],e[15],e[16],e[17]}
local e=e[18]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,a,o,i,1,e)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack
or e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or e==BuffTriggerTime.enemyTeamHeroLockHp)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

