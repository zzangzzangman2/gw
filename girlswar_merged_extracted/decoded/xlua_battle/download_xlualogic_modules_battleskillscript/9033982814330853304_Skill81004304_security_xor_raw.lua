local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMaxFinalAtk)
local h=e[1]
local r=e[3]
local s=e[4]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.fHollow)
table.insert(o,i)
for a=1,#o do
local o=o[a]
local i=e[5]
local a={}
for t=6,8 do
table.insert(a,e[t])
end
o:AddBuff(t,s,i,a)
end
local e=#a
for e=1,e do
local a=a[e]
local e=r
if a.HeroId==i.HeroId then
e=h
end
local o=a.HeroBattleInfo:GetBuff(s)
if o then
local a=o:GetFloors()
local t=o:GetBuffData()
e=e+t[1]*a
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,e)
end
return nil
end
return r 
