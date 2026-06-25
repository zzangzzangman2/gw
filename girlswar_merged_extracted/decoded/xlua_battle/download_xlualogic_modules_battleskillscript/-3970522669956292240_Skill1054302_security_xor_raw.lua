local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
t:ReduceFury(a.costMp)
local h=e[1]
local n=e[3]
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,o)
for e=1,#i do
local e=i[e]
local o={
openAddFury=false
}
e:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,n,0,0,o)
e:SetDisableDefRage(false)
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
for a=1,#i do
local o=i[a].HeroBattleInfo:GetBuff(e[4])
if o then
local a=i[a]
local n=e[5]
local o=e[6]
local i={e[7],e[8]}
a:AddBuff(t,n,o,i)
local i=e[9]
local o=e[10]
local e={e[11],e[12]}
a:AddBuff(t,i,o,e)
end
end
local i=e[13]
local n=e[14]
local s={e[15],e[16]}
t:AddBuff(t,i,n,s)
local i=e[17]
local s=e[18]
local n={e[19],e[20]}
t:AddBuff(t,i,s,n)
local i=e[21]
local n=e[22]
local e={e[23],e[24]}
t:AddBuff(t,i,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,a,h)
return nil
end
return r

