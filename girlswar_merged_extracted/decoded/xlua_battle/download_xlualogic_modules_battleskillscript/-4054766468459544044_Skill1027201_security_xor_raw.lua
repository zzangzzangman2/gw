local e={}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=t[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fFront)
if#o>0 then
local i=t[3]
local a=t[4]
local t={t[5],t[6]}
for n=1,#o do
local o=o[n]
o:AddBuff(e,i,a,t)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,n)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

