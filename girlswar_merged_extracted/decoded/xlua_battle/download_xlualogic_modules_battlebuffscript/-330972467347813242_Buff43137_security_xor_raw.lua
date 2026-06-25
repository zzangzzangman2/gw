local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(a,t)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
local e=t[21]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo then
local t=t[5]
local a=a.CurrHeroCtrl.HeroId
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local e=e:GetBuffData()
local e=e[1]
for t=1,#e do
if a==e[t]then
table.insert(e,t)
break
end
end
end
end
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
o.AddLove(t,e)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
o.AddLove(t,e)
elseif a.buffTriggerTime==BuffTriggerTime.critical then
local a=e[21]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a then
local i=e[5]
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
local i=i:GetBuffData()
local i=i[1]
if o.CheckInHeroId(i,a.HeroId)then
local o=e[12]
local i=e[13]
local e={e[14],e[15],e[16],e[17]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e)
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.critical)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddLove(t,a)
local e=a[21]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e==nil then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#i>0 then
local i=RandomTableWithSeed(i,1)
e=i[1]
if e then
a[21]=e.HeroId
local i=a[5]
local h=a[6]
local n={}
local n=t.CurrHeroCtrl.HeroId
local s=e.HeroBattleInfo:GetBuff(i)
if s then
local e=s:GetBuffData()
local e=e[1]
o.CheckAddHeroId(e,n)
else
local a=e:CurrHPPer()
local o={n}
local a={o,a}
e:AddBuff(t.CurrHeroCtrl,i,h,a)
end
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
local i=i:GetBuffData()
local i=i[1]
if o.CheckInHeroId(i,e.HeroId)then
local o=a[18]
local n=a[19]
local i={a[20]}
local s=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
local a=e.HeroBattleInfo:GetBuff(o)
if(s==nil or s.isExec==false)
and(a==nil or a.isExec==false)then
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,i)
e:AddBuff(t.CurrHeroCtrl,o,n,i)
end
end
end
end
end
end
end
function a.CheckInHeroId(e,a)
for t=1,#e do
if a==e[t]then
return true
end
end
return false
end
function a.CheckAddHeroId(e,t)
if o.CheckInHeroId(e,t)==false then
table.insert(e,t)
table.sort(e,function(e,t)
return e<t
end)
end
end
function a.DoActionWith4(t,i)
local e=t:GetBuffData()
local o=e[9]
local a=e[10]
if(e[7]>=RandomMgr:GetBattleRandom())then
local e=math.floor(i.HeroBattleInfo.MaxHP*e[11]*MillionCoe)
local e={e}
i:AddBuff(t.CurrHeroCtrl,o,a,e)
end
if(e[8]>=RandomMgr:GetBattleRandom())then
local e=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[11]*MillionCoe)
local e={e}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
function a.OnRemoveLoveUndeadChance(e)
local t=e:GetBuffData()
local e=t[21]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
local t=t[18]
local e=e.HeroBattleInfo:GetBuff(t)
if e then
e.isExec=true
end
end
end
return o

