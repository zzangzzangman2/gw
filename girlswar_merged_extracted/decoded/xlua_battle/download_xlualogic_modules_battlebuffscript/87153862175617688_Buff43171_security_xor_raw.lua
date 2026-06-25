local o=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroTable()
local a=o:FindMostBigAtk(a)
if a then
if(e[1]>=RandomMgr:GetBattleRandom())then
local n=e[2]
local i=e[3]
local o={}
for t=4,11 do
table.insert(o,e[t])
end
a:AddBuff(t.CurrHeroCtrl,n,i,o)
end
if(e[1]>=RandomMgr:GetBattleRandom())then
local n=e[12]
local i=e[13]
local o={}
for t=14,15 do
table.insert(o,e[t])
end
a:AddBuff(t.CurrHeroCtrl,n,i,o)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

