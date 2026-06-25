local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local i=t[1]
local o=t[2]
local a={}
for e=3,8 do
table.insert(a,t[e])
end
local t=e.CurrHeroCtrl:GetLastAttackHeroId()
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
t:AddBuff(e.CurrHeroCtrl,i,o,a)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return n

