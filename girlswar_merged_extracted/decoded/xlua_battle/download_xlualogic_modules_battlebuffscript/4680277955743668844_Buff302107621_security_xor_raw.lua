local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.AddGirlFight(t)
local e=t:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=e[1]
local i=e[2]
local n={e[3],e[4]}
for e=1,#a do
local e=a[e]
e:AddBuffAfterRemove(t.CurrHeroCtrl,o,i,n)
end
local a=e[5]
local e=e[6]
local o=0
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,a,e,o)
end
return s

