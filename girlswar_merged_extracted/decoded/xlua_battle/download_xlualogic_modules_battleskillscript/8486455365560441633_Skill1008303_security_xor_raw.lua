local e={
}
local i=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local i=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for n,a in ipairs(a)do
local t=e.HeroBattleInfo.MaxHP*t[3]*MillionCoe
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i,0,t)
end
end
if(e:CurrHPPer()<t[4]*MillionCoe)then
local a=t[5]
local o=t[6]
local t={t[7]}
e:AddBuff(e,a,o,t)
end
local a=t[8]
local o=t[9]
local t={t[10]}
e:AddBuff(e,a,o,t)
return nil
end
return i 
