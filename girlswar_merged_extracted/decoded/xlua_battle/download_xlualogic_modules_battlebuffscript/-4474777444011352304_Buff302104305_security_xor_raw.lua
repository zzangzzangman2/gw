local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,n,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.all)
for i=1,#a do
o.AddHaloBuff(e,t,a[i])
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[10],t[11])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[12],t[13])
local o=302104311
local t=-1
local a={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,t,a)
elseif a.buffTriggerTime==BuffTriggerTime.addEnemy then
o.AddHaloBuff(e,t,i)
elseif a.buffTriggerTime==BuffTriggerTime.addMyMate then
o.AddHaloBuff(e,t,i)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.addEnemy)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddHpToFriend(t)
local e=t:GetBuffData()
local o=e[5]
local a=e[14]
if e[14]>=o then
return 0,false
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for i=1,#a do
local a=a[i]
local i=a:CurrHPPer()
if i<e[3]*MillionCoe then
local i=e[4]*MillionCoe
local i=math.floor(a.HeroBattleInfo.MaxHP*i)
local i=math.max(0,i-a.HeroBattleInfo.CurrHP)
a:HpHealthWithBuffImmediately(i,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
e[14]=e[14]+1
if e[14]>=o then
break
end
end
end
local e=o-e[14]
if e<=0 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(302104311,BuffRemoveType.Expire)
end
return e
end
function t.AddHaloBuff(e,a,t)
local o=a[1]
local i=a[2]
local n={e.CurrHeroCtrl.HeroId}
local a=t.HeroBattleInfo:GetBuff(o)
if a then
local t=a:GetBuffData()
table.insert(t,e.CurrHeroCtrl.HeroId)
else
t:AddBuff(e.CurrHeroCtrl,o,i,n)
end
end
function t.DoActionSmallSkill(t)
local e=t:GetBuffData()
local a=e[6]
local o=e[7]
local e={e[8],e[9]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return o

