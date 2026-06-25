local e={
}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local r=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=e[3]
local s=e[4]
local o=math.floor(t:GetFinalAtk()*(1+e[7])*MillionCoe)
local n=math.floor(a:GetFinalAtk()*e[5]*MillionCoe)
n=math.min(n,o)
local d=math.floor(t:GetFinalDef()*(1+e[8])*MillionCoe)
local o=math.floor(a:GetFinalDef()*e[6]*MillionCoe)
o=math.min(o,d)
t:AddBuff(t,h,s,{n,o})
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r)
local a=a[2]
if(a)then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
local o=e[9]
local i=e[10]
local e={e[11]}
for n,a in ipairs(a)do
a:AddBuff(t,o,i,e)
end
end
end
return nil
end
return h 
