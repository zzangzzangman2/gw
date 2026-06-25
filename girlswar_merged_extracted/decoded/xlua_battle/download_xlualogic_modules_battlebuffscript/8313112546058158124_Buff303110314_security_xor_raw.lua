local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(t,e)
local e=t:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#a do
local a=a[o]
local o=e[1]
local i=e[2]
local n={e[3],e[4]}
a:AddBuff(t.CurrHeroCtrl,o,i,n)
local o=e[5]
local i=e[6]
local e={e[7],e[8]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
end
return s

