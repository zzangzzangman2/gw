local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local r=a[1]
local n=a[3]
local s=a[4]
local h=a[5]
local i={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
for t=1,#a do
local t=a[t]
t:CheckAddBuff(n,e,s,h,i)
end
local a=#t
for a=1,a do
local t=t[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r)
end
return nil
end
return h 
