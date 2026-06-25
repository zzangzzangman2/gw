local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(t,o)
local e=t:GetBuffData()
local a=e[1]
if t.CurrHeroCtrl:IsRealFirstRowHero()then
a=math.floor(a*e[2]*MillionCoe)
end
ModulesInit.ProcedureNormalBattle.StealFury(t.CurrHeroCtrl,o,a,EBattleSrcType.SkillSmall,true)
local a=e[3]
local o=e[4]
local e={e[5],e[6],e[7]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return i

