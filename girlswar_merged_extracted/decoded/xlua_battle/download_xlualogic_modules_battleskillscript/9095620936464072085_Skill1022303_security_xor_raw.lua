local e={
}
local s=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=t.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[9])
end
t:ReduceFury(i.costMp)
local o=e[1]
local h=e[4]
local s=e[6]
local n=e[7]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
o=o+(6-#a)*e[8]
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for r,a in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
if(e[3]>=RandomMgr:GetBattleRandom())then
a:ReduceFuryWithSkill(h,t,EBattleSrcType.SkillBig,true)
end
a:CheckAddBuff(e[5],t,s,n,0)
end
end
return nil
end
return s 
