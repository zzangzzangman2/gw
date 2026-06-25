local e={}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]
local h=t[3]
local n=t[4]
local s={t[5]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local t=t[o]
t:AddBuff(e,h,n,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
end
end
return nil
end
return n

