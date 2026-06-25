local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local n=t[3]
local s=302110113
local o=e.HeroBattleInfo:GetBuff(s)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
n=e.DoActionSmallSkill(o,a)
end
local r=t[1]
local o=t[4]
local s=t[5]
local h=0
a:CheckAddBuff(n,e,o,s,h)
local o=t[6]
local n=t[7]
local t={t[8],t[9]}
e:AddBuff(e,o,n,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,r)
e:FuryHealth(FuryHealthType.Attack)
end
return d 
