local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl.ForbidSmallSkill=true
end
function e.OnRemoveSelf(e,t)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
e.CurrHeroCtrl.ForbidSmallSkill=false
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=303111409
for t=1,#e do
local a=e[t].HeroBattleInfo:GetBuff(a)
if a==nil then
e[t]:SetForceAttackHeroId(0)
end
end
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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
return o

