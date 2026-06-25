local e={
}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
local o=e[1]
local s=e[3]
local n=e[4]
local h=e[5]
a:CheckAddBuff(s,t,n,h)
if a:CurrHPPer()<e[6]*MillionCoe then
o=o+e[7]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t:FuryHealth(FuryHealthType.Attack)
end
return h 
