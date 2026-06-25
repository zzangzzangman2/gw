local t=require("Modules/Battle/BattleUtil")
local e={}
local n=e
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
function e.DoActionBigSkill(e)
local a=e:GetBuffData()
local e=t:GetConCtrlHeroInTeam(e.CurrHeroCtrl,a[1])
for t=1,#e do
e[t].HeroBattleInfo:DispelAllGranBuff(false)
end
end
function e.CheckConsumeToChangeBigSkill(t)
local e=t:GetBuffData()
local o=302107423
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local i=o.CheckConsumeEye(a,e[2])
if i then
local a=o.GetEyeFloors(a)
local a=math.floor(a/e[5])
if a>0 then
local o=e[6]
local i=e[7]
local e={e[8],e[9],e[10],e[11]}
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,o,i,e,a)
end
return true
end
end
return false
end
function e.GainEyeBuff(t,a)
local o=t:GetBuffData()
local e=302107423
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
local a=math.min(a,o[12])
e.AddEyeBuff(t,a)
end
end
return n

