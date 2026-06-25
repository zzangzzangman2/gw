local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e,a)
local o=t:JudgeSkillPreView(e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local e={}
local a=a.defHeroIds
local i=nil
if a then
for t=1,#a do
local t=a[t]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
table.insert(e,t)
end
end
local o=o[4]*MillionCoe
local a=#e
for a=1,a do
local e=e[a]
local a=e.HeroBattleInfo:GetMaxHP()
local a=math.floor(a*o)
local o=308100104
local n=1
local i=0
e:AddBuff(t,o,n,i)
e:HpHealthWithPet(t,a,EBattleSrcType.PetHelpSkill)
end
return nil
end
function e.GetCanTriggerSkill(e)
return false
end
function e.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],e[5],0}
t:AddBuff(t,o,i,e)
return nil
end
return s 
