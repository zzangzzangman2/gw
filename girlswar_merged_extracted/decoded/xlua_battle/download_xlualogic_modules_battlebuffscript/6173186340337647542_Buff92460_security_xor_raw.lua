local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,s,s,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
o.AddBuffRing(t,e[1])
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
local a=n.triggerSkillAtkType
if i:IsDependAtkType(a)==false then
local a=e[2]
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if n then
if(e[4]>=RandomMgr:GetBattleRandom())then
i:ReduceHeroBuffFloor(t.CurrHeroCtrl,a,e[5])
o.AddBuffBlessingToRandomMate(t,e[6])
o.AddBuffBlessingGift(t,e[5])
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.DoAddFury
or a.buffTriggerTime==BuffTriggerTime.DoAddFuryWithReset then
local a=n.addFuryValue
e[25]=e[25]+a
local i=e[25]
local a=math.floor(i/e[22])
if a>=1 then
e[25]=i-a*e[22]
t.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,a*e[23],true)
o.AddBuffRing(t,a*e[24])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.DoAddFury
or e==BuffTriggerTime.DoAddFuryWithReset)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffRing(e,a)
local t=e:GetBuffData()
local o=t[2]
local t=t[3]
local i={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,t,i,a)
end
function a.AddBuffBlessingToRandomMate(a,t)
local e=a:GetBuffData()
local o=e[7]
local i=i:GetHeroNoBuffByType(a.CurrHeroCtrl,BattleHeroType.ourAll,o,t,true)
for n=1,#i do
local s=e[8]
local t={}
for a=9,12 do
table.insert(t,e[a])
end
table.insert(t,math.floor(e[13]*e[4]*MillionCoe))
table.insert(t,math.floor(e[14]*e[4]*MillionCoe))
i[n]:AddBuff(a.CurrHeroCtrl,o,s,t)
end
end
function a.AddBuffBlessingGift(e,o)
local t=e:GetBuffData()
local i=t[15]
local n=t[16]
local a={}
for o=17,21 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,a,o)
end
return o

