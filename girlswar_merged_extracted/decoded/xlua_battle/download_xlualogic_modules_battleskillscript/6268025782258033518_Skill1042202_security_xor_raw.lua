local e={}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local s=e[1]
local o=e[3]
local d=e[4]
local l=e[5]
local n={e[6]}
local r=e[7]
local h=e[8]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=math.floor(a.HeroBattleInfo.CurrFury*o*MillionCoe)
t:AddFuryWithSkill(o)
t:AddBuff(t,d,l,n)
local n=math.floor(t:GetFinalDef()*(1+e[10])*MillionCoe)
local o=math.floor(a:GetFinalDef()*e[9]*MillionCoe)
o=math.min(o,n)
t:AddBuff(t,r,h,{o})
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,s)
if(e[11]>=RandomMgr:GetBattleRandom())then
local t=t.HeroBattleInfo:GetBuff(e[12])
if(t)then
t:AddFloors(e[13])
end
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

