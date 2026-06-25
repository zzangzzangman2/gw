local e={}
local u=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local c=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
if(t.FirstAtkSelfHeroId==a.HeroId)then
local m=e[3]
local c=e[4]
local d={e[5]}
local u=e[6]
local r=e[7]
local h={e[8]}
local i=e[9]
local o=e[10]
local n={e[11]}
local s=e[12]
local l=e[13]
local e={e[14]}
a:AddBuff(t,m,c,d)
a:AddBuff(t,u,r,h)
a:AddBuff(t,i,o,n)
a:AddBuff(t,s,l,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,c)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

