local e=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
t:RemoveOneBeans()
local n=0
local i=303111910
local i=t.HeroBattleInfo:GetBuff(i)
if i then
local e=i:GetBuffData()
local t=t:GetFinalAtk()
n=math.floor(t*e[3]*MillionCoe)
end
local c=e[1]
local i=303111908
local i=t.HeroBattleInfo:GetBuff(i)
if i then
local a=i:GetFloors()
if a>0 then
local o=e[3]
local n=e[4]
local i={e[5],e[6]}
t:AddBuffWithFinalFloor(t,o,n,i,a)
local o=e[7]
local i=e[8]
local e={e[9],e[10]}
t:AddBuffWithFinalFloor(t,o,i,e,a)
end
end
local u=e[11]
local s=e[12]
local h=e[13]
local i={}
for t=14,19 do
table.insert(i,e[t])
end
local d=e[21]
local r=e[22]
local n={n}
local l=e[20]
local e=#a
for e=1,e do
local e=a[e]
local a=0
e:CheckAddBuff(u,t,s,h,i)
e:AddBuff(t,d,r,n,l)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,c,0,a)
end
return nil
end
return c

