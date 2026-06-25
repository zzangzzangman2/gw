local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e:GetBuffData()
for o=#t,1,-1 do
local e=t[o]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e:CheckHeroCanDoAction()then
local a=302104305
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=a.AddHpToFriend(e)
if e<=0 then
table.remove(t,o)
end
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

