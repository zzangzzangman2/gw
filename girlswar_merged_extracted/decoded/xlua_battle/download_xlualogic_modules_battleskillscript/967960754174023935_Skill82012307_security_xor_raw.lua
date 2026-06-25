local h=require("Modules/Battle/BattleUtil")
local s={
}
local l=s
function s.DoAction(t,d)
local e=t:JudgeSkillPreView(d)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local o=table.lightCopyList(a)
o=RandomTableWithSeed(o,e[2])
if(o==nil)then
return nil
end
local s={}
for e=1,#o do
local e=o[e].HeroId
s[e]=true
end
local l=e[1]
local r=t:GetFinalAtk()
local i=0
local n=0
if 5000>=RandomMgr:GetBattleRandom()then
local n=0
local t=h:GetHeroListByGran(t,BattleHeroType.enemyAll,true,true)
local t=RandomTableWithSeed(t,e[3])
for a=1,#t do
local e=t[a].HeroBattleInfo:DispelGranBuff(true,e[4])
if e and#e>0 then
n=n+#e
end
end
if e[5]>0 then
i=math.floor(r*n*e[5]*MillionCoe)
end
if i<=0 then
a=o
end
else
a=o
local a=0
local o=h:GetHeroListByGran(t,BattleHeroType.ourAll,false,true)
local o=RandomTableWithSeed(o,e[6])
for t=1,#o do
local e=o[t].HeroBattleInfo:DispelGranBuff(false,e[7])
if e and#e>0 then
a=a+#e
end
end
if e[8]>0 and a>0 then
local o=math.floor(r*a*e[8]*MillionCoe)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for a=1,#e do
e[a]:HpHealthWithPet(t,o,EBattleSrcType.PetFightSkill)
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=#a
for e=1,e do
local o=a[e]
local a=a[e].HeroId
local e=0
if s[a]==true then
e=l
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,d,e,0,i)
end
return nil
end
function s.DoPassiveAction(e,t)
local e=e:JudgeSkillPreView(t)
return nil
end
return l 
