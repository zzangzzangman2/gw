local e={
}
local n=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local r=e[1]
local n=e[3]
local i=e[4]
local s=e[5]
local h={e[6]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
a:ReduceFuryWithSkill(n,t,EBattleSrcType.SkillBig,true)
a:AddBuff(t,i,s,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r)
local s=e[7]
local h=e[8]
local n={e[9]}
local o=e[10]
local a=e[11]
local i={e[12]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.selfColumn)
if(e)then
for t,e in ipairs(e)do
e:AddBuff(e,s,h,n)
e:AddBuff(e,o,a,i)
end
end
return nil
end
return n 
