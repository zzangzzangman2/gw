local d=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,o)
local a=t:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,e)
t:ReduceFury(o.costMp)
local n=a[1]
local h=a[3]
local r=a[4]
local s=a[5]
e:CheckAddBuff(h,t,r,s,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,n)
local a=n*a[6]*MillionCoe
if(i~=nil)then
for i,e in ipairs(i)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,a)
end
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,1029304,{e},d:Handler(e.HeroId,function(e)
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo and e.HeroBattleInfo.CurrHP>0 then
return true
end
return false
end))
end
return s 
