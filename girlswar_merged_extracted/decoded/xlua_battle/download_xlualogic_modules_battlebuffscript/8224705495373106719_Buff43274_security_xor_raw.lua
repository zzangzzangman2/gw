local n=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[5],t[6])
local o=43276
local a=n:GetHeroBuffFloor(e.CurrHeroCtrl,o)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
local i=43278
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddBuffBrokenCherry(o,a)
e.AddFuryBConsumeFallingCherry(o,a)
end
if a>0 then
local a=s:GetFinalBlood(e.CurrHeroCtrl)
local o=e.CurrHeroCtrl.HeroBattleInfo.SepsisHp
local a=math.floor(o*a*t[7]*MillionCoe)
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(o*t[8]*MillionCoe)
a=math.min(a,t)
n:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,a,true,true)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

