local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.DoAction(a,i,e)
local t=a:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eColumn)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local s=t[4]
local o=false
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[7]==1 then
local e=#e
if e>=t[5]then
o=true
end
end
local n=#e
for n=1,n do
local e=e[n]
local n=0
if o then
local e=e.HeroBattleInfo.MaxHP
n=math.floor(e*t[6]*MillionCoe)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,s,0,n)
end
return nil
end
function t.GetCanTriggerSkill(e)
return false
end
function t.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[2]
local t={a.id,t[3],0}
e:AddBuff(e,o,i,t)
return nil
end
return s 
