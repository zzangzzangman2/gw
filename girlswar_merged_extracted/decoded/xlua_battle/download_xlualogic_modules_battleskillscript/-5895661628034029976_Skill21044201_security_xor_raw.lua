local r=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o={a}
local h=e[1]
local s=0
local i=302104414
local i=t.HeroBattleInfo:GetBuff(i)
if i and a.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
local a=i:GetBuffData()
s=a[1]
table.insert(o,e[t])
break
end
end
end
local i=ModulesInit.ProcedureNormalBattle.GetTeamCurrSepsisHPTotalValue(a)
if i>0 then
local o=i*e[15]*MillionCoe
local a=t:GetFinalAtk()
local i=a*e[16]*MillionCoe
local a=a*e[17]*MillionCoe
local e=math.max(o,i)
e=math.min(e,a)
r:HpHealthWithBigSkillAndParam(t,n.skilltype,e,1)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local i=#o
for i=1,i do
local o=o[i]
local l=e[3]
local d=e[4]
local r=e[5]
local i=0
o:CheckAddBuff(l,t,d,r,i)
local i=e[6]
local r=e[7]
local d={e[8],e[9]}
o:AddBuff(t,i,r,d)
local i=e[10]
local r=e[11]
local d={e[12],e[13]}
o:AddBuff(t,i,r,d)
local i=h
if o.HeroId~=a.HeroId then
i=s
end
if o.HeroBattleInfo.SepsisHp>0 then
i=i+e[14]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,i)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

