local e={
}
local n=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o=t[1]
if a.HeroBattleInfo:HasGranOrUnGran(true)then
o=o+t[5]
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
local a=a[3]
local i=a.originHurtValue
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,t[3],HeroAttrId.hpPer)
if(a~=nil and#a>0)then
for o=1,#a do
local a=a[o]
local o=ModulesInit.BattleBuffMgr.GetBuffScript(30103903)
o.CheckAddBuffAction(e,a)
a:HpHealthWithNormalSkill(e,i*t[4]*MillionCoe,false,EBattleSrcType.SkillSmall)
end
end
e:FuryHealth(FuryHealthType.Attack)
end
return n 
