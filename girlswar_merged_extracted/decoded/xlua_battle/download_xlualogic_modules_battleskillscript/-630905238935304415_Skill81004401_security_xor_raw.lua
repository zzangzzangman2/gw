local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.DoAction(i,e,a)
local e=i:JudgeSkillPreView(e)
local t=nil
if a and a.defHeroIds then
local e=a.defHeroIds
for a=1,#e do
local e=e[a]
t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
if t==nil then
return
end
local n=e[3]
local s=e[4]
local a={}
for o=5,18 do
if e[o]then
table.insert(a,e[o])
else
table.insert(a,0)
end
end
t:AddBuff(i,n,s,a)
end
function t.GetCanTriggerSkill(e)
return false
end
function t.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[2]
local t={a.id}
e:AddBuff(e,o,i,t)
return nil
end
return s 
