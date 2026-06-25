local n=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local c=e[1]
local u=e[3]
local m=e[4]
local r={e[5]}
local d=e[7]
local l=e[8]
local h=e[9]
local s={e[10],e[11]}
local i=#a
for i=1,i do
local a=a[i]
local i=0
a:AddBuff(t,u,m,r)
a:CheckAddBuff(d,t,l,h,s)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,c,0,i)
local o=o[3]
local o=o.reduceHpValue
local e=e[6]
local e=math.floor(o*e*MillionCoe)
n:AddSepsisHp(t,a,e)
end
return nil
end
return u 
