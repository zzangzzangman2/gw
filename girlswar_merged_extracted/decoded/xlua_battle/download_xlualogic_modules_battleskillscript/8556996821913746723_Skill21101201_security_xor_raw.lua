local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=e[3]
local n=302110113
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.DoActionSmallSkill(o,a)
end
local r=e[1]
local h=e[4]
local o=e[5]
local n=0
a:CheckAddBuff(i,t,h,o,n)
local o=e[6]
local i=e[7]
local e={e[8],e[9]}
t:AddBuff(t,o,i,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,r)
t:FuryHealth(FuryHealthType.Attack)
end
return d 
