local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
if(a==nil)then
return
end
local i=e[1]*MillionCoe
local o=t:GetFinalAtk()
local o=math.floor(o*i)
local n=math.floor(o*e[7]*MillionCoe)
local i=#a
for i=1,i do
local a=a[i]
local i=e[3]
local s=e[4]
local e={e[5],e[6],n}
a:AddBuff(t,i,s,e)
a:HpHealthWithPet(t,o,EBattleSrcType.PetFightSkill)
end
return nil
end
return h 
