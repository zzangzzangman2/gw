local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(o.costMp)
local r=t[1]
local s=t[3]
local h=t[4]
local n=t[5]
local i=e:GetFinalAtk()
local t=math.floor(i*t[6]*MillionCoe)
local i={t}
local t=#a
for t=1,t do
local t=a[t]
t:CheckAddBuff(s,e,h,n,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r)
end
return nil
end
return r

