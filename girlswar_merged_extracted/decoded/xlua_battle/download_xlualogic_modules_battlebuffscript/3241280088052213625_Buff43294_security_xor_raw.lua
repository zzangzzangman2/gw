local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
a.FixAllChainAssumedamagePercent(e)
end
function t.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=a.IsHaveCapture(e)
if o==false then
return
end
local o=e.CurrHeroCtrl
o.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
o.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
a.FixAllChainAssumedamagePercent(e,t[5])
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.FixAllChainAssumedamagePercent(e,a)
local t=43292
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.FixChainAssumedamagePercent(e,a)
end
end
function t.IsHaveCapture(e)
local t=e:GetBuffData()
local t=e.CurrHeroCtrl
local o=43293
local e=false
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
for i=1,#a do
local a=a[i]
local a=a.HeroBattleInfo:GetBuff(o)
if a and a.releaseHeroId==t.HeroId then
e=true
end
end
return e
end
return a

