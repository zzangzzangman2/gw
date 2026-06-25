local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[2]
for o=1,#a do
local a=a[o]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a==nil or a.HeroBattleInfo.CurrHP==0 then
t[2]={}
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[1])
break
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.allHeroAfterSufferDmg)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

