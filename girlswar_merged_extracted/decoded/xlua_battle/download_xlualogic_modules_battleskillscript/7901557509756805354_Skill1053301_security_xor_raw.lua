local s=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(a,n)
local t=a:JudgeSkillPreView(n)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eFront)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
a:ReduceFury(n.costMp)
local r=t[1]
local d=t[3]
local l=t[4]
local h=0
local i=0
local u=nil
local o=#e
for t=1,o do
local e=e[t]
local t=e:CurrHPPer()
if t>i then
h=e.HeroId
i=t
u=e
end
end
for o=1,o do
local e=e[o]
local o=e.HeroBattleInfo:GetBuffSortArr()
if#o>0 then
local i=math.max(#o*t[6],t[7])
local t={t[5],i}
e:AddBuff(a,d,l,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local t=""
for e=1,#o do
local e=o[e].buffId
if t==""then
t=e
else
t=t.."_"..e
end
end

end
end
local o=0
if h==e.HeroId then
if s:CheckCanMustDie(e,AttackType.BigSkill)then
local i=ModulesInit.ProcedureNormalBattle.GetAllHeroDeadCount()
local t=t[8]+i*t[9]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t>=RandomMgr:GetBattleRandom())then
e.mustBeDie=true
o=s:GetRealHurtMustDie(e)
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,n,r,nil,o)
end
return nil
end
return r

