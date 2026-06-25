local e={
}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=t[1]
local h=t[3]
local n=t[4]
local o={t[5],t[6]}
e:AddBuff(e,h,n,o)
local n=t[7]*MillionCoe
local o=(1-e:CurrHPPer())
local o=math.floor(e.HeroBattleInfo.MaxHP*o*n)
if o>0 then
e:HpHealthImmediately(o,EBattleSrcType.SkillSmall,e.HeroId,0)
end
e:AddFuryWithSkill(t[8])
local o=t[9]
local n=t[10]
local t={t[11]}
e:AddBuff(e,o,n,t)
local t=#a
for t=1,t do
local t=a[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,s)
end
e:FuryHealth(FuryHealthType.Attack)
end
return s 
