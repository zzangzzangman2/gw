local e={}
local s=e
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
function e.AddBuffToEnemy(o,a)
local e=o:GetBuffData()
local n=e[3]
local t={}
local i={
buffId=e[4],
buffRound=e[5],
buffValue=0
}
table.insert(t,i)
local i={
buffId=e[6],
buffRound=e[7],
buffValue={e[8],e[9]}
}
table.insert(t,i)
local i={
buffId=e[10],
buffRound=e[11],
buffValue={e[12],e[13]}
}
table.insert(t,i)
local e={
buffId=e[14],
buffRound=e[15],
buffValue={e[16],e[17]}
}
table.insert(t,e)
local e={}
for o=1,#t do
local t=t[o]
local a=a.HeroBattleInfo:GetBuff(t.buffId)
if a==nil then
table.insert(e,t)
end
end
if#e<=0 then
e=t
end
local e=RandomTableWithSeed(e,1)
local e=e[1]
a:CheckAddBuff(n,o.CurrHeroCtrl,e.buffId,e.buffRound,e.buffValue)
end
return s

