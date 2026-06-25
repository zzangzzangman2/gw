local u=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,s,t)
local t=e:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local d=t[1]
local l=t[3]
local c=t[4]
local i={t[5]}
local n=t[6]
local o=e.HeroBattleInfo:GetBuff(302104108)
if o then
local e=o:GetBuffData()
i={e[1]}
n=e[2]
else
local e=e.HeroBattleInfo:GetBuff(302104105)
if e then
local e=e:GetBuffData()
i={e[3]}
n=e[4]
end
end
local r=0
local h=e.HeroBattleInfo:GetBuff(l)
if h then
r=h:GetFloors()
end
local h=i[1]*r
local r=d+h
if n>0 then
e:AddBuffWithMaxFloor(e,l,c,i,1,n)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=t[7]
e.HeroBattleInfo:DispelGranBuff(false,t)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local t=#a
for t=1,t do
local t=a[t]
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104108)
e.AddBuffToEnemy(o,t)
end
t:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,r)
t:SetDisableDefRage(false)
end
end
if o then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,s.id,nil,u:Handler(#a,function(a)
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

