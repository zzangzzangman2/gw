local h=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local e=302103913
local e=t.HeroBattleInfo:GetBuff(e)
local e=e:GetBuffData()
local u=e[1]
local o=false
local r=e[2]
local n=e[3]
local d=e[4]
local c={e[5],e[6]}
local s=e[7]
local l=#a
for e=1,l do
local e=a[e]
e:CheckAddBuff(r,t,n,d,c,1,s)
if o==false then
local e=e.HeroBattleInfo:GetBuff(n)
if e then
local e=e:GetFloors()
if e>=s then
o=true
end
end
end
end
if e[23]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[23]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[22]=0
end
local s=e[22]
local n=e[10]
if o==true then
if s<n then
e[22]=e[22]+1
t:AddMaxFuryWithSkill()
local o=e[8]
local a=e[9]
local e=0
t:AddBuff(t,o,a,e)
end
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fMostSepsisHp,e[11])
for a=1,#o do
local i=o[a]
local a=o[a]:GetFinalAtk()
local e=math.floor(a*e[12]*MillionCoe)
h:ReduceSepsisHp(t,i,e,true,true)
end
local d=e[13]
local r=e[14]
local h={e[15]}
local o=e[16]
local n=e[17]
local s=e[18]
if e[24]==1 then
o=e[19]
n=e[20]
s=e[21]
end
local l=e[25]
if l<s then
e[25]=e[25]+1
t:AddBuffWithMaxFloor(t,d,r,h,o,n)
end
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,u)
end
return nil
end
return c 
