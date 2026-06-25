local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,n,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.after then
a.TryAddCaptiveMark(e,t[1])
elseif o.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local i=e.CurrHeroCtrl
local o=43293
local o=n.HeroBattleInfo:GetBuff(o)
if o==nil or o.releaseHeroId~=i.HeroId then
return
end
i:AddFuryWithBuff(t[2])
a.TryAddCaptiveMark(e,t[3])
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.after
or e==BuffTriggerTime.enemyTeamHeroDead then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.TryAddCaptiveMark(t,a)
local e=43292
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddCaptiveMark(t,a)
end
end
return a

