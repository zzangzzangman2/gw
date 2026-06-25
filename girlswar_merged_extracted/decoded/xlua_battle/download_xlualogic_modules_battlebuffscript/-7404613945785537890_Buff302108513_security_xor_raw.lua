local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=302108507
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.GainTaskHalo(a,t[1])
local o=t[2]
local a=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.critical)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(e)
local a=e:GetBuffData()
local t=302108507
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.GainTaskHalo(e,a[6])
end
end
return i

