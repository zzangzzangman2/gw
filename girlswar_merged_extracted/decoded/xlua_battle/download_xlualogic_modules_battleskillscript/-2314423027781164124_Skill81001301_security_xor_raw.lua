local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fFront)
if(t==nil)then
return
end
local o=a[1]*MillionCoe
local a=e:GetFinalAtk()
local o=math.floor(a*o)
local a=#t
for a=1,a do
local t=t[a]
t:HpHealthWithPet(e,o,EBattleSrcType.PetFightSkill)
end
return nil
end
return i 
