local t=require("Modules/Battle/BattleUtil")
local e={
}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,a)
if e==nil or e.CurrHeroCtrl==nil then
return
end
t:SetUnderControlTransferSkinState(e.CurrHeroCtrl,e.buffId)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:RestoreSkin()
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a 
