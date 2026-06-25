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
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local a=t[1]
local i=t[2]
local t={t[3],t[4],t[5],t[6]}
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,t)
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
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

