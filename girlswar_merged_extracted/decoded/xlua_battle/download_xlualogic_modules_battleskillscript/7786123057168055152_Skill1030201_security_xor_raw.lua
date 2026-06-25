local e={
}
local h=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=t[1]
local n=t[3]
local s=t[4]
local o={t[5],t[6]}
e:AddBuff(e,n,s,o)
local o=t[7]*MillionCoe
local n=(1-e:CurrHPPer())
local o=math.floor(e.HeroBattleInfo.MaxHP*n*o)
if o>0 then
e:HpHealthImmediately(o,EBattleSrcType.SkillSmall,e.HeroId,0)
end
e:AddFuryWithSkill(t[8])
local t=#a
for t=1,t do
local t=a[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,h)
end
e:FuryHealth(FuryHealthType.Attack)
end
return h 
