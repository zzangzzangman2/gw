local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t[1]
if a.buffTriggerTime==BuffTriggerTime.now then
o.AddBuff30105109(e,t,t[5])
if e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(i)
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.appearBattleBigRound~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
o.AddBuff30105109(e,t,t[5])
end
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
if e.CurrHeroCtrl:CurrHPPer()<t[7]*MillionCoe then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
local s=false
if a then
local n=a:GetFloors()
local o=t[8]
if n>=o then
s=true
a:ReduceFloors(o)
if n<=o then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
e.CurrHeroCtrl:AddFuryWithBuff(t[9])
end
end
if s==false then
o.AddBuff30105109(e,t,t[10])
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuff30105109(t,e,a)
local o=e[1]
local i=e[2]
local n={e[3],e[4]}
local e=e[6]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,o,i,n,a,e)
end
return o

