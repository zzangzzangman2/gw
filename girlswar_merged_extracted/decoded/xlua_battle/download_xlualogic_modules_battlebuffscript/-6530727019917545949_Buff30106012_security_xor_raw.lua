local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=false
t[4]=t[4]or 0
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound~=t[5]then
t[4]=0
t[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
if t[4]<t[3]then
if e.CurrHeroCtrl.battleStationRow==2 then
a=true
else
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if#e<=1 then
a=true
end
end
end
if a then
t[4]=t[4]+1
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
local a=e.CurrHeroCtrl:GetFinalAtk()
local t=math.floor(a*t[2]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

