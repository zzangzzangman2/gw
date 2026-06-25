local h=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuffWithBuffList(e.buffId)
end
function t.OnRemoveSelf(e,a)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
e.CurrHeroCtrl:RemoveImmuneDebuffWithBuffList(e.buffId)
t.FixCaptureParam(e,true)
end
function t.DoAction(e,n,s,o,t,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local h=e.CurrHeroCtrl
if i.buffTriggerTime==BuffTriggerTime.now then
a.FixCaptureParam(e,false)
elseif i.buffTriggerTime==BuffTriggerTime.attack then
if a.IsCaptiveTarget(e,o)then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=n[1]
t.value=n[2]
s.HeroBattleInfo:AddTempBuffValue(t)
end
elseif i.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroId==s.HeroId
and a.IsCaptiveTarget(e,o)then
local t=math.floor(o.HeroBattleInfo.MaxHP*n[3]*MillionCoe)
h:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
o:RealHurtWithBuff(t,e)
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.attack
or e==BuffTriggerTime.afterAttacked then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.IsCaptiveTarget(t,a)
local e=43293
local e=a.HeroBattleInfo:GetBuff(e)
if e and e.releaseHeroId==t.CurrHeroCtrl.HeroId then
return true
end
return false
end
function t.FixCaptureParam(e,i)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl
local n=43293
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
for o=1,#e do
local e=e[o]
local e=e.HeroBattleInfo:GetBuff(n)
if e and e.releaseHeroId==a.HeroId then
local e=e:GetBuffData()
if i then
e[1]=0
e[2]=0
e[3]=0
else
e[1]=t[4]
e[2]=t[5]
e[3]=t[6]
end
end
end
end
function t.ImmuneDebuff(t,s,e)
local o=t:GetBuffData()
if o[7]<RandomMgr:GetBattleRandom()then
return false
end
local i=t.CurrHeroCtrl
local e={}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.enemyAll)
for o=1,#n do
local o=n[o]
if a.IsCaptiveTarget(t,o)then
table.insert(e,o)
end
end
if#e==0 then
return false
end
local e=RandomTableWithSeed(e,o[8])
for t=1,#e do
local e=e[t]
h:AddBuffWithBuffCopy(e,i,s,{buffAddType=EBuffAddType.FightBack,buffTriggerAddType=EBuffAddType.FightBack})
end
return true
end
return a

