local e=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local u=e[1]
local s=e[3]
local n=e[4]
local o={e[5],e[6]}
t:AddBuff(t,s,n,o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local h={e[5],e[7]}
for e=1,#o do
local e=o[e]
e:AddBuff(t,s,n,h)
end
t:AddFuryWithSkill(e[8])
local n=e[15]
local h=e[16]
local r={e[17],e[18]}
a:AddBuff(t,n,h,r)
local o=nil
local s=0
local l=a.HeroBattleInfo:GetBuff(e[9])
local d=a.HeroBattleInfo:GetBuff(e[10])
if l or d then
local t=a.HeroBattleInfo:GetMaxHP()
s=t*e[11]*MillionCoe
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eHollow)
end
if o~=nil and#o>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
local s=e[12]
for o,a in ipairs(o)do
a:AddBuff(t,n,h,r)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,s)
if(e[13]>=RandomMgr:GetBattleRandom())then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[14],EBattleSrcType.SkillSmall,true)
end
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,u,0,s)
if(e[13]>=RandomMgr:GetBattleRandom())then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[14],EBattleSrcType.SkillSmall,true)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

