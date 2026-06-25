local e={
}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local h=t[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBack)
if(o~=nil)then
local s=t[3]
local n=t[4]
local i={t[5]}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for o,t in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h)
t:AddBuff(e,s,n,i)
end
end
return nil
end
return i 
