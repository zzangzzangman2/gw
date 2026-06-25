local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,o,n,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eState,1,nil,302108309)
local a=a[1]
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=o.atkType
if n then
i=n.triggerSkillAtkType
end
local n=302108312
local s=e.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(s,a)
end
if i==ETriggerSkillAtkType.PursuitAttack then
local t=302108317
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoActionSmallSkill(e,a)
end
end
local n=t[1]
local i=t[3]
local s=t[4]
local h={t[5],t[6]}
e:AddBuff(e,i,s,h)
local i=t[7]
local h=t[8]
local s={t[9],t[10]}
e:AddBuff(e,i,h,s)
local i=0
i=math.floor(e.HeroBattleInfo.MaxHP*t[11]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n,0,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
