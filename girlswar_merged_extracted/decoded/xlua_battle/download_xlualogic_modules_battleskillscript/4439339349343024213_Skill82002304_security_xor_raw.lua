local e=require("Modules/Battle/BattleUtil")
local o={
}
local r=o
function o.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local h=a[1]
local s=a[3]
local n=a[4]
local o={}
for e=5,12 do
table.insert(o,a[e])
end
local a=e:GetFinalAtk()
table.insert(o,a)
local a=#t
for a=1,a do
local t=t[a]
t:AddBuff(e,s,n,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,h)
end
return nil
end
function o.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return r 
