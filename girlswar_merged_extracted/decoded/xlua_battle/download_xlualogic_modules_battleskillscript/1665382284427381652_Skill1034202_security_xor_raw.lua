local e={}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local n=e[1]
local s=n*e[3]*MillionCoe
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,a)
local d=e[4]
local r=e[5]
local h=e[6]
a:CheckAddBuff(d,t,r,h,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n)
if(i~=nil)then
for i,a in ipairs(i)do
local i=e[7]
local n=e[8]
local e=e[9]
a:CheckAddBuff(i,t,n,e,0)
a:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
a:SetDisableDefRage(false)
end
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

