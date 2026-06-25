local u=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local d=t[1]
local l=t[3]
local c=t[4]
local n={t[5]}
local i=t[6]
local a=e.HeroBattleInfo:GetBuff(302104108)
if a then
local e=a:GetBuffData()
n={e[1]}
i=e[2]
else
local e=e.HeroBattleInfo:GetBuff(302104105)
if e then
local e=e:GetBuffData()
n={e[3]}
i=e[4]
end
end
local r=0
local h=e.HeroBattleInfo:GetBuff(l)
if h then
r=h:GetFloors()
end
local r=n[1]*r
local h=d+r
if i>0 then
e:AddBuffWithMaxFloor(e,l,c,n,1,i)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=t[7]
e.HeroBattleInfo:DispelGranBuff(false,t)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local t=#o
for t=1,t do
local t=o[t]
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104108)
e.AddBuffToEnemy(a,t)
end
t:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,h)
t:SetDisableDefRage(false)
end
end
if a then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,s.id,nil,u:Handler(#o,function(a)
local t=ModulesInit.ProcedureNormalBattle.GetEnemyCount(e)
if t>0 and t<a then
return true
end
local e=e.HeroBattleInfo:GetBuff(302104103)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(302104103)
if t.CheckAndClearFightBackCount(e)then
return true
end
return false
end))
end
return nil
end
return c

