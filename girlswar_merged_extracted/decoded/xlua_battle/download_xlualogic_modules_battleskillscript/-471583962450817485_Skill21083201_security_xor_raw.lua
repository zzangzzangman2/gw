local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,o,i,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eState,1,nil,302108309)
local a=a[1]
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local s=o.atkType
if i then
s=i.triggerSkillAtkType
end
local n=302108312
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(i,a)
end
if s==ETriggerSkillAtkType.PursuitAttack then
local t=302108317
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoActionSmallSkill(e,a)
end
end
local h=t[1]
local i=t[3]
local n=t[4]
local s={t[5],t[6]}
e:AddBuff(e,i,n,s)
local n=t[7]
local i=t[8]
local t={t[9],t[10]}
e:AddBuff(e,n,i,t)
local t=0
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h,0,t)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
