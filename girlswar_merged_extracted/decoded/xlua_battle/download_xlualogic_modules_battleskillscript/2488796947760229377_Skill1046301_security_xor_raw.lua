local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=t[1]
local n=t[3]
local s=t[4]
local i={t[5],0}
e:AddBuff(e,n,s,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h)
if a.HeroBattleInfo~=nil and a.HeroBattleInfo.CurrHP>0 then
local s=t[6]
local i=t[7]
local o=0
local n=e.HeroBattleInfo:GetBuff(t[9])
if(n)then
o=1
end
local t=math.floor(e:GetFinalAtk()*t[8]*MillionCoe)
local t={t,e.HeroId,o,i}
a:AddBuff(e,s,i,t)
end
return nil
end
return h 
