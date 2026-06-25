local s=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=e[1]
if(a.profession==e[3])then
o=o+e[4]
end
local h=e[5]
local r=e[6]
local d={e[7],e[8]}
local i=e[9]
t:AddBuffWithMaxFloor(t,h,r,d,1,i)
local i=a.HeroBattleInfo:GetCurrFury()
local i=math.min(i,e[10])
a:ReduceFuryWithSkill(i,t,EBattleSrcType.SkillBig,true)
t:AddFuryWithSkill(i)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
if(i)then
local e=s:GetHeroArrWithBuff(i,true,false,e[11])
for a=1,#e do
local e=e[a]
e.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

