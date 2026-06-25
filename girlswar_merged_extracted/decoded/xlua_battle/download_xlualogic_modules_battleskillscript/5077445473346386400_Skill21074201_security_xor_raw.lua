local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,i,e,e)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o={a}
local n=e[1]
local h=n
local r=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,r,n,s)
local s=e[7]
local n=e[8]
local e={e[9],e[10]}
a:AddBuff(t,s,n,e)
local e=302107414
local n=t.HeroBattleInfo:GetBuff(e)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.DoActionSmallSkill(n)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for e=1,#o do
local o=o[e]
local e=0
if o.HeroId==a.HeroId then
e=h
else
e=skillHurtRateOnOtherHero
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,e)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
