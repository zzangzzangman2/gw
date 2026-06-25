local o=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl:AddMustSmallSkill(e.buffId)
e.CurrHeroCtrl:SetCurrRoundCanTriggerSmallSkill()
end
function a.OnRemoveSelf(e,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.CurrHeroCtrl:RefreshMustSmallSkill()
if#t>=15 then
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[11]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local o=t[12]
local a=t[13]
local t={t[14],t[15]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[6],t[7])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[8],t[9])
if#t>=15 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.reduceHpMaxRate,t[10])
end
elseif a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
if#t>=15 then
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
e.isExcuteInTimeLine=false
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddAttackTask(e,t,a)
local t=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.SmallSkillId
if e>0 then
local n={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if i==nil then
o:AddTriggerAttackTask(t,e,n,{triggerSkillAtkType=a})
end
end
end
return i

