local e=require("Modules/Battle/Formula")
local f=require("Modules/Battle/BattleUtil")
local l={}
local r=l
function l.DoAction(a,o)
local t=a:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMinHpPercent)
if(e==nil)then
return nil
end
a:ReduceFury(o.costMp)
local d=t[1]
local i=t[4]
local n=t[5]
local s={t[6],t[7]}
e:AddBuff(a,i,n,s)
local i=nil
local n=302107012
local s=a.HeroBattleInfo:GetBuff(n)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.GetSkyChild(s)
end
local n=0
local m=t[9]*MillionCoe
local c=t[10]*MillionCoe
if o.atkType==ETriggerSkillAtkType.PursuitAttack or o.atkType==ETriggerSkillAtkType.AsistAttack then
if i then
local e=i:GetFinalAtk()
n=e*t[8]*MillionCoe
end
end
local h=d
local l=d
local i={}
local u=302107020
local s=a.HeroBattleInfo:GetBuff(u)
if s then
local t=s:GetBuffData()
local f=t[8]
local w=t[9]
local u=ModulesInit.BattleBuffMgr.GetBuffScript(u)
u.AddBuffTotargetHero(s,t,e)
if e.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
table.insert(i,e[t])
break
end
end
end
if#i>0 then
h=h+w
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,e)
for e=1,#i do
local e=i[e]
local t=r.CalcRealHurt(n,e,m,c)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,h,0,t)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
l=d+f
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
local i=r.CalcRealHurt(n,e,m,c)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,l,0,i)
local o=o[3]
local o=o.reduceHpValue
local t=t[3]
if t>0 then
local t=math.floor(o*t*MillionCoe)
f:AddSepsisHp(a,e,t)
end
return nil
end
function l.CalcRealHurt(t,e,a,o)
if t>0 then
local e=e.HeroBattleInfo.MaxHP
local a=e*a
local o=e*o
local e=math.max(t,a)
e=math.min(e,o)
e=math.floor(e)
return e
end
end
return r

