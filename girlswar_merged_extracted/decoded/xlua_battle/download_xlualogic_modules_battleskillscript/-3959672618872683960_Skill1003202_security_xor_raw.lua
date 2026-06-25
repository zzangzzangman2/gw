local e={
}
local r=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local h=a[1]
local o=0
local n=a[5]
local s=a[6]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local r=e.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(r==1)then
o=a[4]
else
o=a[3]
end
local a=require("Modules/Battle/Formula")
if a:CalculateCtrlSuccess(n,o,e,t)then
t:AddBuff(e,n,s,0)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
