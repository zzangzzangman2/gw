local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=e[1]
local n=e[3]
local s=e[4]
local i={e[5],e[6]}
t:AddBuff(t,n,s,i)
local n=e[7]
local s=e[8]
local i={e[9],e[10]}
t:AddBuff(t,n,s,i)
local n=e[11]
local i=e[12]
local e={e[13],e[14]}
a:AddBuff(t,n,i,e)
local e=302108115
local i=t.HeroBattleInfo:GetBuff(e)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.DoActionSmallSkill(i,a)
end
local e=302108106
local i=t.HeroBattleInfo:GetBuff(e)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
local e=e.GetRealHurtValue(i,a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h,0,e)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
