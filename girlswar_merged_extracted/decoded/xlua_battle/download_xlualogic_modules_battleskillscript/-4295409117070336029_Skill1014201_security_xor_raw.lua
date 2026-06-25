local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
if(t[3]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBack)
if(a~=nil)then
local i=t[4]
local o=t[5]
local t={t[6]}
for n,a in ipairs(a)do
a:AddBuff(e,i,o,t)
end
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
