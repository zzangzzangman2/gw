local n={}
local i={
302104921,
43133,
302108002,
302108621,
302108622,
302108908,
302110411,
303102523,
303111202,
308201104,
303101235,
}
function n.DoAllLimitAction(e,s,t)
local o=false
local a=false
for n=1,#i do
local i=i[n]
if e.HeroBattleInfo==nil then
break
end
local e=e.HeroBattleInfo:GetBuff(i)
if e and e.isExec==false then
local n=e:GetBuffData()
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
if i.DoLimitAction then
local t,e=i.DoLimitAction(e,n,s,t)
o=true
if a~=true then
a=e
end
end
end
end
if a and e:IsOnAttack()then
if t.triggerSkillAtkType==nil or t.triggerSkillAtkType==ETriggerSkillAtkType.Normal then
if t.actionType==EBattleActionType.NormalOrSmallSkill then
e.CurrRoundIsNormalSkillAttack=true
elseif t.actionType==EBattleActionType.BigSkill then
e.CurrRoundIsBigSkillAttack=true
end
end
end
if o then
if e.HeroBattleInfo then
e:CheckBattleRoundBigAndSmallSkillStatus()
end
end
return o,a
end
return n

