local m=require("Modules/Battle/BattleUtil")
local e={}
local y=e
function e.DoAction(t,n,o)
local e=t:JudgeSkillPreView(n)
local a
if o and o.defHeroIds then
local e=o.defHeroIds[1]
a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
end
local o={a}
local w=e[1]
local l=0
local d=303104405
local u=t.HeroBattleInfo:GetBuff(d)
local c=e[3]
local s=303104413
local i=t.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
c=e.DoActionSmallSkill(i)
end
local i=e[18]
local s=303104414
local s=t.HeroBattleInfo:GetBuff(s)
if s then
local e=s:GetBuffData()
l=e[1]
i=i+e[21]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
for t=1,#e do
table.insert(o,e[t])
end
end
local s=303104422
local r=t.HeroBattleInfo:GetBuff(s)
local h=ModulesInit.ProcedureNormalBattle.GetTeamCurrSepsisHPTotalValue(a)
if h>0 then
local o=h*e[15]*MillionCoe
local a=t:GetFinalAtk()
local i=a*e[16]*MillionCoe
local a=a*e[17]*MillionCoe
local e=math.max(o,i)
e=math.min(e,a)
m:HpHealthWithBigSkillAndParam(t,n.skilltype,e,1)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local h=#o
for h=1,h do
local o=o[h]
local f=e[4]
local m=e[5]
local h=0
local h=o:CheckAddBuff(c,t,f,m,h)
if r then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoBeansActionSmallSkill(r,o,h)
end
local s=e[6]
local h=e[7]
local r={e[8],e[9]}
o:AddBuff(t,s,h,r)
local r=e[10]
local h=e[11]
local s={e[12],e[13]}
o:AddBuff(t,r,h,s)
if u then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.AddbuffBadScore(u,o,i)
end
local i=w
if o.HeroId~=a.HeroId then
i=l
end
if o.HeroBattleInfo.SepsisHp>0 then
i=i+e[14]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,i)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return y

