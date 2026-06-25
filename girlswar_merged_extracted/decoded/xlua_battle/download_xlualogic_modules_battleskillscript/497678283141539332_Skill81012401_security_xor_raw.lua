local e=require("Modules/Battle/BattleUtil")
local i={
}
local h=i
function i.DoAction(o,n,e)
local e=o:JudgeSkillPreView(n)
local t=nil
local a=nil
local s=308101201
local i=o.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t=e.GetTargetEnemy(i)
a=e.GetFriend(i)
end
if(t==nil and a==nil)then
return nil
end
local i=e[4]
if a and e[5]>0 then
local i=e[5]
local t=e[6]
local e={e[7],e[8]}
a:AddBuff(o,i,t,e)
end
if t then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(o,t,n,i)
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(a,t)
local e=a:JudgeSkillPreView(t)
local i=e[1]
local o=e[2]
local t={t.id,e[3]}
for a=9,15 do
if e[a]then
table.insert(t,e[a])
else
table.insert(t,0)
end
end
table.insert(t,0)
table.insert(t,0)
a:AddBuff(a,i,o,t)
return nil
end
return h 
