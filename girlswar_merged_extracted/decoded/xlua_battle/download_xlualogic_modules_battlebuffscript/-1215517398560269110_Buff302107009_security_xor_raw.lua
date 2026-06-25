local o=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=0
local i=o:GetCurEnemyList(e.CurrHeroCtrl)
local i=i[1]
if i then
local e=i:CurrHPPer()
a=e*OneMillion
end
local n=o:GetYByXInAntilinea(a,t[4],t[5],t[8],OneMillion)
local i=t[1]
local s=t[2]
local n={t[3],n}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,s,n)
local t=o:GetYByXInAntilinea(a,t[6],t[7],t[8],OneMillion)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=a*t*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

