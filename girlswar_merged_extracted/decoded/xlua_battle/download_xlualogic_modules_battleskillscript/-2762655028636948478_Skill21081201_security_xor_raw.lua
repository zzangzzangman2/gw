local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local s=t[1]
local h=t[3]
local o=t[4]
local n={t[5],t[6]}
e:AddBuff(e,h,o,n)
local n=t[7]
local o=t[8]
local t={t[9],t[10]}
e:AddBuff(e,n,o,t)
local o=302108115
local t=e.HeroBattleInfo:GetBuff(o)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(t,a)
end
local t=302108106
local o=e.HeroBattleInfo:GetBuff(t)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local t=t.GetRealHurtValue(o,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,s,0,t)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
