local t={}
local e={
30104906,
30104909,
302104906,
302104909,
303111110,
43257,
92472,
}
function t.CheckRemoveBuff(t)
if t==nil or t.HeroBattleInfo==nil then
return
end
for a=1,#e do
local o=e[a]
local a=t.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if e and e.GetImmuneDamageCount then
local i=a:GetBuffData()
local e=e.GetImmuneDamageCount(a,i)
if e<=0 then
t.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
end
end
function t.CheckImmuneDamage(t)
if t==nil or t.HeroBattleInfo==nil then
return false
end
for a=1,#e do
local e=e[a]
local t=t.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e and e.GetImmuneDamageCount then
local a=t:GetBuffData()
local e=e.GetImmuneDamageCount(t,a)
if e>0 then
return true
end
end
end
end
return false
end
function t.CheckConsumeImmuneDamageCount(a)
if a==nil or a.HeroBattleInfo==nil then
return false
end
for o=1,#e do
local o=e[o]
local e=a.HeroBattleInfo:GetBuff(o)
if e then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if o and o.CheckConsumeOne then
local i=e:GetBuffData()
local e=o.CheckConsumeOne(e,i)
if e then
t.CheckRemoveBuff(a)
return true
end
end
end
end
return false
end
return t

