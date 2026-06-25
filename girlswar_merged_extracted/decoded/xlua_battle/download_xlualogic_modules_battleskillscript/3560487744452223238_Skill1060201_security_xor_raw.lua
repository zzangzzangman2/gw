local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[1]
local h=e[5]
local o=e[6]
local i={e[7],e[8]}
t:AddBuff(t,h,o,i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.all)
local o=#o
local i=1
for t=10,31,2 do
if o==e[t]then
i=e[t+1]
break
end
end
local o=#a
for o=1,o do
local o=a[o]
local a=s
if(o.profession==e[3])then
a=a+e[4]
end
local e={
realHurtInCrit=math.floor(o.HeroBattleInfo.MaxHP*e[9]*MillionCoe),
damageRate=i,
}
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,a,0,0,e)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

