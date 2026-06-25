local e=require("Modules/Battle/Formula")
local r=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBackMinHpPercentWithCount)
local a=a[1]
if(a==nil)then
return nil
end
t:ReduceFury(o.costMp)
local i=e[1]
local d=e[3]
local h=e[4]
local n=e[5]
local s={e[6],e[7],e[8]}
a:CheckAddBuff(d,t,h,n,s)
if(a.profession==e[9])then
i=i+e[10]
end
if t:CurrHPPer()>e[11]*MillionCoe then
local a=e[12]
local o=e[13]
local e={e[14],e[15]}
t:AddBuff(t,a,o,e)
else
local e=t.HeroBattleInfo:GetMaxHP()*e[16]*MillionCoe
r:HpHealthWithBigSkillAndParam(t,o.skilltype,e,1)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
return nil
end
return l

