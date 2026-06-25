local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,n,h)
local i=t:JudgeSkillPreView(n)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercentWithCount)
local e=e[1]
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local r=0
local s=303111802
local a=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
for e=1,#o do
local e=o[e]
local e=e.HeroBattleInfo:GetBuff(s)
if e then
local e=e:GetFloors()
a=a+e
end
end
local o=t:GetFinalAtk()
local a=math.min(a*i[3],i[4])*o*MillionCoe
a=math.ceil(a)
e:AddForbidEvade(31118102)
e:AddForbidImmuneDamage(31118102)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,r,0,a)
e:RemoveForbidEvade(31118102)
e:RemoveForbidImmuneDamage(31118102)
if h.triggerCount>0 then
local a=303111801
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddAttackTask(e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return nil
end
return h 
