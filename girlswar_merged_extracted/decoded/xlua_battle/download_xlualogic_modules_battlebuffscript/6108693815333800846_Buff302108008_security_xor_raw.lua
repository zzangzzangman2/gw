local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[12],t[13])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[14],t[15])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for t=1,#o do
local t=o[t]
t:AddFuryWithBuff(e[1])
end
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[2]==1 then
local a=a.HeroBattleInfo.MaxHP
local e=math.floor(a*e[3]*MillionCoe)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
local o=e[4]
local n=e[5]
local i={e[6],e[7]}
a:AddBuff(t.CurrHeroCtrl,o,n,i)
local o=e[8]
local i=e[9]
local e={e[10],e[11]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
return s

