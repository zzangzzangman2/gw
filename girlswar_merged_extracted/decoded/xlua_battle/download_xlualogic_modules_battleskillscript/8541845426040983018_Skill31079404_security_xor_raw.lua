local o={
}
local n=o
function o.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=3,6 do
table.insert(a,e[t])
end
for t=25,37 do
table.insert(a,e[t])
end
local n=t.HeroBattleInfo:GetMaxHP()
local n=math.floor(n*e[30]*MillionCoe)
table.insert(a,n)
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,i,o,a)
local i=e[7]
local o=e[8]
local a={e[9],e[10]}
if t:IsRealFirstRowHero()then
a={e[9],math.floor(e[10]*e[24]*MillionCoe)}
end
t:AddBuff(t,i,o,a)
local i=e[11]
local o=e[12]
local a={e[13],e[14],e[15]}
if t:IsRealFirstRowHero()then
a={e[13],math.floor(e[14]*e[24]*MillionCoe),math.floor(e[15]*e[24]*MillionCoe)}
end
t:AddBuff(t,i,o,a)
local i=e[16]
local o=e[17]
local a={e[18],e[19]}
if t:IsRealFirstRowHero()then
a={e[18],math.floor(e[19]*e[24]*MillionCoe)}
end
t:AddBuff(t,i,o,a)
local i=e[20]
local o=e[21]
local a={e[22],e[23]}
if t:IsRealFirstRowHero()then
a={e[22],math.floor(e[23]*e[24]*MillionCoe)}
end
t:AddBuff(t,i,o,a)
local i=e[38]
local o=e[39]
local a={}
for t=40,46 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,i,o,a)
return nil
end
function o.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function o.DoAfterAction(e,t)
local o=e:JudgeSkillPreView(t)
local a=303107909
local t=e.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local i=e.HeroBattleInfo:GetMaxHP()
local o=math.floor(i*o[30]*MillionCoe)
e:ShowRageBar(true,EBattleRageBarType.Yellow)
a.SetMaxEnergy(t,o)
a.ResetEnergyMaxEnergy(t)
end
return{
duration=1000,
success=true
}
end
return n 
