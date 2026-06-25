local e=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMaxFinalAtk)
if(o==nil)then
return nil
end
local u=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local a=RandomTableWithSeed(a,e[3])
local l=e[4]
local r=e[5]
local s={e[10],e[11],e[7]}
local h=e[7]
local n=e[8]
local d={}
for o=1,#a do
if e[9]>0 then
a[o]:AddFuryWithSkill(e[9])
end
a[o]:AddBuff(t,l,r,s)
a[o]:AddBuff(t,h,n,d,e[6])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,u)
return nil
end
return u 
