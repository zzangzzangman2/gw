local e={
}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local h=t[3]
local s=t[4]
local n={t[5]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
a:AddBuff(e,h,s,n)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*t[5]*MillionCoe,false,EBattleSrcType.SkillBig)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
