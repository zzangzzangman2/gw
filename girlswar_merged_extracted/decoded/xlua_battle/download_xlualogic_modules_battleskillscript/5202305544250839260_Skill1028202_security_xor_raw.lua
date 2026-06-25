local e={}
local r=e
function e.DoAction(t,h)
local e=t:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=e[1]
local r=e[3]
local n=e[4]
local o=e[5]
local i={e[6],e[7]}
local e=#a
for s=1,e do
local e=a[s]
if s==1 then
e:AddBuff(t,n,o,i)
else
e:CheckAddBuff(r,t,n,o,i)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,h,d)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

