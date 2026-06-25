local a=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,s,n,n,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
o.AddBuffGhostsPower(e,t[5])
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local n=303111504
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if(i)then
local i=i:GetFloors()
if i>=t[8]then
local i=o.AddBuffGreatRivers(e,e.CurrHeroCtrl)
if i then
local i=a.GetOtherHeroInSameColumn(e.CurrHeroCtrl)
if i and i:IsRealLastRowHero()then
o.AddBuffGreatRivers(e,i)
end
a:ReduceHeroBuffFloor(e.CurrHeroCtrl,n,t[8])
end
end
end
elseif i.buffTriggerTime==BuffTriggerTime.attacked then
local t=true
local a=303111501
local a=s.HeroBattleInfo:GetBuff(a)
if a==nil then
local e=303111502
local e=s.HeroBattleInfo:GetBuff(e)
if e==nil then
t=false
end
end
if t then
e.CurrHeroCtrl:AddForceRestraintTypeInCurAttack(EForceRestraintType.ImmuneRestraint,true,true)
end
elseif i.buffTriggerTime==BuffTriggerTime.smallRoundStartTeamAttack then
if t[33]==1 then
t[33]=0
o.AddAttackTask(e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.smallRoundStartTeamAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffGhostsPower(e,i)
local t=e:GetBuffData()
local a=t[6]
local t=t[7]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o,i)
end
function t.AddBuffGreatRivers(t,s)
local e=t:GetBuffData()
local o=e[9]
local n,i=a:GetHeroNoBuffByType(t.CurrHeroCtrl,BattleHeroType.ourAll,o,nil,true)
if#i>=e[17]then
return false
end
local h=e[10]
local i={}
for t=11,16 do
table.insert(i,e[t])
end
local n=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local n=math.floor(n*e[15]*MillionCoe)
table.insert(i,n)
local n=s:AddBuff(t.CurrHeroCtrl,o,h,i)
local o,a=a:GetHeroNoBuffByType(t.CurrHeroCtrl,BattleHeroType.ourAll,o,nil,true)
local o=#a
local i=e[18]
local a=e[19]
local e={e[20],e[21]}
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,i,a,e,o)
return n
end
function t.AddBuffGhostsPoisonWine(o,a,d,r)
local e=o:GetBuffData()
local t=0
local n=e[24]
local i=e[25]
local h=false
local s=r
local l=a.HeroBattleInfo:GetBuff(n)
if(l)then
t=n
else
local o=0
local a=a.HeroBattleInfo:GetBuff(i)
if(a)then
local a=a:GetFloors()
local a=a+r
if a>e[31]then
t=n
s=a
h=true
else
t=i
end
else
t=i
end
end
local r=e[26]
local n={}
for t=27,28 do
table.insert(n,e[t])
end
local l=o.CurrHeroCtrl.HeroBattleInfo.MaxHP
local e=math.floor(l*e[29]*MillionCoe)
table.insert(n,e)
local e=false
if d then
e=a:CheckAddBuff(d,o.CurrHeroCtrl,t,r,n,s)
else
e=a:AddBuff(o.CurrHeroCtrl,t,r,n,s)
end
if h==true and e then
a.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
function t.AddAttackTask(e,n)
local t=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local e=31115304
if e>0 then
local i={
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if o==nil then
a:AddTriggerAttackTask(t,e,i,n)
end
end
end
function t.AddPreviewAttackTask(e)
local e=e:GetBuffData()
e[33]=1
end
return o

