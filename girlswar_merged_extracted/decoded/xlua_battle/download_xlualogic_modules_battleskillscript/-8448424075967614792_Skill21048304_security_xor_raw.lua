local u=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return
end
local a={a}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local d=e[6]
local o=e[7]
local r=e[12]
local s=e[10]
local h=302104817
local n=t.HeroBattleInfo:GetBuff(h)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoActionBigSkill(n,a)
local e=n:GetBuffData()
d=e[5]
o=e[6]
r=e[7]
s=e[8]
end
local l=e[1]
local n=e[3]
local h=e[4]
local d={e[5],d}
t:AddBuff(t,n,h,d)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local n=u:GetHeroWithProfession(n,e[8])
if#n<o then
table.insert(n,t)
end
local o=RandomTableWithSeed(n,o)
for a=1,#o do
local i=o[a]
local o=e[9]
local a=s
local e={e[11],r}
i:AddBuff(t,o,a,e)
end
local o=e[13]
local s=e[14]
local n=e[15]
local h={e[16],e[17]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(o,t,s,n,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,l)
end
return nil
end
return l 
