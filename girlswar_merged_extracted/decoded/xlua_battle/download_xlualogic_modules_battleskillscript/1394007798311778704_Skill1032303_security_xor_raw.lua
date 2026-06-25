local e=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return nil
end
local o=#a
if o<=0 then
return nil
end
t:ReduceFury(i.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local d=e[6]*MillionCoe/o
local l=e[7]*MillionCoe
local u=e[4]
local n=e[5]
local s=e[3]
local h=e[5]
if(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-t.appearBattleBigRound>e[8])then
r=e[9]
d=e[14]*MillionCoe/o
l=e[15]*MillionCoe
u=e[12]
n=e[13]
s=e[11]
h=e[13]
end
local e=0
local c={}
for o=1,o do
local a=a[o]
local o=a:GetFinalDef()*d
a:AddBuff(t,u,n,{o,t.HeroId})
e=e+o
table.insert(c,a.HeroId)
end
e=math.min(e,t:GetFinalDef()*l)
t:AddBuff(t,s,h,{e,c})
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,r)
end
return nil
end
return m 
