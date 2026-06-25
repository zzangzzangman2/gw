local e={}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local r=t[3]
local h=t[4]
local s={t[5]}
local i=t[6]
local n=t[7]
local t={t[8]}
e:AddBuff(e,r,h,s)
e:AddBuff(e,i,n,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

