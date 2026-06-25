local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local i=t[11]
local a=t[10]
if i>=a then
return
end
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
t[11]=t[11]+1
if t[11]>=a then
e.isExec=true
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local i=t[1]
local o=t[2]
local a={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local o=t[5]
local a=t[6]
local i={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,i)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(a*t[9]*MillionCoe)
e.CurrHeroCtrl:HpHealthSimpleImmediately(e.CurrHeroCtrl,t,EBattleSrcType.DeathImmune,e.buffId,true)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

