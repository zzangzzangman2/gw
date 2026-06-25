local h=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local n=t[1]*MillionCoe
local i=e:GetFinalAtk()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(t~=nil)then
local o=#t
for o=1,o do
local t=t[o]
t:AddBuff(e,308100504,1,0)
h:HpHealthWithBigSkillAndParam(e,a.skilltype,i,n,nil,nil,t)
end
end
return nil
end
return s 
