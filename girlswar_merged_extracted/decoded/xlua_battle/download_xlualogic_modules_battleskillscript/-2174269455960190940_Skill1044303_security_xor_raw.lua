local e=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local l=e[1]
local n=e[3]
local s=e[4]
local i={e[5],e[6],e[7],e[8]}
t:AddBuff(t,n,s,i)
local d=e[9]
local u=e[10]
local r=e[11]
local h=require("Modules/Battle/Formula")
local s=#a
for i=1,s do
local n=a[i]
local i=0
local a=l
local r=n:CheckAddBuff(d,t,u,r)
if r==false then
local t=h:GetDefBattleBefore(t)
i=t*e[12]*MillionCoe
a=a+math.floor(e[13]/s)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,n,o,a,0,i)
end
return nil
end
return u 
