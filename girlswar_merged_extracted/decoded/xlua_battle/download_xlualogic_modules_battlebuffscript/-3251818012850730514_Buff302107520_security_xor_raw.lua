local e={}
local h=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionBigSkill(e,s)
local t=e:GetBuffData()
local a=302107511
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local n=t[1]
local i=t[2]
local t=t[3]
local e=s:CheckAddBuff(n,e.CurrHeroCtrl,i,t)
if e then
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.FrozenEnemy(o)
end
end
end
return h

