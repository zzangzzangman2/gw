local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(o,t,e)
local t=o:JudgeSkillPreView(t)
local t=0
local a=e.defHeroIds
local t=nil
if a then
local e=a[1]
t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
local a=e.trigerBuffData
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local n=a[4]
local i=a[5]
local e={a[6],a[7],e.ctrlBuffId,e.ctrlBuffRound,e.ctrlBuffData}
t:AddBuff(o,n,i,e,1,{isForce=true,triggerSkillAtkType=ETriggerSkillAtkType.FightBack})
return nil
end
return i 
