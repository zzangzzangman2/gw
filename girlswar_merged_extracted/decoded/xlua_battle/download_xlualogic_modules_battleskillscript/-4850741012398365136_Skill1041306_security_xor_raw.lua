local e={}
local h=e
function e.DoAction(e,s,a)
if a==nil or a.floors==nil then
GameInit.LogError("执行脚本 Skill1041306 skillData or skillData.usedCount is nil")
return
end
local o=e:JudgeSkillPreView(s)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local n=o[1]
local a=a.floors
local i=o[3]*a
local a=n+i
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=o[4]
e.HeroBattleInfo:DispelGranBuff(false,o)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local t=t[o]
t:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,a)
t:SetDisableDefRage(false)
end
end
return nil
end
return h

