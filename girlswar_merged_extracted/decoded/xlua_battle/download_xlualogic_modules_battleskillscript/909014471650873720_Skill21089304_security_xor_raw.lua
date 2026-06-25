local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,i,e,a)
local a=t:JudgeSkillPreView(i)
local e=e.cfgArgs
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local o=302108915
local o=t.HeroBattleInfo:GetBuff(o)
if o then
local a=o:GetBuffData()
e={}
for t=3,18 do
table.insert(e,a[t])
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=e[12]
local n=#a
for t=1,12,2 do
if e[t]==n then
o=e[t+1]
break
end
end
if#e>=14 then
local e={
attrId=e[13],
value=e[14],
}
t:AddAttrValueInCurAttack(e)
end
if#e>=16 then
local e={
attrId=e[15],
value=e[16],
}
t:AddAttrValueInCurAttack(e)
end
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,o)
end
return nil
end
return s 
