local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=t[1]
local a=t[2]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t,1,{isForce=true,triggerSkillAtkType=ETriggerSkillAtkType.FightBack})
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=t[1]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local o=t[3]
local i=t[4]
local t=t[5]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,t,1,{isForce=true,triggerSkillAtkType=ETriggerSkillAtkType.FightBack})
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

