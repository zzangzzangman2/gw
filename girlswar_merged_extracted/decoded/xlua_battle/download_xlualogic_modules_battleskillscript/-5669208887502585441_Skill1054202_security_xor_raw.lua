local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=e[1]
if e[3]==a.profession then
o=o+e[4]
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfRow)
for n=1,#i do
local o=e[5]
local a=e[6]
local e=e[7]
i[n]:CheckAddBuff(o,t,a,e,0)
end
local i=nil
if t.appearBattleBigRound<ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
if t:IsUseSkillByRoundAndSkillType(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-1,EBattleSkillType.SkillSmall)==false then
i={
totalDamageRate=e[8]
}
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,o,0,0,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

