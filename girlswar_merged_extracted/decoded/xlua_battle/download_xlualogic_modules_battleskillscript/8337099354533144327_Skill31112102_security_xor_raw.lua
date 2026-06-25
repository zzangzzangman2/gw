local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i,e)
local a=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=e.skillParam
local r=0
for o=1,#a do
local a=a[o]
local n=math.floor(t.HeroBattleInfo.MaxHP*e[1]*MillionCoe)
local o=t:GetFinalAtk()
local o=math.floor(o*e[2]*MillionCoe)
local h=math.min(n,o)
local o=e[3]
if o>0 then
local i=e[4]
local e={e[5],e[6]}
a:AddBuff(t,o,i,e)
end
local o=e[7]
if o>0 then
local i=e[8]
local e={e[9],e[10]}
a:AddBuff(t,o,i,e)
end
local n=e[11]
local o=e[12]
local s=e[13]
if o>0 then
a:CheckAddBuff(n,t,o,s,0)
end
local o=e[14]
if o>0 then
local i=e[15]
local e={e[16],e[17]}
a:AddBuff(t,o,i,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r,0,h)
end
return nil
end
return h 
