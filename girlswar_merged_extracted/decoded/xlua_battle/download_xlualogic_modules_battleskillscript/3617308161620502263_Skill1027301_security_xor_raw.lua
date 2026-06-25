local e={}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[1]
local n=e[3]
local h=e[4]
local i={}
for a=5,14 do
table.insert(i,e[a])
end
t:AddBuff(t,n,h,i)
local r=e[15]
local h=e[8]
local i=e[9]
local n={t.HeroId,e[10],e[11],e[12],e[13]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(r,t,h,i,n)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,s)
end
return nil
end
return d

