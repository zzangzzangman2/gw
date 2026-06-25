local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(n,i,e,t)
local t=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(i)
local t=e.defHeroIds
local e=nil
local a=0
if t then
for o=1,#t do
local t=t[o]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if ModulesInit.ProcedureNormalBattle.CheckTargetCondition(t)then
local o=t.HeroBattleInfo:GetBuff(302108715)
if o then
local o=o:GetFloors()
if e==nil then
e=t
a=o
else
if a==o then
if e.HeroId<t.HeroId then
e=t
a=o
end
elseif a<o then
e=t
a=o
end
end
end
end
end
end
if e==nil then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local a=e.HeroBattleInfo.MaxHP*10
local t=3160
local s=1
local o={}
e:AddBuff(nil,t,s,o)
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(n,e,i,0,0,a)
return nil
end
return s 
