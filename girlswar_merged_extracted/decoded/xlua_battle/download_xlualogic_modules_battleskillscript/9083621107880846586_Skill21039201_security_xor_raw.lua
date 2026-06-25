local h=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local o=a[1]
if t.HeroBattleInfo:HasGranOrUnGran(true)then
o=o+a[5]
end
local s=302103906
local n=e.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionSmallSkill(n,t)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,o)
local t=t[3]
local o=t.originHurtValue
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLow,a[3],HeroAttrId.hpPer)
if(t~=nil and#t>0)then
for n=1,#t do
local t=t[n]
local n=ModulesInit.BattleBuffMgr.GetBuffScript(302103903)
n.CheckAddBuffAction(e,t)
h:HpHealthWithSmallSkillAndParam(e,i.skilltype,o*a[4]*MillionCoe,t)
end
end
e:FuryHealth(FuryHealthType.Attack)
end
return r 
