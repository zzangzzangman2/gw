local o=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(a,i)
local e=a:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil or#t<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local s=e[1]
local n=o:GetHeroByFinalHighAtk(t)
local o=o:FindHighTreatment(t)
local o={n,o}
local o=RandomTableWithSeed(o,1)
local o=o[1]
if o then
local n=e[3]
local i=e[4]
local t=e[5]
local e=0
o:CheckAddBuff(n,a,i,t,e)
end
local o=#t
for o=1,o do
local t=t[o]
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound%2==1 then
local o=e[6]
local i=e[7]
local n=e[8]
local e={e[9],e[10],e[11],e[12],e[13],0}
t:CheckAddBuff(o,a,i,n,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,i,s)
end
return nil
end
return h 
