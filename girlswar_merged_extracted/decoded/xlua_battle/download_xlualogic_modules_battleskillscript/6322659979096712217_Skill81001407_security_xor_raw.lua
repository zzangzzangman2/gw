local e=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(a,e,o)
local e=a:JudgeSkillPreView(e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local t={}
local o=o.defHeroIds
local i=nil
if o then
for e=1,#o do
local e=o[e]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
table.insert(t,e)
end
end
local i=e[4]*MillionCoe
local o=#t
for o=1,o do
local t=t[o]
local o=t.HeroBattleInfo:GetMaxHP()
local n=math.floor(o*i)
local i=e[6]
local o=e[7]
local e={e[8],e[9]}
t:AddBuff(a,i,o,e)
local e=308100104
local i=1
local o=0
t:AddBuff(a,e,i,o)
t:HpHealthWithPet(a,n,EBattleSrcType.PetHelpSkill)
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
local e={a.id,e[3],e[5],0}
t:AddBuff(t,o,i,e)
return nil
end
return s 
