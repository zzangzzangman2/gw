local e={}
local a=e
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
function e.DoActionSmallSkill(t)
local e=t:GetBuffData()
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=e[1]
local a=e[2]
local i={e[3],e[4]*#i}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local o=e[5]
local a=e[6]
local e={e[7],e[8],e[9],e[10]}
table.insert(e,0)
table.insert(e,0)
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,o,a,e)
end
return a

