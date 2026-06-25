local e={
}
local i=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local h=t[3]
local n=t[4]
local s=t[5]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
if(h>=RandomMgr:GetBattleRandom())then
a:AddBuff(e,n,s,0)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fRandom,t[6])
if(a)then
local e=t[7]
for a,t in ipairs(a)do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t:AddFuryWithSkill(e)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
