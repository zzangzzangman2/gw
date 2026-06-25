local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
if#e>=4 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
if#e>=5 then
local a=t.releaseHeroId
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a then
a:AddFuryWithSkill(e[5])
if a.HeroBattleInfo then
a.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
if#e>=10 then
local n=e[6]
local s=e[7]
local o=0
local i=a.HeroBattleInfo:GetBuff(n)
if i then
local e=i:GetBuffData()
o=e[2]
end
local o=o+e[9]
o=math.min(o,e[10])
local e={e[8],o}
a:AddBuff(t.CurrHeroCtrl,n,s,e)
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

