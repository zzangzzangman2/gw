local e={}
local i=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local i=e[1]
local o=e[3]
local r=e[4]
local s=e[5]
local h={e[6]}
local n=o>=RandomMgr:GetBattleRandom()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(e~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=#e
for o=1,o do
local e=e[o]
if(n)then
e:AddBuff(t,r,s,h)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
end
end
return nil
end
return i

