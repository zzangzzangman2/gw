local o=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.CheckCondition(e)==false then
return nil
end
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[2]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
local o=t[4]
local a=t[5]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
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
function t.CheckCondition(e,t)
local t=e:GetBuffData()
local a=t[4]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local e=e:GetFloors()
if e+1>=t[3]then
return false
end
end
return true
end
return a

