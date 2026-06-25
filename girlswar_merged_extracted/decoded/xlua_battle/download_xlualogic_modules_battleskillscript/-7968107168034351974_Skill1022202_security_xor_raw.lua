local e={
}
local s=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
if(a.profession==ProfessionType.Tank)then
o=o+e[3]
end
local n=t.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(n==1)then
o=o+e[7]
end
local n=e[5]
local s=e[6]
a:CheckAddBuff(e[4],t,n,s,0)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
