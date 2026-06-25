local e=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumnMaxHpPercent)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(s.costMp)
local c=e[1]
local h=e[5]
local o=e[6]
local u=e[7]
local d={e[8],e[9],e[10]}
local l=#a
local r=false
local n=nil
local i=nil
for e=1,l do
local e=a[e]
if e.battleStationRow==1 then
n=e
else
i=e
end
local e=e.HeroBattleInfo:GetBuff(o)
if e then
r=true
break
end
end
if r==false then
if n then
n:CheckAddBuff(h,t,o,u,d)
elseif i then
i:CheckAddBuff(h,t,o,u,d)
end
end
local i=false
for e=1,l do
local e=a[e]
local e=e.HeroBattleInfo:GetBuff(o)
if e then
i=true
break
end
end
if i==false then
local o=e[11]
local a=e[12]
local e={e[13],e[14]}
t:AddBuff(t,o,a,e)
t.MustSmallSkill=true
t:SetCurrRoundCanTriggerSmallSkill()
t:RefreshMustSmallSkill()
t:CheckBattleRoundBigAndSmallSkillStatus()
end
local o=#a
for o=1,o do
local o=a[o]
local a=c
if(o.profession==e[3])then
a=a+e[4]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,s,a)
end
return nil
end
return c

