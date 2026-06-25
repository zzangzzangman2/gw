local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=0
local n=303111311
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.DoActionSmallSkill(s,{a})
end
local h=e[1]
local r=e[3]
local s=e[4]
local n={e[5],e[6]}
a:AddBuff(t,r,s,n)
local n=e[7]
local s=e[8]
local e={e[9],e[10]}
a:AddBuff(t,n,s,e)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h,0,i)
local i=303111310
local e=t.HeroBattleInfo:GetBuff(i)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(i)
t.AddAttackTask(e,a,o.atkType)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
