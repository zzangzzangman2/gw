local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.CurrHeroCtrl:IsAttackInCurSmallRound()then
return false
end
if t.CurrHeroCtrl:CheckHeroCanDoAction()==false then
return false
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.selfColumn)
if(a)then
for o=1,#a do
local a=a[o]
if a.HeroId==t.CurrHeroCtrl.HeroId then
local n=e[1]
local o=e[2]
local i={e[3]+e[9],0}
a:AddBuffAfterRemove(t.CurrHeroCtrl,n,o,i)
local n=e[4]
local i=e[5]
local o=e[6]+math.floor(e[6]*e[10]*MillionCoe)
local e={e[7],o,e[8],o}
a:AddBuff(t.CurrHeroCtrl,n,i,e)
else
local o=e[1]
local i=e[2]
local n={e[3],0}
a:AddBuff(t.CurrHeroCtrl,o,i,n)
local o=e[4]
local i=e[5]
local e={e[7],e[6],e[8],e[6]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
end
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

