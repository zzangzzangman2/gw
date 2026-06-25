local h=require("Modules/Battle/Formula")
local e={}
local c=e
function e.DoAction(t,s,o,e)
local e=t:JudgeSkillPreView(s)
local a=nil
if o and o.defHeroIds then
local e=o.defHeroIds[1]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
end
end
if a==nil or#a<=0 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
end
if(a==nil)then
return nil
end
local n=nil
local i=nil
if o then
i=o.triggerSkillAtkType
n=o.fireData
end
if i~=ETriggerSkillAtkType.FightBack then
t:ReduceFury(s.costMp)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local c=e[1]
local o=e[3]
local d=e[4]
local r={e[5],e[6]}
t:AddBuff(t,o,d,r)
local r=e[7]
local d=e[8]
local o={e[9],e[10]}
t:AddBuff(t,r,d,o)
local o=e[11]
local d=e[12]
local r={e[13],e[14]}
t:AddBuff(t,o,d,r)
local d=e[15]
local f=e[16]
local m=e[17]
local l={}
for t=18,23 do
table.insert(l,e[t])
end
if e[25]>0 then
local i=302107709
local a=t.HeroBattleInfo:GetBuff(i)
if a then
local o=a:GetBuffData()
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
if i.CheckNightmareEnergyMaxFloor(a,o)then
local o=i.RemoveNigthmareEnergyBuff(a,o)
local a=e[24]
local e=e[25]
t:AddBuff(t,a,e,o)
end
end
end
local o=e[29]
local r=302107718
local r=t.HeroBattleInfo:GetBuff(r)
if r then
local e=r:GetBuffData()
d=e[4]
o=e[5]
end
local u=e[27]
local r=e[28]
local o={o}
for a=16,23 do
table.insert(o,e[a])
end
t:AddBuff(t,u,r,o)
local o=#a
for o=1,o do
local a=a[o]
if a.battleStationRow==2 then
a:CheckAddBuff(d,t,f,m,l)
end
t:ResetAttrValuesInCurAttack()
if n and n[2]~=0 then
local e={
attrId=n[1],
value=n[2],
}
t:AddAttrValueInCurAttack(e)
end
if e[26]>0 then
local o=h:CalculateHeroAttackCriticalRate(t)
local o=o.attackCriticalRate
local a=h:CalculateHeroAttackCriticalResRate(a)
local a=a.defFinalCriticalResRate
if(o>a)then
local e=math.floor((o-a)*e[26])
local e={
attrId=HeroAttrId.criticalStrengthRateAdd,
value=e,
}
t:AddAttrValueInCurAttack(e)
end
end
local e
if i==ETriggerSkillAtkType.FightBack then
e={
openAddFury=false,
triggerSkillAtkType=i,
}
a:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,c,0,0,e)
if i==ETriggerSkillAtkType.FightBack then
a:SetDisableDefRage(false)
end
end
return nil
end
return c

