local e=require("Modules/Battle/BattleUtil")
local e=require("Modules/Battle/Formula")
local e={
}
local s=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local i=303110609
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(o,t)
end
local o=303110623
local i=e.HeroBattleInfo:GetBuff(o)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoBeansActionSmallSkill(i)
end
local i=a[1]
local o=a[3]
local s=a[4]
local a=a[5]
t:CheckAddBuff(o,e,s,a,0)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,i,0,0)
return nil
end
return s 
