local e=require("Modules/Battle/BattleUtil")
local i=require("Modules/Battle/Formula")
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
local s=t[1]
local h=t[3]
local r=t[4]
local n={t[5],0}
e:AddBuff(e,h,r,n)
local n=i:CalculateHeroAttackCriticalRate(e)
local n=n.attackCriticalRate
local i=i:CalculateHeroAttackCriticalRate(a)
local i=i.attackCriticalRate
if n>i then
local t={
attrId=t[10],
value=t[11],
}
e:AddAttrValueInCurAttack(t)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,s)
if a.HeroBattleInfo~=nil and a.HeroBattleInfo.CurrHP>0 then
local n=t[6]
local o=t[7]
local i=0
local s=e.HeroBattleInfo:GetBuff(t[9])
if(s)then
i=1
end
local t=math.floor(e:GetFinalAtk()*t[8]*MillionCoe)
local t={t,e.HeroId,i,o}
a:AddBuff(e,n,o,t)
end
return nil
end
return h 
