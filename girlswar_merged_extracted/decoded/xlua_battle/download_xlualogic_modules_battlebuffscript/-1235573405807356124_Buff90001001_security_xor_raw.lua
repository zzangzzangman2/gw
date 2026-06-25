local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e.isExec==false then
if e.CurrHeroCtrl:CurrHPPer()<t[1]*MillionCoe then
local o=t[2]
local i=t[3]
local a={t[4],t[5],t[6],0}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
local a=t[7]
local t=t[8]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t)
e.isExec=true
return{
duration=3
}
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

