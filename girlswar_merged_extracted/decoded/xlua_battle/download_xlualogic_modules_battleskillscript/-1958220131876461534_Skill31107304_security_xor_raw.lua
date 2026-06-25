local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(a,t,e)
local t=a:JudgeSkillPreView(t)
local t=e.defHeroIds
local o=e.round
local e={}
for a=1,#t do
local t=t[a]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
table.insert(e,t)
end
if(#e<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=303110703
local a=a.HeroBattleInfo:GetBuff(t)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(t)
for t=1,#e do
i.GainGodPunish(a,e[t],o)
end
end
return nil
end
return i 
