local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(e[1]>=RandomMgr:GetBattleRandom())then
local a={}
local o={
buffId=e[2],
buffRound=e[3],
buffValue={e[4],e[5]}
}
table.insert(a,o)
local o={
buffId=e[6],
buffRound=e[7],
buffValue={e[8],e[9]}
}
table.insert(a,o)
local o={
buffId=e[10],
buffRound=e[11],
buffValue={e[12],e[13]}
}
table.insert(a,o)
local e={
buffId=e[14],
buffRound=e[15],
buffValue={e[16],e[17]}
}
table.insert(a,e)
local e={}
for o=1,#a do
local a=a[o]
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a.buffId)
if t==nil then
table.insert(e,a)
end
end
if#e<=0 then
e=a
end
local e=RandomTableWithSeed(e,1)
local e=e[1]
if e then
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,e.buffId,e.buffRound,e.buffValue)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play or e==BuffTriggerTime.skill2Play or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i

