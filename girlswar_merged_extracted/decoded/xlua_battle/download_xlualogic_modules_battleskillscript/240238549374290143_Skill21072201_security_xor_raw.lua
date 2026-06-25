local h=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,s,i,t)
local a=e:JudgeSkillPreView(s)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local o=nil
if i then
o=i.triggerSkillAtkType
end
local r=a[1]
local n=a[3]
local i=a[4]
local d=a[5]
t:CheckAddBuff(n,e,i,d)
local n=302107205
local i=e.HeroBattleInfo:GetBuff(n)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddEnergyByPercent(i,a[6])
end
local n=a[7]
e:AddFuryWithSkill(a[8])
local i=t.HeroBattleInfo:GetCurrFury()
if i>a[9]then
local a=math.floor(i*a[10]*MillionCoe)
ModulesInit.ProcedureNormalBattle.StealFury(e,t,a,EBattleSrcType.SkillSmall,true)
end
local i=302107211
local a=e.HeroBattleInfo:GetBuff(i)
if(a)then
local t=a:GetBuffData()
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionForSkill(a,t)
end
local a=302107214
local i=e.HeroBattleInfo:GetBuff(a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local a=r
if t.HeroBattleInfo.CurrSepsisHp>0 then
a=a+n
end
local n=nil
if o~=nil then
n=false
t:SetDisableDefRage(true)
end
local n={
triggerSkillAtkType=o,
openAddFury=n,
}
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,a,0,0,n)
if o~=nil then
t:SetDisableDefRage(false)
end
local a=a[3]
local o=a.reduceHpValue
if i then
local a=i:GetBuffData()
local a=a[1]
local a=math.floor(o*a*MillionCoe)
h:AddSepsisHp(e,t,a)
end
e:FuryHealth(FuryHealthType.Attack)
end
return d 
