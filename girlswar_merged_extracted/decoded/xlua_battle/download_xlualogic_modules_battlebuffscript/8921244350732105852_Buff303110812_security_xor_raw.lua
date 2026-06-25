local o=require("Modules/Battle/BattleUtil")
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
function e.AddAttackTask(t)
local e=t:GetBuffData()
if e[3]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[2]=0
end
if e[2]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[2]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t.CurrHeroCtrl:AddMustSmallSkill(t.buffId)
t.CurrHeroCtrl:SetCurrRoundCanTriggerSmallSkill()
local e=e[1]
if e>=RandomMgr:GetBattleRandom()then
local a=t.CurrHeroCtrl.HeroId
local e=t.CurrHeroCtrl.SmallSkillId
local t=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable()
if e>0 then
local t={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if i==nil then
o:AddTriggerAttackTask(a,e,t,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
end
end
return n

