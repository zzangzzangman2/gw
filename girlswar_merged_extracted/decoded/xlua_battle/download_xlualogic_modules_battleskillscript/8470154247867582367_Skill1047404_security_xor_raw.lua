local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9]}
t:AddBuff(t,i,o,a)
t:AddImmunneBuffId(e[10])
t:AddImmunneBuffId(e[11])
local o=e[12]
local a=e[13]
t:AddBuff(t,o,a,0)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
for o=1,#a do
local a=a[o]
local o=e[14]
local e=e[15]
a:AddBuff(t,o,e,0)
end
return nil
end
return i 
