local s=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionBigSkill(t,o)
local e=t:GetBuffData()
local a=t.CurrHeroCtrl:GetFinalAtk()
local a=math.floor(a*e[5]*MillionCoe)
local i=e[1]
local n=e[2]
local a={e[3],e[4],a}
local e=table.lightCopyList(o)
local e=s:GetMinHpPercentHeroArr(e,1)
local e=e[1]
if e then
e:AddBuff(t.CurrHeroCtrl,i,n,a)
end
end
return h

