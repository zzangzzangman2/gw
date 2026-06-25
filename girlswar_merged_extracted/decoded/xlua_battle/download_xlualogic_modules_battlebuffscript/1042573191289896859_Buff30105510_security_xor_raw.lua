local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.attack then
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if a then
a:AddFuryWithBuff(t[2])
local o=t[3]
local i=t[4]
local n={t[5],t[6]}
local t=t[7]
a:AddBuffWithMaxFloor(e.CurrHeroCtrl,o,i,n,1,t)
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=math.floor(a*t[1]*MillionCoe)
if t>0 then
local a={
ignoreImmuneDamage=true
}
e.CurrHeroCtrl:RealHurtWithBuff(t,e,nil,nil,nil,nil,a)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd or e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

