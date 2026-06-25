local e={
}
local h=e
function e.DoAction(t,n,e)
local o=t:JudgeSkillPreView(n)
local e=e.skillParam
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=o[1]
local o=math.floor(e[1]*e[6]*MillionCoe)
local r=e[3]
local i=e[4]
local d=e[5]
local s={o}
local o={}
local h=#a
for e=1,h do
local e=a[e]
e:CheckAddBuff(r,t,i,d,s)
local t=e.HeroBattleInfo:GetBuff(i)
if(t)then
table.insert(o,e)
end
end
if e[7]==1 or ModulesInit.ProcedureNormalBattle.IsPVE()==false then
if#o>0 then
local a=RandomTableWithSeed(o,e[8])
for o=1,#a do
local a=a[o]
local i=308200105
local s=1
local o=0
a:AddBuff(t,i,s,o)
local o=a.HeroBattleInfo.MaxHP
local e=math.floor(o*e[9]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,0,0,e)
end
end
end
return nil
end
return h 
