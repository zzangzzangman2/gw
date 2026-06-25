local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(o,n,e,t)
local t=o:JudgeSkillPreView(n)
local i=e.heroMapKnife
local h=e.skillParam
local e={}
local a=0
for o,t in pairs(i)do
a=a+t
table.insert(e,o)
end
table.sort(e,function(e,t)
return e<t
end)
local t={}
if e then
for a=1,#e do
local e=e[a]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
table.insert(t,e)
end
end
end
local e=303110520
local s=o.HeroBattleInfo:GetBuff(e)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddBuffNoKnife(s,a)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for e=1,#t do
local e=t[e]
local t=e.HeroId
local t=i[t]
local t=h[1]*t
ModulesInit.ProcedureNormalBattle.SkillHurt(o,e,n,t)
end
return nil
end
return r 
