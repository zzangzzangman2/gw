local e={}
local h=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local s=t[1]
local h=t[3]
local n=t[4]
local i=t[5]
local o={t[6]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
if(t.HeroBattleInfo)then
local t=math.floor(t.HeroBattleInfo.CurrFury*h*MillionCoe)
e:AddFuryWithSkill(t)
end
e:AddBuff(e,n,i,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,s)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

