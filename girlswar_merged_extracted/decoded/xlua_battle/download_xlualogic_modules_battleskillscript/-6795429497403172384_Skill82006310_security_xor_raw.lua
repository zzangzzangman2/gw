local e=require("Modules/Battle/BattleUtil")
local n={
}
local r=n
function n.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local n=e[4]
local o={}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for e=1,#i do
local t=i[e].HeroBattleInfo:GetBuff(n)
if t==nil then
table.insert(o,i[e])
end
end
if#o>0 then
local a=o[1]
local i=e[5]
local o=a.HeroBattleInfo.MaxHP
local o=math.floor(o*e[6]*MillionCoe)
local e={o,e[7],e[8]}
a:AddBuff(t,n,i,e)
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
local o=e[9]
local i=e[10]
local a={}
for o=11,16 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return r 
