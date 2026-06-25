local e=require("Modules/Battle/BattleUtil")
local o={
}
local s=o
function o.DoAction(t,o,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=e[3]
local i=#a
for i=1,i do
local a=a[i]
a.HeroBattleInfo:DispelGranBuff(true,e[4])
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n)
end
local n=e[5]
local i=e[6]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a~=nil)then
local o=#a
for o=1,o do
local a=a[o]
local o=math.floor(a.HeroBattleInfo.MaxHP*e[7]*MillionCoe)
local e={o,e[8],e[9]}
a:AddBuff(t,n,i,e)
end
end
return nil
end
function o.GetCanTriggerSkill(e)
if e==BuffTriggerTime.battleBeginPetHelpSkill then
return true
end
return false
end
return s 
