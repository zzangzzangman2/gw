local h=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local a=#a
if(a==e[18])then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[19])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local r=e[1]
local n=e[3]
local i=e[4]
local s={e[5],e[6]}
t:AddBuff(t,n,i,s)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local i=h:GetHeroWithProfession(i,e[8])
if#i<e[7]then
table.insert(i,t)
end
local i=RandomTableWithSeed(i,e[7])
for a=1,#i do
local i=i[a]
local a=e[9]
local o=e[10]
local e={e[11],e[12]}
i:AddBuff(t,a,o,e)
end
local s=e[13]
local n=e[14]
local h=e[15]
local i={e[16],e[17]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(s,t,n,h,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r)
end
return nil
end
return r 
