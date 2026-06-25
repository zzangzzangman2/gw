local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local a=e.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,t[8])
end
local s=t[1]
local a=t[3]
local n=t[5]
local i=t[6]
local h={t[7]}
e:AddFuryWithSkill(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(a~=nil)then
for o,a in ipairs(a)do
if(a.HeroId~=e.HeroId)then
a:AddFuryWithSkill(t[4])
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for a,t in ipairs(t)do
t:AddBuff(e,n,i,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,s)
end
end
return nil
end
return n 
