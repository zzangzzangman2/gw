local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(t,e)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
local e=e[1]
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e.CurrHeroCtrl.HeroBattleInfo.SepsisHp>0 then
if o==nil then
local o=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
else
if o then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.sepsissChange)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

