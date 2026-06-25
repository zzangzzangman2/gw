local e={
}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=i.atkType
if skillData then
o=skillData.triggerSkillAtkType
end
local s=302108413
local n=t.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionSmallSkill(n,a)
end
local r=e[1]
local h=e[3]
local n=e[4]
local s={e[5],e[6]}
t:AddBuff(t,h,n,s)
local s=e[7]
local h=e[8]
local n={e[9],e[10]}
t:AddBuff(t,s,h,n)
if e[13]>0 then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[13],EBattleSrcType.SkillSmall)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n
if o==ETriggerSkillAtkType.FightBack then
n={
openAddFury=false,
triggerSkillAtkType=o,
}
a:SetDisableDefRage(true)
end
local i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r,0,0,n)
if o==ETriggerSkillAtkType.FightBack then
a:SetDisableDefRage(false)
end
local o=i[3]
local a=e[11]
local o=o.criticalOrBlock
if o==1 then
a=e[12]
end
local o=302108408
local e=t.HeroBattleInfo:GetBuff(o)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.GainMirror(e,a)
end
t:FuryHealth(FuryHealthType.Attack)
end
return h 
