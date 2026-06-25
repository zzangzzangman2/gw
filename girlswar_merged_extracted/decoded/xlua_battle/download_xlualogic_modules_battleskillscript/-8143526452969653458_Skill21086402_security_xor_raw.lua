local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
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
local n=e[27]
local o=e[28]
local a={e[29],e[30]}
local s=e[31]
local i=e[32]
local h={e[33],e[34]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for r=1,#e do
local e=e[r]
e:AddBuff(t,n,o,a)
e:AddBuff(t,s,i,h)
end
end
return nil
end
return d 
