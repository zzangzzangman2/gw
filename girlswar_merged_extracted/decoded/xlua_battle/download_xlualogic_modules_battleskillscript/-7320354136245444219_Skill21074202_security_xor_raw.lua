local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,s,e,e)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o={a}
local i=e[1]
local i=i
local h=e[3]
local r=e[4]
local n={e[5],e[6]}
t:AddBuff(t,h,r,n)
local r=e[7]
local n=e[8]
local h={e[9],e[10]}
a:AddBuff(t,r,n,h)
local n=302107414
local h=t.HeroBattleInfo:GetBuff(n)
if h then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(h)
end
local n=e[12]
local e=e[11]
local e=t.CurrBattleTeam.OpponentTeam:GetAllHeroWithBuff(e)
for t=1,#e do
local e=e[t]
if e.HeroId==a.HeroId then
i=i+n
else
table.insert(o,e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for e=1,#o do
local o=o[e]
local e=0
if o.HeroId==a.HeroId then
e=i
else
e=n
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,s,e)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
