local e={
}
local d=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local h=t[1]
local s=t[3]
local a=t[4]
local r=t[5]
local n=t[6]
local i=t[7]
local t={t[8]}
e:AddBuff(e,n,i,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local i=require("Modules/Battle/Formula")
if i:CalculateCtrlSuccess(a,s,e,t)then
t:AddBuff(e,a,r,0)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
