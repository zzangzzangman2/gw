local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(t,e)
local e=e[2]
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if a~=nil then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attacked then
if e[9]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[8]=0
end
local a=e[7]
e[8]=e[8]or 0
if(e[8]>=a)then
return nil
end
t.CurrHeroCtrl:AddFuryWithBuff(e[6],ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t.releaseHeroId),EBattleSrcType.Buff,false)
e[8]=e[8]+1
elseif a.buffTriggerTime==BuffTriggerTime.hpChange or a.buffTriggerTime==BuffTriggerTime.now then
local i=t.CurrHeroCtrl:CurrHPPer()
local a=e[2]
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if i>e[1]*MillionCoe then
if o~=nil then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
else
if o==nil then
local o=e[3]
local e={e[4],e[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked or e==BuffTriggerTime.hpChange or e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

