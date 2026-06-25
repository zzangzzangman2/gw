local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,t,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(a==BuffRemoveType.Dispel)then
local i=t[5]
local a=t[6]
if e.CurrHeroCtrl:IsOnAttack()then
a=a+1
end
local o={}
local i=e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,o)
local a=e.releaseHeroId
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a then
local o=302107511
local e=a.HeroBattleInfo:GetBuff(o)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if i then
a.FrozenEnemy(e)
end
a.GainSnowBall(e,t[8])
end
end
if e.CurrHeroCtrl and t[7]and t[7]>0 then
e.CurrHeroCtrl:ReduceFuryWithBuffImmediately(t[7])
end
end
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

