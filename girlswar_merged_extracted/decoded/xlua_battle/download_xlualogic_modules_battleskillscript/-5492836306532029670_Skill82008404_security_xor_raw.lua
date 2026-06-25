local h=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(a,o,e)
local t=a:JudgeSkillPreView(o)
local i=e.triggerType
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local s=t[4]
if i==2 then
local o=t[1]
local a=a.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if o.CheckDizzyCountEnough(a)then
local i=t[5]
local n=t[6]
local t=t[7]
if#e>0 then
local e=h:FindMostBigAtk(e)
if e then
local e=e:CheckAddBuff(i,e,n,t,0)
if e then
o.AddDizzyCount(a)
end
end
end
end
end
end
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,s)
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[2]
local t={a.id,t[3],t[8]}
table.insert(t,0)
table.insert(t,0)
e:AddBuff(e,o,i,t)
e.isTriggerAllSkillAttackCompleteBuffForEver=true
return nil
end
return s 
