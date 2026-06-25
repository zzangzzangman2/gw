local h=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
t:RemoveOneBeans()
local c=e[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=303111610
local n=t.HeroBattleInfo:GetBuff(o)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionBigSkill(n,a)
end
local n=303111606
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.AddBuffEnergyStorage(o,e[3])
end
local s=e[4]
local r=e[5]
local d={e[6],e[7]}
t:AddBuff(t,s,r,d)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.AddAttackTaskVetoGun(o,e[8],i.atkType)
end
local w=e[11]
local l=e[12]
local o={e[13],e[14],e[15],e[16],e[17]}
table.insert(o,0)
table.insert(o,0)
local f=e[18]
local u=e[19]
local m={}
local d=e[20]
local r=e[21]
local s={}
local n=table.lightCopyList(a)
local n=RandomTableWithSeed(n,e[10])
for e=1,#n do
local e=n[e]
e:AddBuff(t,w,l,o)
e:AddBuff(t,f,u,m)
e:AddBuff(t,d,r,s)
end
local o=#a
for o=1,o do
local a=a[o]
local o=0
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,c,0,o)
local o=o[3]
local o=o.reduceHpValue
local e=e[9]
local e=math.floor(o*e*MillionCoe)
h:AddSepsisHp(t,a,e)
end
return nil
end
return c

