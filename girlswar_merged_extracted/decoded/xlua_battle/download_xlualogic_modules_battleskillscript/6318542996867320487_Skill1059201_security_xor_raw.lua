local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local r=e[1]
local o=e[3]
local s=e[4]
local n={e[5],e[6]}
t:AddBuff(t,o,s,n)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local h={e[5],e[7]}
for e=1,#n do
local e=n[e]
e:AddBuff(t,o,s,h)
end
t:AddFuryWithSkill(e[8])
local o=nil
local n=0
local s=a.HeroBattleInfo:GetBuff(e[9])
local h=a.HeroBattleInfo:GetBuff(e[10])
if s or h then
local t=a.HeroBattleInfo:GetMaxHP()
n=t*e[11]*MillionCoe
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
end
if o~=nil and#o>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
local e=e[12]
for o,a in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,e)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r,0,n)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

