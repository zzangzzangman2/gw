local e={
}
local h=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
e:ReduceFury(i.costMp)
local r=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=t[3]
local s=t[4]
local o=math.floor(e:GetFinalAtk()*(1+t[7])*MillionCoe)
local n=math.floor(a:GetFinalAtk()*t[5]*MillionCoe)
n=math.min(n,o)
local d=math.floor(e:GetFinalDef()*(1+t[8])*MillionCoe)
local o=math.floor(a:GetFinalDef()*t[6]*MillionCoe)
o=math.min(o,d)
e:AddBuff(e,h,s,{n,o})
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
e.IgnoreBlock=true
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,r)
e.IgnoreBlock=false
local a=a[2]
if(a)then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a)then
local o=t[9]
local i=t[10]
local t={t[11]}
for n,a in ipairs(a)do
a:AddBuff(e,o,i,t)
end
end
end
return nil
end
return h 
