local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eOneBack)
if(o==nil)then
return
end
e:ReduceFury(a.costMp)
local s=t[1]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ePriorBackMaxFinalAtk)
if i then
local a=t[3]
local o=t[4]
local n=math.floor(e:GetFinalAtk()*(t[6])*MillionCoe)
local t=math.floor(i:GetFinalAtk()*t[5]*MillionCoe)
t=math.min(t,n)
e:AddBuff(e,a,o,{t})
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fWithDebuffWithoutControl,t[7])
if(i)then
for t,e in ipairs(i)do
e.HeroBattleInfo:DispelAllGranBuff(false,false)
end
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ePriorBack,t[8])
local n=#i
for a=1,n do
local a=i[a]
a:ReduceFuryWithSkill(t[9],e,EBattleSrcType.SkillBig,true)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,a,s)
return nil
end
return s

