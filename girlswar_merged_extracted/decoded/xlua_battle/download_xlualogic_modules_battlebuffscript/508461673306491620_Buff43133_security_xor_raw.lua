local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.DoLimitAction(t,e)
if ModulesInit.ProcedureNormalBattle.IsPVE()and e[6]==0 then
return false
end
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[1])
if a==nil then
return false
end
local a=e[3]
local o=e[4]
local i=e[5]
local n=0
if a>0 then
local a=t.CurrHeroCtrl:CheckAddBuff(a,t.CurrHeroCtrl,o,i,n)
if a then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e[1],BuffRemoveType.Expire)
t.CurrHeroCtrl.HeroBattleInfo:PlayBattleAllBuffEffect()
end
return a
else
return false
end
end
return o

