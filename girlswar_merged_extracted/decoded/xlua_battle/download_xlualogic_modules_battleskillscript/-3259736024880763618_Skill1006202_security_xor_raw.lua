local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local h=t[1]
local s=t[3]
local n=t[4]
local i=t[5]
local o={t[6]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
t:AddBuff(e,n,i,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h)
t:ReduceFuryWithSkill(s,e,EBattleSrcType.SkillSmall,true)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
