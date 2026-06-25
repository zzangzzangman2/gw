local s={43262,43263,43266}
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
if e[21]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[21]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[20]=0
end
local o=e[20]
local a=e[2]
local n=a-o
local i=e[3]
local o=0
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a then
o=a:GetFloors()
end
local a=e[6]-o
local a=math.min(a,n)
local a=math.min(a,e[1])
if a>0 then
local n=e[4]
local o={}
local o=t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,n,o,a)
if o then
e[20]=e[20]+a
t.CurrHeroCtrl:AddFuryWithBuff(e[5]*a)
end
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckAddBuffFluttering(e,i)
local n=e:GetBuffData()
local r=0
local h=0
for t=1,#s do
local a=s[t]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
r=t
break
end
end
local t=1
local s=n[3]
local a=0
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(s)
if s then
a=s:GetFloors()
if i and a>=i[1]then
t=3
elseif a>=n[7]then
t=2
end
end
if t>r then
if t==1 then
o.AddBuffFluttering1(e)
elseif t==2 then
o.AddBuffFluttering2(e)
elseif t==3 then
o.AddBuffFluttering3(e,i)
end
if h~=0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(h,BuffRemoveType.Expire)
end
end
end
function t.AddBuffFluttering1(e)
local t=e:GetBuffData()
local i=t[8]
local o=t[9]
local a={}
for o=10,13 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
end
function t.AddBuffFluttering2(t)
local e=t:GetBuffData()
local o=e[14]
local i=e[15]
local a={}
for t=10,13 do
table.insert(a,e[t])
end
for o=16,19 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,a)
end
function t.AddBuffFluttering3(t,a)
local o=t:GetBuffData()
local n=a[6]
local i=a[7]
local e={}
for t=10,13 do
table.insert(e,o[t])
end
for t=16,19 do
table.insert(e,o[t])
end
for t=8,13 do
table.insert(e,a[t])
end
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,e)
end
return o

