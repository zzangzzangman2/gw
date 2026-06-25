local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=a[1]
local o=a[2]
local t=e.CurrHeroCtrl.CurrBattleTeam:GetAllHeroWithBuff(o,t)
if#t>0 then
for e=1,#t do
t[e].HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
else
local t=302107709
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local a=a[3]
t.AddNightmareEnergy(e,a)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

