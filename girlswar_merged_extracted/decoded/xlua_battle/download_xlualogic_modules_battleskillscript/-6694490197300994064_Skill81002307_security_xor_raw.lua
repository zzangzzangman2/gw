local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(a,o)
local e=a:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMinHpPercentWithCount)
local t=t[1]
if(t==nil)then
return nil
end
local s=e[1]
local i=e[6]
if e[7]==t.profession then
i=e[8]
end
local h=e[3]
local n=e[4]
local i={e[5],i}
t:AddBuff(a,h,n,i)
if e[9]==t.profession then
local i=e[10]
local o=e[11]
local e={e[12],e[13]}
t:AddBuff(a,i,o,e)
end
if e[14]==t.profession then
local o=e[15]
local i=e[16]
local e=e[17]
t:CheckAddBuff(o,a,i,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,o,s)
if t and t.HeroBattleInfo and t.HeroBattleInfo.CurrHP>0 then
local e=math.min(e[18],t.HeroBattleInfo.CurrFury)
if(e>0)then
t:ReduceFuryWithSkill(e,a,EBattleSrcType.PetFightSkill,true)
end
end
return nil
end
return h 
