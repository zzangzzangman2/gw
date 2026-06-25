local e=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local e={
}
local h=e
function e.DoAction(e,o,t,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=303111208
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(i,a,o.atkType)
end
local n=t[1]
local i=s:GetInjureResData(a)
local i=math.floor(i.defFinalInjureResRate*OneMillion/t[3])*t[4]
if i>0 then
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
e:AddBuff(e,o,a,t,i)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,n)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
