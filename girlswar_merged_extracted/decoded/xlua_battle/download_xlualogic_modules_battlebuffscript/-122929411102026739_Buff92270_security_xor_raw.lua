local o=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(t,e)
local o=e[3]
local a=e[1]
local t=0
for o=1,o do
if(a>=RandomMgr:GetBattleRandom())then
t=t+1
end
end
e[5]=t
e[6]=0
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,t,i,i,i,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.CheckCondition(e)==false then
return
end
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
t[6]=t[6]+1
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
local t=t[2]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
e.isExcuteInTimeLine=false
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(e)
local e=e:GetBuffData()
if e[6]>=e[5]then
return false
end
return true
end
function t.ShowTreasure(e)
local t=e:GetBuffData()
local t=t[4]
e.CurrHeroCtrl:ShowTreasureById(t)
end
return a

