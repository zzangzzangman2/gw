local s=require("Modules/Battle/BattleUtil")
local e=require('Modules/BattleBuffScript/BuffPairTools')
local e={}
local h=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local i=302108513
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(n)
end
local h=a[1]
local i=e.HeroBattleInfo:GetMaxHP()
local i=math.floor(i*a[6]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(e,o.skilltype,i)
local i=#t
for i=1,i do
local n=t[i]
local s=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or a[4]==1 then
s=math.floor(n.HeroBattleInfo.MaxHP*a[5]*MillionCoe)
end
local i=h
if n:IsRealLastRowHero()or#t<=1 then
i=i+a[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,n,o,i,0,s)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

