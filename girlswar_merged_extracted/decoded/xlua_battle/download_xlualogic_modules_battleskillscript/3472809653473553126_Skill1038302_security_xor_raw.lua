local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
if t.CurrBattleTeam==nil then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMaxFinalAtk)
if(a==nil)then
return nil
end
t:ReduceFury(o.costMp)
local s=e[1]
local i=t.HeroBattleInfo.MaxHP*e[3]*MillionCoe
t:HpHealthWithBuff(i,EBattleSrcType.SkillBig,t.HeroId,0)
local h=e[4]
local n=e[5]
local i={e[6],e[7]}
t:AddBuff(t,h,n,i)
local n=e[9]
local i=e[10]
local h={e[11],e[12],e[13],e[14]}
a:AddBuff(t,n,i,h)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
if a and a.HeroBattleInfo and a.HeroBattleInfo.CurrHP>0 then
local e=math.min(e[8],a.HeroBattleInfo.CurrFury)
if(e>0)then
a:ReduceFuryWithSkill(e,t,EBattleSrcType.SkillBig,true)
end
end
return nil
end
return r 
