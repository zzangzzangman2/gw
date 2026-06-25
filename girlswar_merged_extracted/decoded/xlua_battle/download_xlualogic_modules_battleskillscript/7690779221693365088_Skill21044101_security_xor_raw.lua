local e={
}
local h=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local s=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local a={t}
local i=0
local o=302104414
local o=e.HeroBattleInfo:GetBuff(o)
if o and t.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
local o=o:GetBuffData()
i=o[1]
table.insert(a,e[t])
break
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=#a
for o=1,o do
local a=a[o]
local o=s
if a.HeroId~=t.HeroId then
o=i
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,o)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
