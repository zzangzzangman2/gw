local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local r=e[1]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
if(o)then
for a=1,#o do
local a=o[a]
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[3],EBattleSrcType.SkillSmall,true)
end
end
local h=e[4]
local o=e[5]
local n=e[6]
local s={e[7],e[8]}
a:CheckAddBuff(h,t,o,n,s)
local h=e[9]
local s=e[10]
local n=e[11]
local o={e[12],e[13]}
a:CheckAddBuff(h,t,s,n,o)
local o=e[14]
local s=e[15]
local n=e[16]
local h=t:GetFinalAtk()
local e=math.floor(h*e[17]*MillionCoe)
local e={e}
a:CheckAddBuff(o,t,s,n,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

