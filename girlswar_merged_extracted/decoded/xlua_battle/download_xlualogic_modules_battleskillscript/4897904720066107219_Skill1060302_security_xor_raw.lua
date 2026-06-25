local e=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local u=e[1]
local i=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,i,n,s)
local n=e[7]
local i=e[8]
local s={e[9],e[10]}
t:AddBuff(t,n,i,s)
local m=e[11]
local d=e[12]
local l={e[13],e[14]}
local c=e[15]
local r=e[16]
local s=e[17]
local i=t:GetFinalAtk()
local i=math.floor(i*e[18]*MillionCoe)
local n={i}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.all)
local h=#i
local i=1
for t=19,40,2 do
if h==e[t]then
i=e[t+1]
break
end
end
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,m,d,l)
e:CheckAddBuff(c,t,r,s,n)
local a={
damageRate=i,
}
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,u,0,0,a)
end
return nil
end
return c

