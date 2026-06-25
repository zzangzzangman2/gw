local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local s=t[3]
local n=t[4]
local a={t[5]}
e:AddBuff(e,s,n,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfRow)
if(a)then
local i=t[6]
local o=t[7]
local t={t[8]}
for n,a in ipairs(a)do
a:AddBuff(e,i,o,t)
end
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
