local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o and e[10]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
local a=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
if a>0 then
if o.oldHP/a>=e[1]*MillionCoe and o.currHP/a<e[1]*MillionCoe then
e[10]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local a=t.CurrHeroCtrl:GetFinalAtk()
local a=math.floor(a*e[2]*MillionCoe)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
local i=e[3]
local n=e[4]
local s={e[5],e[6],e[7],e[8]}
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
local a=0
local e=e[9]
if o then
a=o:GetFloors()
end
if a<e then
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,n,s)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

