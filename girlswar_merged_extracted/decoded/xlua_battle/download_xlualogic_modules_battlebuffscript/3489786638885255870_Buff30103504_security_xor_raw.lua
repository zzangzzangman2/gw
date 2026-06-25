local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil then
GameInit.LogError("Buff30103504 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
if#a<1 then
GameInit.LogError("Buff30103504 buffData 数量应该 等于1 ")
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if t and#t>0 then
for o=1,#t do
local t=t[o]
local t=t.HeroBattleInfo:GetBuff(30103501)
if t~=nil then
e.CurrHeroCtrl:AddFuryWithBuff(a[1])
end
end
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.normalAttack then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

