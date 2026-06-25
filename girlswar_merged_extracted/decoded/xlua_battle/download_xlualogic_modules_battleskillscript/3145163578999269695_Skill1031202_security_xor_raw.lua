local d=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(a,i,e,n)
local t=a:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMinHpPercent)
if(e==nil)then
return nil
end
local o=t[1]
local r=t[3]
local s=t[4]
local h=t[5]
e:CheckAddBuff(r,a,s,h)
if e:CurrHPPer()<t[6]*MillionCoe then
o=o+t[7]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,o)
if n==nil or n.isFristAction==true then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,1031202,{e},d:Handler(e.HeroId,function(e)
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e==nil or e.HeroBattleInfo==nil or e.HeroBattleInfo.CurrHP<=0 then
return true
end
return false
end),EBattleSkillType.SkillSmall)
end
end
return l 
