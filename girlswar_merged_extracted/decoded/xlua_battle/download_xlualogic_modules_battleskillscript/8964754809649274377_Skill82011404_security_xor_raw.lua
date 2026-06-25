local n=require("Modules/Battle/BattleUtil")
local o={
}
local r=o
function o.DoAction(o,i,a,e)
local e=o:JudgeSkillPreView(i)
local t=0
if a then
t=a.defHeroId
end
local a=n:GetTargetHeroCtrl(t)
if(a==nil)then
return nil
end
local t={a}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
table.appendList(t,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local r=e[3]
local n=e[5]
local s=e[6]
local h=e[7]
local e={e[8],e[9]}
a:CheckAddBuff(n,o,s,h,e)
local e=#t
for e=1,e do
local e=t[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(o,e,i,r)
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[4]}
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,i,e)
return nil
end
return r 
