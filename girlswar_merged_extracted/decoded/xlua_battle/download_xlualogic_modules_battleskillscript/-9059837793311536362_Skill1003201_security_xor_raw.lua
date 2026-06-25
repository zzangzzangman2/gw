local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local n=t[1]
local s=t[3]
local o=t[4]
local i=t[5]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local h=require("Modules/Battle/Formula")
if h:CalculateCtrlSuccess(o,s,e,t)then
t:AddBuff(e,o,i,0)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
