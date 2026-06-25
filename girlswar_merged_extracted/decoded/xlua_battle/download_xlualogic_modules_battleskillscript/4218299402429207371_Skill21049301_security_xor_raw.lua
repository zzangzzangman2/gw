local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(o.costMp)
local d=t[1]
local h=e.HeroBattleInfo:GetBuff(302104907)
local r=t[3]
local s=t[4]
local n=t[5]
local i=0
if h then
local e=h:GetBuffData()
s=e[1]
n=e[2]
i={e[3],e[4]}
end
local t=#a
for t=1,t do
local t=a[t]
t:CheckAddBuff(r,e,s,n,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,d)
end
return nil
end
return l 
