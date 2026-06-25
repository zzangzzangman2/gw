local r=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,h,i,t)
local a=e:JudgeSkillPreView(h)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local o=nil
if i then
o=i.triggerSkillAtkType
end
local i=a[1]
local s=303107215
local n=e.HeroBattleInfo:GetBuff(s)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
i=e.DoBeansActionSmallSkill(n,t,i)
end
local s=a[3]
local n=a[4]
local d=a[5]
t:CheckAddBuff(s,e,n,d)
local n=303107205
local s=e.HeroBattleInfo:GetBuff(n)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddEnergyByPercent(s,a[6])
end
local s=a[7]
e:AddFuryWithSkill(a[8])
local n=t.HeroBattleInfo:GetCurrFury()
if n>a[9]then
local a=math.floor(n*a[10]*MillionCoe)
ModulesInit.ProcedureNormalBattle.StealFury(e,t,a,EBattleSrcType.SkillSmall,true)
end
local n=303107211
local a=e.HeroBattleInfo:GetBuff(n)
if(a)then
local t=a:GetBuffData()
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionForSkill(a,t)
end
local a=303107214
local n=e.HeroBattleInfo:GetBuff(a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local a=i
if t.HeroBattleInfo.CurrSepsisHp>0 then
a=a+s
end
local i=nil
if o~=nil then
i=false
t:SetDisableDefRage(true)
end
local i={
triggerSkillAtkType=o,
openAddFury=i,
}
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,h,a,0,0,i)
if o~=nil then
t:SetDisableDefRage(false)
end
local a=a[3]
local o=a.reduceHpValue
if n then
local a=n:GetBuffData()
local a=a[1]
local a=math.floor(o*a*MillionCoe)
r:AddSepsisHp(e,t,a)
end
e:FuryHealth(FuryHealthType.Attack)
end
return d 
