local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(i,a,e,t)
local t=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(a)
local t=e.defHeroIds
local o=e.realhurt
local e=nil
if t then
for a=1,#t do
local t=t[a]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if e==nil then
e=t
end
t:SetHeroMustDie()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=t:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleUrCTZSExpoideBuff,e.x,e.y,50,3,0,false,function()
end)
end
end
end
if e==nil then
return
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(i,e,a,0,0,o)
end
return nil
end
return n 
