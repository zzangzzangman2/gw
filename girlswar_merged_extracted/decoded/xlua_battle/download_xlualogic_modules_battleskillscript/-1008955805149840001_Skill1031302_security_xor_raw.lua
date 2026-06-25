local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ePriorBack,e[2])
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local r=e[1]
local i=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,i,n,s)
local h=e[9]
local n=e[10]
local i={e[11],e[12]}
local s=#a
for s=1,s do
local a=a[s]
a:AddBuff(t,h,n,i)
local i=r
if a:CurrHPPer()<e[7]*MillionCoe then
i=i+e[8]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
end
return nil
end
return r 
