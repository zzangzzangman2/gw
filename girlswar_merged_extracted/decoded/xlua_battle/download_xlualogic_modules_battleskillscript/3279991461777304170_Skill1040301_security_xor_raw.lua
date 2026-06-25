local e={}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local i=e[3]
t:AddFuryWithSkill(i)
local i=e[12]
local n=e[13]
local s={e[14],e[15],e[16],e[17]}
if(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-t.appearBattleBigRound+1>=e[11])then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
for a=1,#e do
local e=e[a]
e:AddBuff(t,i,n,s)
end
end
local n=e[4]
local i=e[5]
local s=e[6]
local h={e[7],e[8],e[9],e[10],t.HeroBattleInfo.MaxHP}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(n,t,i,s,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r)
end
return nil
end
return d

