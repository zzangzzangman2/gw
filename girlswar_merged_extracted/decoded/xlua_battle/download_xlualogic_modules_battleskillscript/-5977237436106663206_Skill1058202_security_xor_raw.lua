local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(o==nil)then
return nil
end
local i={}
table.insert(i,o)
local h=t[1]
local r=math.floor(e.HeroBattleInfo.MaxHP*t[3]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHpPercent)
if a then
if a.HeroId~=o.HeroId then
table.insert(i,a)
end
end
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
local s=RandomTableWithSeed(s,t[4])
for e=1,#s do
s[e]:AddFuryWithSkill(t[5])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local i=30105814
local s=1
local t={1058102,a.HeroId,r}
e:AddBuffAfterRemove(e,i,s,t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

