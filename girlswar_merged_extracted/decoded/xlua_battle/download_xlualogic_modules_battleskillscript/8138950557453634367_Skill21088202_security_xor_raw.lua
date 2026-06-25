local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,o,t,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local n=302108820
local i=e.HeroBattleInfo:GetBuff(n)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(i,a)
end
local h=t[1]
local i=e.HeroBattleInfo:GetMaxHP()*t[3]*MillionCoe
s:HpHealthWithSmallSkillAndParam(e,o.skilltype,i)
e:AddFuryWithSkill(t[4])
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if#i>1 then
local i=t[5]
local o=t[6]
local a=e.HeroBattleInfo.MaxHP
local t=math.floor(a*t[7]*MillionCoe)
local t={t}
e:AddBuff(e,i,o,t)
end
local i=302108815
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.CheckAddEnergy(n,t[8],t[9])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
