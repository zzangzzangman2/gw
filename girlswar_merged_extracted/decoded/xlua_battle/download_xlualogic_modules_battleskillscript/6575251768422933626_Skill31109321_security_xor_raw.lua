local r=require("Modules/Battle/BattleUtil")
local e={}
local f=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(i.costMp)
t:RemoveOneBeans()
local f=e[1]
local s=e[3]
local n=e[4]
local a={e[5],e[6]}
t:AddBuff(t,s,n,a)
local a=e[7]
local n=e[8]
local s={e[9],e[10]}
t:AddBuff(t,a,n,s)
local a=nil
local n=303110915
local n=t.HeroBattleInfo:GetBuff(n)
if n then
a=n:GetBuffData()
end
local h=e[14]
local s=e[16]
local m=e[18]
local n=e[20]
local c=e[22]
local u=e[23]
local l=true
if a then
h=a[1]
s=a[4]
m=a[2]
n=a[4]
c=a[3]
u=a[5]
if a[6]>RandomMgr:GetBattleRandom()then
l=false
end
end
local n=1
local d=303110901
local s=t.HeroBattleInfo:GetBuff(d)
if s then
local o=s:GetFloors()
local a=e[11]
if l==false or o>=a then
if l==true then
r:ReduceHeroBuffFloor(t,d,a)
end
n=n+e[12]
t:AddFuryWithSkill(e[13])
end
end
local l=table.lightCopyList(o)
local l=RandomTableWithSeed(l,h)
for a=1,#l do
local a=l[a]
local o=e[15]
local s=e[16]
local i={e[17],m}
a:AddBuffWithMaxFloor(t,o,s,i,n,u)
local o=e[19]
local i=e[20]
local e={e[21],c}
a:AddBuffWithMaxFloor(t,o,i,e,n,u)
end
local n=#o
for n=1,n do
local o=o[n]
local n=0
if a then
h=a[1]
local e=303110907
local e=o.HeroBattleInfo:GetBuff(e)
if e then
if s then
local e=s:GetFloors()
if a[7]*e>RandomMgr:GetBattleRandom()then
t.IgnoreBlock=true
t.IgnoreInjureRes=true
end
end
if o:CurrHPPer()<a[8]*MillionCoe then
o.HeroBattleInfo:DispelGranBuff(true,a[9])
local e=t:GetFinalAtk()
n=e*a[10]*MillionCoe
end
end
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,f,0,n)
t.IgnoreBlock=false
t.IgnoreInjureRes=false
local a=a[3]
local a=a.reduceHpValue
local e=e[24]
if e>0 then
local e=math.floor(a*e*MillionCoe)
r:AddSepsisHp(t,o,e)
end
end
local a=0
local o=t.HeroBattleInfo:GetBuff(d)
if o then
a=o:GetFloors()
end
if a<e[25]then
local o=303110906
local a=t.HeroBattleInfo:GetBuff(o)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.AddBuffBloodPower(a,e[26])
end
local e=t.HeroId
local t=t.SmallSkillId
local a={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,e)
if o==nil then
r:AddTriggerAttackTask(e,t,a,{triggerSkillAtkType=i.atkType,triggerSkillType=AttackType.BigSkill})
end
end
return nil
end
return f

