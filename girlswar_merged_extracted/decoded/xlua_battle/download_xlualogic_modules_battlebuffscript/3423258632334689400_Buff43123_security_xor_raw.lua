local a=require("Modules/Battle/BattleUtil")
local t={
}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
a:SetUnderControlTransferSkinState(e.CurrHeroCtrl,e.buffId)
end
function t.OnRemoveSelf(e,t,a)
if e==nil or e.CurrHeroCtrl==nil then
return
end
if e.isExec==true then
return
end
e.isExec=true
e.CurrHeroCtrl:RestoreSkin()
local o=t[1]
local a=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuffAfterRemove(e.CurrHeroCtrl,o,a,t)
end
function t.DoAction(e,e)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i 
