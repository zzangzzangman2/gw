local s=require("Modules/Battle/BattleUtil")
local e={}
local h=e
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
function e.DoActionSmallSkill(t,e,i)
local e=t:GetBuffData()
local a=e[1]
local o=e[2]
local n={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,n)
local n=e[5]
local o=e[6]
local a={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,o,a)
if s:CheckCanTriggerAttackTask(i)then
if e[9]>RandomMgr:GetBattleRandom()then
local a=303110906
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffBloodPower(t,e[10])
end
end
end
end
return h

