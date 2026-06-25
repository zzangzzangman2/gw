local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=e[1]
local s=e[3]
local h=e[4]
local n=e[5]
local n=a:CheckAddBuff(s,t,h,n,0)
if(a.profession==ProfessionType.Warrior)then
o=o+e[6]
end
if n then
local a=e[7]
local o=e[8]
local e={e[9]}
local e=t:AddBuff(t,a,o,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
