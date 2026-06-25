local e={
}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local o=e[1]
local s=e[4]
local h=e[6]
local n=e[7]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
o=o+(6-#a)*e[8]
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for r,a in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
if(e[3]>=RandomMgr:GetBattleRandom())then
a:ReduceFuryWithSkill(s,t,EBattleSrcType.SkillBig,true)
end
a:CheckAddBuff(e[5],t,h,n,0)
end
end
return nil
end
return n 
