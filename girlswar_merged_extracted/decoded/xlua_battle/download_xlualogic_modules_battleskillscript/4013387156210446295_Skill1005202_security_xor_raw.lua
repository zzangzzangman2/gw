local e={}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local d=e[1]
local r=e[3]
local h=e[4]
local s={e[5]}
local i=e[6]
local n=e[7]
local a={e[8]}
t:AddBuff(t,r,h,s)
t:AddBuff(t,i,n,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,d)
local o=a.HeroBattleInfo:GetBuff(e[9])
local a=a.HeroBattleInfo:GetBuff(e[10])
if(o or a)then
t:AddFuryWithSkill(e[11])
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

