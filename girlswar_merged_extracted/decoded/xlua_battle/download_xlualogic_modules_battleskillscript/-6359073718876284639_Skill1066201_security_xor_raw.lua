local n=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local u=e[1]
local i=t.HeroBattleInfo:GetMaxHP()
local i=math.floor(i*e[3]*MillionCoe)
n:HpHealthWithSmallSkillAndParam(t,o.skilltype,i)
t:AddFuryWithSkill(e[4])
local i=#a
local n=e[5]
if i<=1 then
n=e[6]
end
local l=e[7]
local d=e[8]
local h=e[9]
local r=e[10]
local s={e[11],e[12],e[13]}
t:AddBuff(t,h,r,s)
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if#s<=e[14]then
t:AddFuryWithSkill(e[15])
end
for e=1,i do
local e=a[e]
e:CheckAddBuff(n,t,l,d,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,u)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

