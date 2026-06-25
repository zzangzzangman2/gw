local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
if e.CurrBattleTeam==nil then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxFinalAtk)
if(a==nil)then
return nil
end
e:ReduceFury(i.costMp)
local h=t[1]
local o=e.HeroBattleInfo.MaxHP*t[3]*MillionCoe
e:HpHealthWithBuff(o,EBattleSrcType.SkillBig,e.HeroId,0)
e.HeroBattleInfo:DispelAllGranBuff(false)
local o=t[4]
local n=t[5]
local s={t[6],t[7]}
e:AddBuff(e,o,n,s)
local s=t[9]
local o=t[10]
local n={t[11],t[12],t[13],t[14]}
a:AddBuff(e,s,o,n)
local n=e.HeroBattleInfo:GetBuff(30103802)
local o=0
if n~=nil then
local i=n:GetFloors()
local a=e.HeroBattleInfo.MaxHP
o=a*t[15]*MillionCoe*i
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,h,0,o)
if a and a.HeroBattleInfo and a.HeroBattleInfo.CurrHP>0 then
local t=math.min(t[8],a.HeroBattleInfo.CurrFury)
if(t>0)then
a:ReduceFuryWithSkill(t,e,EBattleSrcType.SkillBig,true)
end
end
return nil
end
return h 
