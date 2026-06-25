local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.isExec==false then
if t.CurrHeroCtrl:CurrHPPer()<e[1]*MillionCoe then
local i=e[2]
local o=e[3]
local a={e[4],e[5],e[6],0}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local o=e[7]
local a=e[8]
local e={e[9],e[10],e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
t.isExec=true
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
return n

