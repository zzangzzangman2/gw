local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local r=e[1]
local i=303111908
local i=t.HeroBattleInfo:GetBuff(i)
if i then
local a=i:GetFloors()
if a>0 then
local n=e[3]
local i=e[4]
local o={e[5],e[6]}
t:AddBuffWithFinalFloor(t,n,i,o,a)
local i=e[7]
local o=e[8]
local e={e[9],e[10]}
t:AddBuffWithFinalFloor(t,i,o,e,a)
end
end
local n=e[11]
local s=e[12]
local h=e[13]
local i={}
for t=14,19 do
table.insert(i,e[t])
end
local e=#a
for e=1,e do
local e=a[e]
local a=0
e:CheckAddBuff(n,t,s,h,i)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r,0,a)
end
return nil
end
return r 
