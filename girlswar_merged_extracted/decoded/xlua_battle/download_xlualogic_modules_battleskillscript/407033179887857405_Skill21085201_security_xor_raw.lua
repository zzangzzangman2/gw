local s=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=302108513
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(n)
end
local h=t[1]
local i=e.HeroBattleInfo:GetMaxHP()
local i=math.floor(i*t[6]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(e,o.skilltype,i)
local i=#a
for i=1,i do
local n=a[i]
local s=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[4]==1 then
s=math.floor(n.HeroBattleInfo.MaxHP*t[5]*MillionCoe)
end
local i=h
if n:IsRealLastRowHero()or#a<=1 then
i=i+t[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,n,o,i,0,s)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

