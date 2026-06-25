local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.CheckAddBuffAction(t,a)
if t==nil or t.HeroBattleInfo==nil or t.HeroBattleInfo.CurrHP<=0
or a==nil or a.HeroBattleInfo==nil or a.HeroBattleInfo.CurrHP<=0 then
return
end
local e=t.HeroBattleInfo:GetBuff(302103903)
if e==nil then
return
end
local e=e:GetBuffData()
if(a:CurrHPPer()<e[1]*MillionCoe)then
if#e>=5 then
local o=e[2]
local i=e[3]
local e={e[4],e[5]}
a:AddBuff(t,o,i,e)
end
if#e>=8 then
local o=e[6]
local i=e[7]
local e={e[8]}
a:AddBuff(t,o,i,e)
end
end
end
return n

