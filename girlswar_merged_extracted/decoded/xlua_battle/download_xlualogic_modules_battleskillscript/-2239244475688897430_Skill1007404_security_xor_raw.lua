local e={}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local o={e[3]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(e~=nil)then
local a=#e
for a=1,a do
local e=e[a]
e:AddBuff(t,n,i,o)
end
end
return nil
end
return s

