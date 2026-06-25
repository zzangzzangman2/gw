local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
local o=e.CurrBattleTeam:GetAllHerosCount()
if(o==1)then
local i=t[7]
local o=t[8]
local n=t[9]
local t=require("Modules/Battle/Formula")
if t:CalculateCtrlSuccess(o,i,e,a)then
a:AddBuff(e,o,n,0)
end
end
if(t[3]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBack)
if(a~=nil)then
local o=t[4]
local i=t[5]
local t={t[6]}
for n,a in ipairs(a)do
a:AddBuff(e,o,i,t)
end
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
