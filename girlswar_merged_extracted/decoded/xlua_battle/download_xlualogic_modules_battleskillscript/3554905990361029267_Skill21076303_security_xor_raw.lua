local e=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local i=true
local a=302107605
local a=t.HeroBattleInfo:GetBuff(a)
if a then
local t=a:GetFloors()
if t>e[13]and t<e[14]then
i=false
end
end
if i==false then
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
local r=e[1]
local h=e[3]
local i=e[4]
local n=e[5]
local s={e[6],e[7]}
a:CheckAddBuff(h,t,i,n,s)
local i=e[8]
local n=e[9]
local s=e[10]
a:CheckAddBuff(i,t,n,s)
local i=0
local n=a.HeroBattleInfo:GetBuff(n)
if n then
i=a.HeroId
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r)
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
local e={reduceHpValue=a,addHpRate=e[12],realHurt=t,defHeroIds={i}}
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
local a=s[a]
local o=e[28]
local i=e[29]
local e={e[30],e[31]}
a:AddBuff(t,o,i,e)
end
local d=e[32]
local l=e[33]
local r=e[34]
local s=0
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(d,t,l,r)
if i then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.DoActionBigSkill2(i,e)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,h)
local e=e[3]
local e=e.reduceHpValue
s=s+e
end
local a=302107610
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.SetBigSkillDamageInThisRound(e,s)
end
return nil
end
return nil
end
return u

