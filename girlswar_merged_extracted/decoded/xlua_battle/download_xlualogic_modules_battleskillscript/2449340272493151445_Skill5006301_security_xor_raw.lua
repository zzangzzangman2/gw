local e={
}
local c=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local d=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local m=e[3]
local f=e[4]
local u={e[5]}
local c=e[6]
local l=e[7]
local n=e[8]
local i={e[9]}
local s=e[10]
local r=e[11]
local h={e[12]}
for a,e in ipairs(a)do
e:AddBuff(t,m,f,u,c)
e:AddBuff(t,l,n,i)
e:AddBuff(t,s,r,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,d)
end
end
return nil
end
return c 
