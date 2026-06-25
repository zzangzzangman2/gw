local e=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local o=e[5]
local a=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
e[20]=e[20]+1
if e[20]>=e[9]then
e[20]=0
local a=303111503
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffGhostsPower(t,e[10])
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.OnRemoveGreatRivers(t)
local e=t:GetBuffData()
if e[22]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[22]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[21]=0
end
if e[21]<e[11]then
e[21]=e[21]+1
local a=303111503
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddAttackTask(e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
return i

