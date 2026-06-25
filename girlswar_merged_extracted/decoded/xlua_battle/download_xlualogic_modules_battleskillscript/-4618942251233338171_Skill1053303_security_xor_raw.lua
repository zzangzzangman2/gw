local d=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return nil
end
local h=0
local o=0
local n=nil
local s=#a
for e=1,s do
local e=a[e]
local t=e:CurrHPPer()
if t>o then
h=e.HeroId
o=t
n=e
end
end
if d:CheckCanMustDie(n,AttackType.BigSkill)then
local o=ModulesInit.ProcedureNormalBattle.GetAllHeroDeadCount()
local e=e[8]+o*e[9]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e>=RandomMgr:GetBattleRandom())then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,1053304,a)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local h=e[1]
local r=e[3]
local n=e[4]
for o=1,s do
local o=a[o]
local a=o.HeroBattleInfo:GetBuffSortArr()
if#a>0 then
local i=math.max(#a*e[6],e[7])
local e={e[5],i}
o:AddBuff(t,r,n,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=""
for t=1,#a do
local t=a[t].buffId
if e==""then
e=t
else
e=e.."_"..t
end
end

end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,h)
end
return nil
end
return r

