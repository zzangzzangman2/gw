local s=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,o,t,t)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local i=303107918
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(n,t)
end
local n=303107927
local i=e.HeroBattleInfo:GetBuff(n)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionWithKnightSun(i,t)
end
local n=a[1]
local i=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or a[4]==1 then
i=math.floor(t.HeroBattleInfo.MaxHP*a[3]*MillionCoe)
end
local h=e.HeroBattleInfo.MaxHP*a[5]*MillionCoe
s:HpHealthWithSmallSkillAndParam(e,o.skilltype,h)
e:AddFuryWithSkill(a[6])
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,n,0,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r 
