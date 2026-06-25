local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
if e.CurrBattleTeam==nil then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxFinalAtk)
if(t==nil)then
return nil
end
e:ReduceFury(o.costMp)
local h=a[1]
local i=e.HeroBattleInfo.MaxHP*a[3]*MillionCoe
e:HpHealthWithBuff(i,EBattleSrcType.SkillBig,e.HeroId,0)
local i=a[4]
local n=a[5]
local s={a[6],a[7]}
e:AddBuff(e,i,n,s)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,h)
if t and t.HeroBattleInfo and t.HeroBattleInfo.CurrHP>0 then
local a=math.min(a[8],t.HeroBattleInfo.CurrFury)
if(a>0)then
t:ReduceFuryWithSkill(a,e,EBattleSrcType.SkillBig,true)
end
end
return nil
end
return s 
