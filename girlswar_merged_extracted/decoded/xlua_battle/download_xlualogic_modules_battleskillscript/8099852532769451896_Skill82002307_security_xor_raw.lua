local e=require("Modules/Battle/BattleUtil")
local i={
}
local s=i
function i.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=a[1]
local h=a[3]
local s=a[4]
local o={}
for e=5,12 do
table.insert(o,a[e])
end
local a=e:GetFinalAtk()
table.insert(o,a)
local a=#t
for a=1,a do
local t=t[a]
t:AddBuff(e,h,s,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
end
return nil
end
function i.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[13]
local n=e[14]
local a={}
for o=15,22 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
return nil
end
return s 
