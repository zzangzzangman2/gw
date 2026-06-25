local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local r=e[1]
local s=e[2]
local h={e[3]}
local n=e[4]
local o=e[5]
local i={e[6]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a)then
for a,e in ipairs(a)do
e:AddBuff(t,r,s,h)
e:AddBuff(t,n,o,i)
end
end
local a=e[7]
local o=e[8]
local e={e[9]}
t:AddBuff(t,a,o,e)
return nil
end
return h 
