local t=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,a,o)
local i=e:JudgeSkillPreView(a)
local o=o.defHeroId
local t=t:GetTargetHeroCtrl(o)
if t==nil then
return
end
local o=0
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
local n=e:GetFinalAtk()
local i=math.floor(n*#i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o,0,i)
return nil
end
return s 
