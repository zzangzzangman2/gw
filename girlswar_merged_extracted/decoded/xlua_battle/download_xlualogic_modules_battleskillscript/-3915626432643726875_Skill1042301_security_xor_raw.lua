local e=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local e={}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local h=t[1]
local r=t[3]
local n=t[4]
local s={t[5]}
local i=t[6]
local o=t[7]
local t={t[8]}
e:AddBuff(e,r,n,s)
e:AddBuff(e,i,o,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local t=t[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h)
end
end
return nil
end
return s

