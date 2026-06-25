local n=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,s,s,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
o.ResetData(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if a then
if n:IsNormalSkillAtkType(i.triggerSkillAtkType)then
if t[8]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
t[8]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if(t[7]>=RandomMgr:GetBattleRandom())then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.SmallSkillId
if e>0 then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
n:AddTriggerAttackTask(t,e,o,i)
end
end
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ResetData(e,t,o)
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43280)
if a and o~=true then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[3])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[6])
else
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[5])
end
end
return o 
