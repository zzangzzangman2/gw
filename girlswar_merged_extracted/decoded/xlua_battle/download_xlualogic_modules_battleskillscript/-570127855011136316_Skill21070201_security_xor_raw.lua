local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local l=e[3]
local u=e[4]
local h=e[5]
local s=e[6]
local d=e[7]
local n={e[8],e[9]}
local i=e[10]
t:AddBuffWithMaxFloor(t,s,d,n,1,i)
local n=e[11]
local i=e[12]
local s={e[13],e[14]}
local e=e[15]
t:AddBuffWithMaxFloor(t,n,i,s,1,e)
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(l,t,u,h,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

