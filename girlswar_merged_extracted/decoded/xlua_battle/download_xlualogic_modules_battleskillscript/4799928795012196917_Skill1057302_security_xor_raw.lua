local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eOneBack)
if(a==nil)then
return
end
e:ReduceFury(o.costMp)
local n=t[1]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ePriorBackMaxFinalAtk)
if i then
local n=t[3]
local o=t[4]
local a=math.floor(e:GetFinalAtk()*(t[6])*MillionCoe)
local t=math.floor(i:GetFinalAtk()*t[5]*MillionCoe)
t=math.min(t,a)
e:AddBuff(e,n,o,{t})
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fWithDebuffWithoutControl,t[7])
if(t)then
for t,e in ipairs(t)do
e.HeroBattleInfo:DispelAllGranBuff(false,false)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n)
return nil
end
return s

