local e={
}
local l=e
function e.DoAction(e,r)
local t=e:JudgeSkillPreView(r)
local l=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local a={t}
local h=0
local d=303104405
local s=e.HeroBattleInfo:GetBuff(d)
local i=0
local o=303104414
local o=e.HeroBattleInfo:GetBuff(o)
if o then
local e=o:GetBuffData()
h=e[1]
i=i+e[21]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
for t=1,#e do
table.insert(a,e[t])
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=#a
for n=1,n do
local a=a[n]
local n=l
if a.HeroId~=t.HeroId then
n=h
end
if o then
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(d)
e.AddbuffBadScore(s,a,i)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,r,n)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return l 
