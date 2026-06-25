local i=require("Modules/Battle/BattleUtil")
local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,n,n,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attack then
if e[10]==0 then
e[10]=1
local a=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroTable()
local a=RandomTableWithSeed(a,1)
local a=a[1]
if a then
ModulesInit.ProcedureNormalBattle.StealFury(t.CurrHeroCtrl,a,e[1],EBattleSrcType.Buff,true)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.addBuff then
if o.buffHeroId==t.CurrHeroCtrl.HeroId then
local t=o.addBuffId
if i:IsCtlBuff(t)then
e[9]=1
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
e[10]=0
if e[9]==1 then
e[9]=0
local a={
attrId=e[2],
value=e[3]*e[8],
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(a)
local a={
attrId=e[4],
value=e[5]*e[8],
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(a)
local e={
attrId=e[6],
value=e[7]*e[8],
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(e)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.addBuff
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

