local o=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
end
function e.DoAction(e,n,t,s,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a[1]
if o:IsCtlBuff(a)then
local a=i.buffCopy
local o=o:AddBuffWithBuffCopy(t,e.CurrHeroCtrl,a,{buffAddType=EBuffAddType.FightBack,buffTriggerAddType=EBuffAddType.FightBack})
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
if o and t.HeroBattleInfo then
t.HeroBattleInfo:PlayBattleEffectWithBuffId(a.buffId)
end
end
e.CurrHeroCtrl:AddFuryWithBuff(n[1])
return{
ret=true,
remove=false
}
end
return{
ret=false
}
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuffCheckCtrl)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return s

