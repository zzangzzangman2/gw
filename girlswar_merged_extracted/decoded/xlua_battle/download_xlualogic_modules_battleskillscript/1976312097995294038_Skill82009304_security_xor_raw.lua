local e=require("Modules/Battle/BattleUtil")
local i={
}
local l=i
function i.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=e[1]
local i={}
if e[3]>0 then
local t=t:GetFinalAtk()
local o=math.floor(t*e[6]*MillionCoe)
local t=table.lightCopyList(a)
local t=RandomTableWithSeed(t,e[3])
for a=1,#t do
local t=t[a]
if e[4]>0 then
local a=t.HeroBattleInfo:DispelGranBuff(true,e[4])
if#a>0 then
local e=math.floor(t.HeroBattleInfo.MaxHP*e[5]*MillionCoe)
e=math.min(e,o)
i[t.HeroId]=e
end
end
end
end
local l=t:GetFinalAtk()
local o=#a
for o=1,o do
local o=a[o]
local s=i[o.HeroId]or 0
local i=e[7]
local h=e[8]
local r=e[9]
local a={}
for t=10,17 do
if e[t]then
table.insert(a,e[t])
else
table.insert(a,0)
end
end
table.insert(a,0)
table.insert(a,l)
o:CheckAddBuff(i,t,h,r,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,n,d,0,s)
end
return nil
end
function i.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return l 
