local s=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=e[1]
local d=e[6]
local r=e[7]
local h={e[8],e[9]}
local o=#a
for o=1,o do
local a=a[o]
local o=n
local n=a.HeroBattleInfo:GetGranBuff(false)
if#n>e[4]then
o=o+e[5]
a:AddBuff(t,d,r,h)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
local e=e[3]
if e>0 then
local o=o[3]
local o=o.reduceHpValue
local e=math.floor(o*e*MillionCoe)
s:AddSepsisHp(t,a,e)
end
end
return nil
end
return r 
