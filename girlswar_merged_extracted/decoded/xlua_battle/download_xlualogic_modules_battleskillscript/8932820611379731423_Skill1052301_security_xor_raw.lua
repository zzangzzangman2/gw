local e=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local e={}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local r=e[1]
local d=e[3]
local n=e[4]
local h=e[5]
local s={e[6]}
local o=t.CurrBattleTeam:GetFrontOrBackHeros(true)
for a=1,#o do
local i=o[a]
local o=e[8]
local a=e[9]
local e={e[10],e[11]}
i:AddBuff(t,o,a,e)
end
local o=nil
local o=#a
for o=1,o do
local a=a[o]
a:CheckAddBuff(d,t,n,h,s)
local o=r
if a.HeroBattleInfo:GetBuff(n)then
o=o+e[7]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
return nil
end
return r

