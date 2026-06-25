local o=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,s,h,n,t,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.afterAttacked then
local i=e.CurrHeroCtrl.HeroId
if i==h.HeroId then
elseif i==n.HeroId then
local n=e.CurrHeroCtrl.HeroId
local i=e.CurrHeroCtrl.BigSkillId
local e=a.GetSkillData(e,s)
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,n)
if a==nil then
o:AddTriggerAttackTask(n,i,e,t)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.addBuff then
if t.buffHeroId==e.CurrHeroCtrl.HeroId then
local t=t.addBuffId
if(o:IsCtlBuff(t))then
a.RemoveDeBuff(e,s)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(a,e)
if e[6]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[6]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[5]=0
end
local t=e[2]
if(e[5]>=t)then
return false
end
local t=302108211
local e=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local a=e:GetBuffData()
local e=t.GetCurState(e,a)
if e~=t.ELiubeiState.King then
return false
end
end
return true
end
function t.GetSkillData(e,t)
local e={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
ignoreControl=true,
realHurt=0,
openAddFury=false,
}
return e
end
function t.HandleOnDoAction(e,t)
if a.CheckCondition(e,t)==false then
return false
end
local i=302108211
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if e.CurrHeroCtrl.HeroBattleInfo:HasControlBuff()then
local e=a.RemoveDeBuff(e,t)
if e==false then
return false
end
end
local n=a.GetSkillData(e,t)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local i=a.GetKingValue(o)
local i=math.floor(i*t[1]*MillionCoe)
local e=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
n.realHurt=math.min(i,math.floor(e*t[3]*MillionCoe))
a.ReduceKingValue(o,i,"kv_r_fightback_realhurt")
end
t[5]=t[5]+1
local a=t[2]
if(t[5]>=a)then
local t=302108226
local o=1
local a={1}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,t,o,a)
e.CurrHeroCtrl.isTriggerSkillEndBuff=true
end
return true,n
end
function t.RemoveDeBuff(a,o)
local t=302108211
local e=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
a.CurrHeroCtrl.HeroBattleInfo:RemoveAllGranBuff(false)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local a=t.RemoveKingPercent(e,o[3],"kv_r_fightback_dipel")
if a==false then
t.EnterBattleStateFromKing(e)
return false
end
end
return true
end
return a

