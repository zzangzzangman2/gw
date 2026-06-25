local h=require('Modules/BattleBuffScript/BuffPairTools')
local t={}
local r=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local i={}
local n=0
for o=1,#a do
if a[o].profession==t[4]then
n=n+1
end
if a[o].HeroId~=e.CurrHeroCtrl.HeroId then
table.insert(i,a[o])
end
end
local o=t[3]
if n<=t[5]then
o=t[6]
end
if e.CurrHeroCtrl:IsRealLastRowHero()then
o=math.floor(o*t[13]*MillionCoe)
end
for a=1,#i do
local s=i[a]
local n=t[1]
local i=s.HeroBattleInfo:GetBuff(n)
local a=false
if i then
local e=i:GetBuffData()
local e=e[1]
if e==nil or e.assumedamagePercent~=o then
a=true
end
else
a=true
end
if a==true then
local i=t[2]
local a=h.GetDefaultHpChainData()
a.assumedamagePercent=o
a.reduceDamagePercent=t[7]
a.minHpPercent=0
a.defHeroId=e.CurrHeroCtrl.HeroId
a.defBuffId=302108213
local t={a}
s:AddBuffAfterRemove(e.CurrHeroCtrl,n,i,t)
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.OnShareDamge(t,i)
local e=t:GetBuffData()
e[14]=e[14]+i
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local a=0
for t=1,#o do
if o[t].profession==e[11]then
a=a+1
end
end
local n=e[8]
local o=e[9]
if a>e[10]then
o=e[12]
end
local o=i/n*o
local a=302108211
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local e=t.AddKingValue(e,o,"kv_a_OnShareDamge")
end
end
function t.GetShareDamgeValue(e)
local e=e:GetBuffData()
return e[14]
end
function t.ClearShareDamgeValue(e)
local e=e:GetBuffData()
e[14]=0
end
return r

