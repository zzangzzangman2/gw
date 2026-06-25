local i=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionBigSkill(e,t)
local a=e:GetBuffData()
local o=303111401
local t=0
local i,o=i:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.enemyAll,o,nil,true)
for e=1,#o do
local e=o[e].HeroBattleInfo:GetBuff(303111401)
if e then
local e=e:GetBuffData()
t=t+e[7]
end
end
local t=math.floor(t*a[1]*MillionCoe)
local o=a[2]*MillionCoe
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*o
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(a[3])
return t
end
return n

