local u=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(t,h,i,e)
local e=t:JudgeSkillPreView(h)
local a=303107219
local a=t.HeroBattleInfo:GetBuff(a)
if(a)then
e=a:GetBuffData()
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=nil
if i then
o=i.triggerSkillAtkType
end
if o==nil then
t:ReduceFury(h.costMp)
end
t:RemoveOneBeans()
local c=e[1]
local s=e[3]
local i=e[4]
local n={e[5],e[6]}
t:AddBuff(t,s,i,n)
local i=e[7]
local n=e[8]
local s={e[9],e[10]}
t:AddBuff(t,i,n,s)
local i=e[11]
local s=e[12]
local n={e[13],e[14]}
t:AddBuff(t,i,s,n)
local w=e[15]
local f=e[16]
local m=e[17]
local s=e[18]
local d=e[19]
local i=e[20]
local l={e[21],e[22]}
local n=303107205
local r=t.HeroBattleInfo:GetBuff(n)
if(r)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.AddEnergyByPercent(r,e[23])
end
local r=303107208
local n=t.HeroBattleInfo:GetBuff(r)
if(n)then
local e=n:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(r)
t.DoActionForBigSkill(n,e)
d=e[15]
i=e[16]
l={e[17],e[18]}
end
local r=303107211
local n=t.HeroBattleInfo:GetBuff(r)
if(n)then
local e=n:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(r)
t.DoActionForSkill(n,e)
end
local n=303107214
local n=t.HeroBattleInfo:GetBuff(n)
if n then
local e=n:GetBuffData()
s=s+e[7]
i=e[8]
end
local n=#a
for n=1,n do
local a=a[n]
a:CheckAddBuff(w,t,f,m)
a:CheckAddBuff(s,t,d,i,l)
local i=nil
if o~=nil then
i=false
a:SetDisableDefRage(true)
end
local i={
triggerSkillAtkType=o,
openAddFury=i,
}
t.IgnoreBlock=true
t.IgnoreInjureRes=true
local i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,h,c,0,0,i)
t.IgnoreBlock=false
t.IgnoreInjureRes=false
if o~=nil then
a:SetDisableDefRage(false)
end
local o=i[3]
local o=o.reduceHpValue
local i=e[24]
local o=math.floor(o*i*MillionCoe)
u:AddSepsisHp(t,a,o)
local n=e[25]
local o=e[26]
local i=t:GetFinalAtk()
local i=i*e[30]*MillionCoe
local e={e[27],e[28],e[29],i}
a:AddBuffAfterRemove(t,n,o,e)
a.isTriggerSkillEndBuff=true
end
return nil
end
return m 
