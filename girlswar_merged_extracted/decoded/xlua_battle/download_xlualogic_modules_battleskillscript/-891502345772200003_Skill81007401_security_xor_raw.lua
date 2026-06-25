local i=require("Modules/Battle/BattleUtil")
local t={
}
local n=t
function t.DoAction(o,e,t)
local a=o:JudgeSkillPreView(e)
local e={}
if t and t.defHeroIds then
for a=1,#t.defHeroIds do
local t=t.defHeroIds[a]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
table.insert(e,t)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
for t=1,#e do
local e=e[t]
local t=e.HeroBattleInfo.MaxHP
local t=math.floor(t*a[4]*MillionCoe)
i:ReduceSepsisHp(o,e,t,false,false)
e.HeroBattleInfo:DispelGranBuff(false,a[6])
end
return nil
end
function t.GetCanTriggerSkill(e)
return false
end
function t.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],e[5],0}
t:AddBuff(t,o,i,e)
return nil
end
return n 
