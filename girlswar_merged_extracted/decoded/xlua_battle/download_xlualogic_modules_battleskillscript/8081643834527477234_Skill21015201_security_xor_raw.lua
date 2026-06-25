local e=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local l=e[1]
local c=e[3]
local f=e[4]
local m=e[5]
local r=0
local d=e[6]
local u=e[7]
local h=e[8]
local s=e[10]
local n=t.HeroBattleInfo:GetBuff(302101512)
local o=#a
for o=1,o do
local a=a[o]
a:CheckAddBuff(c,t,f,m,r)
local o=s
if n then
local e=a.HeroBattleInfo:GetBuff(3120)
if e then
local e=n:GetBuffData()
o=e[1]
end
end
local e={e[9],o}
a:CheckAddBuff(d,t,u,h,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,l)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

