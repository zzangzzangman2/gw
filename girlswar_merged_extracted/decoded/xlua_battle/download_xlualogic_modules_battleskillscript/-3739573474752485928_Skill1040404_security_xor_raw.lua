local e={}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local r=e[1]
local s=e[2]
local h={e[3],e[4],e[5]}
local n=e[6]
local o=e[7]
local i={e[8],e[9]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,r,s,h)
e:AddBuff(t,n,o,i)
end
return nil
end
return o

