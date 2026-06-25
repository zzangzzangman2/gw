local e=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=true
local i=302107605
local i=t.HeroBattleInfo:GetBuff(i)
if i then
local t=i:GetFloors()
if t>e[13]and t<e[14]then
a=false
end
end
if a==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local n=302107616
local i=t.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill1(i,{a})
e.DoActionBigSkill2(i,a)
end
t:ReduceFury(o.costMp)
local h=e[1]
local s=e[3]
local i=e[4]
local n=e[5]
local r={e[6],e[7]}
a:CheckAddBuff(s,t,i,n,r)
local n=e[8]
local i=e[9]
local s=e[10]
a:CheckAddBuff(n,t,i,s)
local n=0
local i=a.HeroBattleInfo:GetBuff(i)
if i then
n=a.HeroId
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h)
local a=a[3]
local a=a.reduceHpValue
local o=302107610
local t=t.HeroBattleInfo:GetBuff(o)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.SetBigSkillDamageInThisRound(t,a)
end
local t=math.floor(a*e[11]*MillionCoe)
local o=21076304
local e={reduceHpValue=a,addHpRate=e[12],realHurt=t,defHeroIds={n}}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,o,nil,nil,EBattleSkillType.SkillBig,e)
else
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local n=302107616
local i=t.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill1(i,a)
end
local s=#a
local h=e[16]
for t=15,26,2 do
if s==e[t]then
h=e[t+1]
break
end
end
local s={}
for e=1,#a do
table.insert(s,a[e])
end
local s=RandomTableWithSeed(s,e[27])
for a=1,#s do
local o=s[a]
local a=e[28]
local i=e[29]
local e={e[30],e[31]}
o:AddBuff(t,a,i,e)
end
local d=e[32]
local l=e[33]
local s=e[34]
local e=0
local r=#a
for r=1,r do
local a=a[r]
a:CheckAddBuff(d,t,l,s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionBigSkill2(i,a)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h)
local t=t[3]
local t=t.reduceHpValue
e=e+t
end
local a=302107610
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.SetBigSkillDamageInThisRound(t,e)
end
return nil
end
return nil
end
return u 
