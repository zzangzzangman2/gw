local e=require("Modules/Battle/Formula")
local f=require("Modules/Battle/BattleUtil")
local r={}
local d=r
function r.DoAction(a,o)
local t=a:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMinHpPercent)
if(e==nil)then
return nil
end
a:ReduceFury(o.costMp)
local s=t[1]
local i=t[4]
local n=t[5]
local h={t[6],t[7]}
e:AddBuff(a,i,n,h)
local i=nil
local n=303107012
local h=a.HeroBattleInfo:GetBuff(n)
if(h)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.GetSkyChild(h)
end
local h=0
local c=t[9]*MillionCoe
local u=t[10]*MillionCoe
if o.atkType==ETriggerSkillAtkType.PursuitAttack or o.atkType==ETriggerSkillAtkType.AsistAttack then
if i then
local e=i:GetFinalAtk()
h=e*t[8]*MillionCoe
end
end
local i={}
local r=303107020
local n=a.HeroBattleInfo:GetBuff(r)
if n then
local t=n:GetBuffData()
local l=t[8]
local m=t[9]
s=s+l
local r=ModulesInit.BattleBuffMgr.GetBuffScript(r)
r.AddBuffTotargetHero(n,t,e)
i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
if#i>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,e)
for t=1,#i do
local t=i[t]
local i=0
if t.battleStationColumn==e.battleStationColumn and t.battleStationRow==2 then
i=s+m
else
i=l
end
local e=d.CalcRealHurt(h,t,c,u)
local n={
openAddFury=false
}
t:SetDisableDefRage(true)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,o,i,0,e,n)
t:SetDisableDefRage(false)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
local h=d.CalcRealHurt(h,e,c,u)
local i=nil
if n then
i={
openAddFury=false
}
e:SetDisableDefRage(true)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,s,0,h,i)
e:SetDisableDefRage(false)
local o=o[3]
local o=o.reduceHpValue
local t=t[3]
if t>0 then
local t=math.floor(o*t*MillionCoe)
f:AddSepsisHp(a,e,t)
end
return nil
end
function r.CalcRealHurt(e,t,a,o)
if e>0 then
local t=t.HeroBattleInfo.MaxHP
local a=t*a
local t=t*o
local e=math.max(e,a)
e=math.min(e,t)
e=math.floor(e)
return e
end
end
return d

