local e={
}
local n=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local h=e[1]
local i=e[4]
local s=e[6]
local n=e[7]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for r,o in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,a,h)
if(e[3]>=RandomMgr:GetBattleRandom())then
o:ReduceFuryWithSkill(i,t,EBattleSrcType.SkillBig,true)
end
o:CheckAddBuff(e[5],t,s,n,0)
end
end
return nil
end
return n 
