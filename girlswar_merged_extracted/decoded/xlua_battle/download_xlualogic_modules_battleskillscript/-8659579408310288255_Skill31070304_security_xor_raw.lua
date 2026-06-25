local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o,a,e)
local a=t:JudgeSkillPreView(o)
local n=e.damageHpRate
local i=e.sepsisHPRate
local a=e.defHeroIds
local e=nil
if a then
local t=a[1]
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
end
if(e==nil)then
return nil
end
local a=e.HeroBattleInfo:GetMaxHP()-e.HeroBattleInfo:GetCurrHP()
local n=math.floor(a*n*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local a={
openAddFury=false,
}
e:SetDisableDefRage(true)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,0,0,n,a)
e:SetDisableDefRage(false)
local a=a[3]
local a=a.reduceHpValue
if i>0 then
local a=math.floor(a*i*MillionCoe)
s:AddSepsisHp(t,e,a)
end
return nil
end
return h 
