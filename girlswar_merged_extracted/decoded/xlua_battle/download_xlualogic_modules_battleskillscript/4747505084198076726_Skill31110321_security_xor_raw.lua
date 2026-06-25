local s=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
t:RemoveOneBeans()
local d=e[1]
local u=e[3]
local m=e[4]
local c={e[5]}
local r=e[7]
local i=e[8]
local l=e[9]
local h={e[10],e[11]}
local n=#a
for n=1,n do
local a=a[n]
local n=0
a:AddBuff(t,u,m,c)
a:CheckAddBuff(r,t,i,l,h)
if a.HeroBattleInfo:GetBuff(i)then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[12],EBattleSrcType.SkillBig,true)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,d,0,n)
local o=o[3]
local o=o.reduceHpValue
local e=e[6]
local e=math.floor(o*e*MillionCoe)
s:AddSepsisHp(t,a,e)
end
return nil
end
return l

