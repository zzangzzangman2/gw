local e=require("Modules/Battle/BattleUtil")
local e={
}
local f=e
function e.DoAction(t,i,n,e)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local a=nil
if n then
a=n.triggerSkillAtkType
end
if a==nil then
t:ReduceFury(i.costMp)
end
local f=e[1]
local s=e[3]
local n=e[4]
local h={e[5],e[6]}
t:AddBuff(t,s,n,h)
local n=e[7]
local h=e[8]
local s={e[9],e[10]}
t:AddBuff(t,n,h,s)
local s=e[11]
local n=e[12]
local h={e[13],e[14]}
t:AddBuff(t,s,n,h)
local c=e[15]
local m=e[16]
local u=e[17]
local r=e[18]
local h=e[19]
local n=e[20]
local l={e[21],e[22]}
local d=303107205
local s=t.HeroBattleInfo:GetBuff(d)
if(s)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.AddEnergyByPercent(s,e[23])
end
local d=303107208
local s=t.HeroBattleInfo:GetBuff(d)
if(s)then
local e=s:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(d)
t.DoActionForBigSkill(s,e)
h=e[15]
n=e[16]
l={e[17],e[18]}
end
local s=303107211
local e=t.HeroBattleInfo:GetBuff(s)
if(e)then
local a=e:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.DoActionForSkill(e,a)
end
local e=303107214
local e=t.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetBuffData()
r=e[7]
n=e[8]
end
local e=#o
for e=1,e do
local e=o[e]
e:CheckAddBuff(c,t,m,u)
e:CheckAddBuff(r,t,h,n,l)
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
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,f,0,0,o)
t.IgnoreBlock=false
t.IgnoreInjureRes=false
if a~=nil then
e:SetDisableDefRage(false)
end
end
return nil
end
return f 
