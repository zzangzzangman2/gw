local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=3 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
end
if#t>=5 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
end
if#t>=7 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[6],t[7])
end
e.isExec=true
return{
ret=true
}
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

