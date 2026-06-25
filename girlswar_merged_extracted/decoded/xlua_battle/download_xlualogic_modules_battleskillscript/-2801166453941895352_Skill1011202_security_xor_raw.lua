local e={
}
local n=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local n=e[1]
local i=e[3]
local s=e[4]
local a={e[5],e[6]}
t:AddBuff(t,i,s,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
local i=false
for t,e in ipairs(a)do
if(e.profession==ProfessionType.Mage)then
i=true
break
end
end
if(i)then
local o=e[7]
local a=e[8]
local e={e[9]}
t:AddBuff(t,o,a,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for a,e in ipairs(a)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,n)
end
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
