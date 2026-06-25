local i=require("Modules/Battle/BattleUtil")
local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,o,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.triggerSkillAtkType~=ETriggerSkillAtkType.Normal then
return
end
local a={}
for t=1,10 do
table.insert(a,e[t])
end
local n=i:GetDataByWeight(a)
local a={}
local o={
buffId=e[12],
buffRound=e[13],
buffValue={e[14],e[11]}
}
table.insert(a,o)
local o={
buffId=e[15],
buffRound=e[16],
buffValue={e[17],e[11]}
}
table.insert(a,o)
local o={
buffId=e[18],
buffRound=e[19],
buffValue={e[20],e[11]}
}
table.insert(a,o)
local o={
buffId=e[21],
buffRound=e[22],
buffValue={e[23],e[11]}
}
table.insert(a,o)
local o={
buffId=e[24],
buffRound=e[25],
buffValue={e[26],e[11]}
}
table.insert(a,o)
local o={}
for e=1,#a do
local e=a[e]
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e.buffId)
if t==nil then
table.insert(o,e)
end
end
if#o<=0 then
o=a
end
local a={e[12],e[15],e[18],e[21],e[24]}
local i=0
for e=1,#a do
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a[e])
if e then
i=i+1
end
end
local o=RandomTableWithSeed(o,n)
for e=1,#o do
local e=o[e]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,e.buffId,e.buffRound,e.buffValue)
end
if i<#a then
local o=0
for e=1,#a do
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a[e])
if e then
o=o+1
end
end
if o>=#a then
local a=(e[29])*MillionCoe
local a=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
t.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Treasure,t.releaseHeroId,t.buffId)
local o=e[27]
local e=e[28]
local a={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,e,a)
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
return s

