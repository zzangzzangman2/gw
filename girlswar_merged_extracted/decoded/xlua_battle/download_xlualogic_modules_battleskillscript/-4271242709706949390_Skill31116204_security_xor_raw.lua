local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,o,t,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=t[1]
local n=t[3]
local i=t[9]
local i=303111609
local i=e.HeroBattleInfo:GetBuff(i)
if i then
local e=i:GetBuffData()
n=e[1]
end
local i=t[4]
local h=t[5]
local s=e:GetFinalAtk()
local t=math.floor(s*t[6]*MillionCoe)
local s={t}
local t=#a
for t=1,t do
local t=a[t]
t:CheckAddBuff(n,e,i,h,s)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r)
end
return nil
end
return d 
