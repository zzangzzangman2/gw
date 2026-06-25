local e={
}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local s=t[1]
local n=t[3]
local i=t[4]
local a={t[5]}
e:AddBuff(e,n,i,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,s)
local o=e.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(o==1)then
local i=t[6]
local o=t[7]
local t=t[8]
local n=require("Modules/Battle/Formula")
if n:CalculateCtrlSuccess(o,i,e,a)then
a:AddBuff(e,o,t,0)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
