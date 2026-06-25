local h=require('Modules/BattleBuffScript/BuffPairTools')
local e={}
local r=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
h.OnChainRemove(e.CurrHeroCtrl,e.buffId)
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoAddChain(o,e)
if o==nil or e==nil then
return
end
local i=e[8]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(i)
if t~=nil then
local n={}
n.buffId=e[1]
n.buffRound=e[2]
n.buffValue={e[3],i,o.HeroId}
local a={}
a.buffId=e[4]
a.buffRound=e[5]
a.buffValue={o.HeroId}
local s={}
s.buffId=e[6]
s.buffRound=e[7]
local t=h.GetDefaultHpChainData()
t.assumedamagePercent=e[3]
t.reduceDamagePercent=0
t.minHpPercent=0
t.defHeroId=i
t.defBuffId=a.buffId
s.buffValue={t}
h.AddBuffPair(o,n,s,a,i)
end
end
return r

