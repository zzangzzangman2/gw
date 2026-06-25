local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t[2]
local a=t[4]
if e.CurrHeroCtrl:IsRealLastRowHero()then
o=math.floor(t[2]*t[5]*MillionCoe)
a=math.floor(t[4]*t[5]*MillionCoe)
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],o)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],a)
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionSmallSkill(t)
local e=t:GetBuffData()
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>=e[6]
and ModulesInit.ProcedureNormalBattle.CurrBattleBigRound<=e[7]then
local e=e[8]
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e)
end
end
return i

