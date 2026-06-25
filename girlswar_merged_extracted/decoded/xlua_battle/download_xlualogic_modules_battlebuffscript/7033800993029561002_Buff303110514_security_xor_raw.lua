local i=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[1]*MillionCoe)
end
function a.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(e[1]*MillionCoe)
end
function a.DoAction(e,t,o,o,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=t[2]
local a=t[3]
local t={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
elseif a.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
local a=n.triggerSkillAtkType
if i:IsDependAtkType(a)==false then
if(t[6]>=RandomMgr:GetBattleRandom())then
local a=RandomMgr:GetBattleRandomWithRange(1,3)
if a==1 then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local o=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local a=o-a
if a>0 then
local t=math.floor(a*t[7]*MillionCoe)
e.CurrHeroCtrl:HpHealthSimpleImmediately(e.CurrHeroCtrl,t,EBattleSrcType.Buff)
end
elseif a==2 then
e.CurrHeroCtrl:AddFuryWithBuff(t[8])
elseif a==3 then
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,t[9])
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

