local e={}
local d=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local n=a[1]
local r=n*a[3]*MillionCoe
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,t)
local h=a[4]
local s=a[5]
local a=a[6]
t:CheckAddBuff(h,e,s,a,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,n)
if(i~=nil)then
for a,t in ipairs(i)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

