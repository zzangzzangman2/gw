local e={}
local h=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=e[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
if#o>0 then
local a=e[3]
local i=e[4]
local n={e[5],e[6]}
for e=1,#o do
local e=o[e]
e:AddBuff(t,a,i,n)
end
end
local o=e[7]
local s=e[8]
local h=e[9]
a:CheckAddBuff(o,t,s,h)
local o=a.HeroBattleInfo:GetBuff(e[10])
if o then
i=i+e[11]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

