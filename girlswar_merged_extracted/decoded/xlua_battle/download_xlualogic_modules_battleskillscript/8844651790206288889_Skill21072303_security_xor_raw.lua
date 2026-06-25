local e={
}
local m=e
function e.DoAction(t,h,i,e)
local e=t:JudgeSkillPreView(h)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local a=nil
if i then
a=i.triggerSkillAtkType
end
if a==nil then
t:ReduceFury(h.costMp)
end
local c=e[1]
local i=e[3]
local s=e[4]
local n={e[5],e[6]}
t:AddBuff(t,i,s,n)
local s=e[7]
local i=e[8]
local n={e[9],e[10]}
t:AddBuff(t,s,i,n)
local n=e[11]
local i=e[12]
local s={e[13],e[14]}
t:AddBuff(t,n,i,s)
local f=e[15]
local m=e[16]
local u=e[17]
local s=e[18]
local d=e[19]
local n=e[20]
local r={e[21],e[22]}
local i=302107205
local l=t.HeroBattleInfo:GetBuff(i)
if(l)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.AddEnergyByPercent(l,e[23])
end
local l=302107208
local i=t.HeroBattleInfo:GetBuff(l)
if(i)then
local e=i:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(l)
t.DoActionForBigSkill(i,e)
d=e[15]
n=e[16]
r={e[17],e[18]}
end
local i=302107211
local e=t.HeroBattleInfo:GetBuff(i)
if(e)then
local a=e:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.DoActionForSkill(e,a)
end
local e=302107214
local e=t.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetBuffData()
s=s+e[7]
n=e[8]
end
local e=#o
for e=1,e do
local e=o[e]
e:CheckAddBuff(f,t,m,u)
e:CheckAddBuff(s,t,d,n,r)
local o=nil
if a~=nil then
o=false
e:SetDisableDefRage(true)
end
local o={
triggerSkillAtkType=a,
openAddFury=o,
}
t.IgnoreBlock=true
t.IgnoreInjureRes=true
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,h,c,0,0,o)
t.IgnoreBlock=false
t.IgnoreInjureRes=false
if a~=nil then
e:SetDisableDefRage(false)
end
end
return nil
end
return m 
