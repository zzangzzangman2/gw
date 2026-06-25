local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(t[1]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroTable()
local a=RandomTableWithSeed(a,t[2])
for o=1,#a do
local i=t[3]
local t=t[4]
local n=0
a[o]:AddBuff(e.CurrHeroCtrl,i,t,n)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play or e==BuffTriggerTime.skill2Play or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return s

