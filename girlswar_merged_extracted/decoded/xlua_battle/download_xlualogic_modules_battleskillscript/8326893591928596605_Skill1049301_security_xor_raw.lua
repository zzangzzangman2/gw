local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local u=e[1]
local c=t.HeroBattleInfo:GetBuff(30104907)
local d=e[3]
local l=e[4]
local r=e[5]
local n=e[3]
local i=e[6]
local s=e[7]
local h={e[8],e[9]}
local e=#a
for e=1,e do
local e=a[e]
if c==nil then
e:CheckAddBuff(d,t,l,r)
else
e:CheckAddBuff(n,t,i,s,h)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,u)
end
return nil
end
return l 
