local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,o,a)
local t=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local a=a.skillParam
local r=a[1]
local h=a[2]
local s=a[3]
local i=a[4]
local a={}
local n=#t
for n=1,n do
local t=t[n]
t:CheckAddBuff(h,e,s,i,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
