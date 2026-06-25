local r=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local n=e[1]
local s=e[3]
local o=e[4]
local h={e[5],e[6]}
t:AddBuff(t,s,o,h)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local o=r:GetHeroWithProfession(o,e[8])
if#o<e[7]then
table.insert(o,t)
end
local o=RandomTableWithSeed(o,e[7])
for a=1,#o do
local i=o[a]
local o=e[9]
local a=e[10]
local e={e[11],e[12]}
i:AddBuff(t,o,a,e)
end
local o=e[13]
local s=e[14]
local r=e[15]
local h={e[16],e[17]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(o,t,s,r,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,n)
end
return nil
end
return d 
