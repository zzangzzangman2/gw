local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local r=e[1]
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[3],EBattleSrcType.SkillSmall,true)
local s=e[4]
local o=e[5]
local i={e[6],e[7],e[8]}
t:AddBuff(t,s,o,i)
local h=e[9]
local o=e[10]
local i=e[11]
local s=t:GetFinalAtk()
local e=math.floor(s*e[12]*MillionCoe)
local e={e}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,r)
local n=n[3]
if n.criticalOrBlock==1 then
a:AddBuff(t,o,i,e)
else
a:CheckAddBuff(h,t,o,i,e)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

