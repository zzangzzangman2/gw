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
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
local a=e.CurrHeroCtrl:GetFinalAtk()
local a=math.floor(a*t[1]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
local o=t[2]
local i=t[3]
local a={t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
local i=t[6]
local o=t[7]
local a={t[8],t[9]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
local a=t[11]
local o=t[12]
local i={t[13],t[14]}
local t=t[10]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i,t)
e.isExec=true
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

