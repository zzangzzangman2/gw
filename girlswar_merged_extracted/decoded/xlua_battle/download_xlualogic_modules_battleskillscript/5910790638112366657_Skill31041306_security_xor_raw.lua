local l=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local u=t[1]
local c=t[5]
local m=t[6]
local n={t[7]}
local a=t[8]
local i=e.HeroBattleInfo:GetBuff(303104108)
if i then
local e=i:GetBuffData()
n={e[1]}
a=e[2]
else
local e=e.HeroBattleInfo:GetBuff(303104105)
if e then
local e=e:GetBuffData()
n={e[3]}
a=e[4]
end
end
local r=e.HeroBattleInfo:GetBuff(303104103)
local h=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
local h=h.GetAndClearFightBackParam(r)
local r=0
local d=e.HeroBattleInfo:GetBuff(c)
if d then
r=d:GetFloors()
end
local r=n[1]*r
local d=u+r
if a>0 then
e:AddBuffWithMaxFloor(e,c,m,n,1,a)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=t[9]
e.HeroBattleInfo:DispelGranBuff(false,a)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local n=303104105
local a=e.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionAllSkill(a,o)
end
local a=#o
for a=1,a do
local a=o[a]
if t[3]>=RandomMgr:GetBattleRandom()then
local t=t[4]
a.HeroBattleInfo:DispelGranBuff(true,t,nil,nil,e.HeroId)
end
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303104108)
e.AddBuffToEnemy(i,a)
end
a:SetDisableDefRage(true)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,s,d)
a:SetDisableDefRage(false)
local t=t[3]
local t=t.reduceHpValue
if h and h.sepsisHPRate then
local o=h.sepsisHPRate
local t=math.floor(t*o*MillionCoe)
l:AddSepsisHp(e,a,t)
end
end
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,s.id,nil,l:Handler(#o,function(t)
if i then
local e=ModulesInit.ProcedureNormalBattle.GetEnemyCount(e)
if e>0 and e<t then
return true
end
end
local e=e.HeroBattleInfo:GetBuff(303104103)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
if t.CheckAndClearFightBackCount(e)then
return true
end
return false
end))
end
return m

