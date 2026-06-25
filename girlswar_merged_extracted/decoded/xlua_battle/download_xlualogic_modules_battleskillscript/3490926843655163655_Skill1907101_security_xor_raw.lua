local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,o,e)
local a=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=e.skillParam
local r=e[4]
local h=e[5]
local s=e[6]
local n=e[7]
local i={e[8]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(h,t,s,n,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
