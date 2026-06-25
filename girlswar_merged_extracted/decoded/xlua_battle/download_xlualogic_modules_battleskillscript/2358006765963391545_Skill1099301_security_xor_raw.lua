local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
local r=n.battleStationColumn
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
e:ReduceFury(o.costMp)
local s=a[1]
local i=false
local h=e.HeroBattleInfo:GetBuff(30109906)
if h==nil then
local o=a[4]
local t=a[5]
e:AddBuff(e,o,t,{1})
i=true
end
if i==true then
e:AddMustCritValueInCurAttack()
e.IgnoreBlock=true
e.IgnoreInjureRes=true
end
local i=#t
for i=1,i do
local t=t[i]
local i=s
if r==t.battleStationColumn then
i=i+a[3]
end
local a=nil
if n.HeroId~=t.HeroId then
a={
openAddFury=false
}
t:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,i,0,0,a)
if n.HeroId~=t.HeroId then
t:SetDisableDefRage(false)
end
end
e:RemoveMustCritValueInCurAttack()
e.IgnoreBlock=false
e.IgnoreInjureRes=false
return nil
end
return r

