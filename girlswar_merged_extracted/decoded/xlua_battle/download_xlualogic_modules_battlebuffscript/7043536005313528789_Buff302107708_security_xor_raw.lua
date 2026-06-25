local n=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,s,s,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or t.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or t.buffTriggerTime==BuffTriggerTime.allSkillAttack then
local e=a.triggerSkillAtkType
if n:IsDependAtkType(e)==false then
i[8]=false
end
elseif t.buffTriggerTime==BuffTriggerTime.addBuff then
if a.buffHeroId==e.CurrHeroCtrl.HeroId then
local t=a.addBuffId
if t==3126 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(3126,BuffRemoveType.Expire)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(3127,BuffRemoveType.Expire)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(3128,BuffRemoveType.Expire)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
o.AddNightmareEnergyWithFloor(e,i[3])
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddNightmareEnergyWithAttack(t)
local e=t:GetBuffData()
if e[8]==true then
return
end
local a=e[2]
if e[6]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[6]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[7]=0
end
if e[7]<a then
e[7]=e[7]+1
e[8]=true
o.AddNightmareEnergyWithFloor(t,e[1])
end
end
function t.AddNightmareEnergyWithFloor(t,a)
local e=302107709
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddNightmareEnergy(t,a)
end
end
return o

