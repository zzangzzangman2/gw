local e={
}
local r=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for o=3,26 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local o=e[8]
local i=e[9]
local a={e[10],e[11]}
t:AddBuff(t,o,i,a)
if t:IsRealLastRowHero()then
local h=e[27]
local r=e[28]
local s={e[29],e[30]}
local o=e[31]
local a=e[32]
local i={e[33],e[34]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for n=1,#e do
local e=e[n]
e:AddBuff(t,h,r,s)
e:AddBuff(t,o,a,i)
end
end
local i=e[35]
local o=e[36]
local a={}
for o=37,46 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return r 
