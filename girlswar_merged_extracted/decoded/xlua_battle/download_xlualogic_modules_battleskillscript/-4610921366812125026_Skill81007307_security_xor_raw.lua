local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(a,i)
local e=a:JudgeSkillPreView(i)
local t=BattleHeroType.eFront
if(e[10]>=RandomMgr:GetBattleRandom())then
t=BattleHeroType.enemyAll
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,t)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local s=e[1]
local h=e[3]
local r=e[4]
local n=e[5]
local o={}
for t=6,9 do
table.insert(o,e[t])
end
local e=#t
for e=1,e do
local e=t[e]
e:CheckAddBuff(h,a,r,n,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,s)
end
return nil
end
return d 
