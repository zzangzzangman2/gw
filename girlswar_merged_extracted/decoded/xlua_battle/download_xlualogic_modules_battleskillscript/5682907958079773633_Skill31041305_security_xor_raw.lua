local d=require("Modules/Battle/BattleUtil")
local e={}
local f=e
function e.DoAction(e,h,t)
local t=e:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local c=t[1]
local u=t[5]
local m=t[6]
local n={t[7]}
local i=t[8]
local o=e.HeroBattleInfo:GetBuff(303104108)
if o then
local e=o:GetBuffData()
n={e[1]}
i=e[2]
else
local e=e.HeroBattleInfo:GetBuff(303104105)
if e then
local e=e:GetBuffData()
n={e[3]}
i=e[4]
end
end
local r=e.HeroBattleInfo:GetBuff(303104103)
local s=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
local s=s.GetAndClearFightBackParam(r)
local l=0
local r=e.HeroBattleInfo:GetBuff(u)
if r then
l=r:GetFloors()
end
local l=n[1]*l
local r=c+l
if i>0 then
e:AddBuffWithMaxFloor(e,u,m,n,1,i)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local i=t[9]
e.HeroBattleInfo:DispelGranBuff(false,i)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=303104105
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionAllSkill(n,a)
end
local i=#a
for i=1,i do
local a=a[i]
if t[3]>=RandomMgr:GetBattleRandom()then
local t=t[4]
a.HeroBattleInfo:DispelGranBuff(true,t,nil,nil,e.HeroId)
end
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303104108)
e.AddBuffToEnemy(o,a)
end
a:SetDisableDefRage(true)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,h,r)
a:SetDisableDefRage(false)
local t=t[3]
local t=t.reduceHpValue
if s and s.sepsisHPRate then
local o=s.sepsisHPRate
local t=math.floor(t*o*MillionCoe)
d:AddSepsisHp(e,a,t)
end
end
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,h.id,nil,d:Handler(#a,function(t)
if o then
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
return f

