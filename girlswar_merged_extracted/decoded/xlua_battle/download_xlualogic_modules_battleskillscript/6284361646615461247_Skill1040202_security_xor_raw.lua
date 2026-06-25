local e={}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=e[1]
local o=e[3]
t:AddFuryWithSkill(o)
local u=e[4]
local d=e[5]
local l={e[6],e[7],e[8]}
local r=e[10]
local n=e[11]
local s={e[12],e[13],e[14]}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
for a=1,#o do
local a=o[a]
a:AddBuff(t,u,d,l)
if(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-t.appearBattleBigRound+1>=e[9])then
a:AddBuff(t,r,n,s)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,h)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

