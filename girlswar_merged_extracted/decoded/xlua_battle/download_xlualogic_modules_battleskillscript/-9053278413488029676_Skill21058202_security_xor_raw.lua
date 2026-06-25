local e=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(e,s)
local a=e:JudgeSkillPreView(s)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local i={}
table.insert(i,t)
local r=a[1]
local n=302105813
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(o,t)
end
local h=math.floor(e.HeroBattleInfo.MaxHP*a[3]*MillionCoe)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHpPercent)
if o then
if o.HeroId~=t.HeroId then
table.insert(i,o)
end
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
local n=RandomTableWithSeed(n,a[4])
for e=1,#n do
n[e]:AddFuryWithSkill(a[5])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local a=302105830
local i=1
local o={21058102,o.HeroId,h}
e:AddBuffAfterRemove(e,a,i,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,r)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

