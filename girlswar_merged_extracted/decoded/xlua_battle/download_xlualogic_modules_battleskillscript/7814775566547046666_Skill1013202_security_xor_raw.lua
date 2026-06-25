local e={}
local i=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local n=t[3]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
local i=a[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(a~=nil and#a>0)then
local o=a[1]
local a=i*n*MillionCoe
if(o:CurrHPPer()<t[4]*MillionCoe)then
a=a*(1+t[5]*MillionCoe)
end
o:HpHealthWithNormalSkill(e,a,false,EBattleSrcType.SkillSmall)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i

