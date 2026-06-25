local e=require("Modules/Battle/BattleUtil")
local n={
}
local h=n
function n.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local n=e[4]
local i={}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for e=1,#o do
local t=o[e].HeroBattleInfo:GetBuff(n)
if t==nil then
table.insert(i,o[e])
end
end
if#i>0 then
local o=i[1]
local a=e[5]
local e={e[6],e[7]}
o:AddBuff(t,n,a,e)
end
local o=#a
for o=1,o do
local a=a[o]
a.HeroBattleInfo:DispelGranBuff(true,e[3])
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,h)
end
return nil
end
function n.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return h 
