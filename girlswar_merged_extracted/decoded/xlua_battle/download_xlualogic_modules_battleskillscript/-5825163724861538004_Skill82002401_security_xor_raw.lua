local o=require("Modules/Battle/BattleUtil")
local a={
}
local h=a
function a.DoAction(t,e,a)
local e=t:JudgeSkillPreView(e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local e=t.HeroBattleInfo:GetBuff(308200201)
if e then
local e=e:GetBuffData()
local e=e[2]
for a=1,#e do
local e=e[a]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo and o:CheckCanTriggerFatalDmgBeforeBaseCond(t)then
local a=e.HeroBattleInfo:GetBuff(308200203)
if a then
local i=308200209
local a=1
local o={}
e:AddBuff(t,i,a,o)
end
end
end
end
return nil
end
function a.GetCanTriggerSkill(e)
return false
end
function a.DoPassiveAction(e,i)
local a=e:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetTeamHerosByTeamId(e:GetTeamId())
o=o or{}
local t={}
table.appendList(t,o)
table.sort(t,function(e,t)
if e.fight~=t.fight then
return e.fight>t.fight
end
return e.heroId<t.heroId
end)
local o={}
for e=1,#t do
if e>a[3]then
break
end
table.insert(o,t[e].heroId)
end
local n=a[1]
local s=a[2]
local t={}
table.insert(t,i.id)
table.insert(t,o)
for o=4,9 do
table.insert(t,a[o])
end
e:AddBuff(e,n,s,t)
return nil
end
return h 
