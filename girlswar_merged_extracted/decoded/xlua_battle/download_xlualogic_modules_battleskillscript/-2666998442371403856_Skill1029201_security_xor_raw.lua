local e={
}
local i=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local s=t[1]
local n=t[3]
local i=t[4]
local t=t[5]
a:CheckAddBuff(n,e,i,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,s)
e:FuryHealth(FuryHealthType.Attack)
end
return i 
