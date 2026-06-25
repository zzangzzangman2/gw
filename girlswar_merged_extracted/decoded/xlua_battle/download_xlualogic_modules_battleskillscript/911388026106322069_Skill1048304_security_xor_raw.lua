local n=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i,o)
local e=t:JudgeSkillPreView(i)
local a
if o~=nil then
a=o[1]
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return
end
t:ReduceFury(i.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=e[1]
local r=e[3]
local s=e[4]
local o={e[5],e[6]}
t:AddBuff(t,r,s,o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local o=n:GetHeroWithProfession(o,e[8])
if#o<e[7]then
table.insert(o,t)
end
local o=RandomTableWithSeed(o,e[7])
for a=1,#o do
local o=o[a]
local a=e[9]
local i=e[10]
local e={e[11],e[12]}
o:AddBuff(t,a,i,e)
end
local o=e[13]
local n=e[14]
local s=e[15]
local e={e[16],e[17]}
a:CheckAddBuff(o,t,n,s,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,h)
return nil
end
return h 
