local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local h=e[1]
local s=e[2]
local n={e[3]}
local i=e[4]
local a=e[5]
local o={e[6]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
if(e~=nil)then
for a,e in ipairs(e)do
e:AddBuff(t,h,s,n)
end
end
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
if(e~=nil)then
for n,e in ipairs(e)do
e:AddBuff(t,i,a,o)
end
end
return nil
end
return h 
