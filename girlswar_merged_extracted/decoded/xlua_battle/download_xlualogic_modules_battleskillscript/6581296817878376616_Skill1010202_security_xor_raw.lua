local e={
}
local n=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local n=e[1]
local s=e[3]
local a=e[4]
local i={e[5]}
t:AddBuff(t,s,a,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
if(t.HeroBattleInfo:IsExistsSkill(1010404))then
local o=e[9]
local i=e[10]
local e={e[11],e[12]}
a:AddBuff(t,o,i,e)
else
local o=e[6]
local i=e[7]
local e={e[8]}
a:AddBuff(t,o,i,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
