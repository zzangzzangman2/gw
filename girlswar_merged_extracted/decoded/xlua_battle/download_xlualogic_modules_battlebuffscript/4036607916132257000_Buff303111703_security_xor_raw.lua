local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneAfterDamage(e.buffId)
e.CurrHeroCtrl:AddImmuneDebuff(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneAfterDamage(e.buffId)
e.CurrHeroCtrl:RefreshImmuneDebuff()
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ImmuneAfterDamage(e,o,a)
local t=e:GetBuffData()
local n=o.reduceHpValue
local o=n*t[1]*MillionCoe
local i=e.CurrHeroCtrl:GetFinalAtk()
local i=math.floor(i*t[2]*MillionCoe)
o=math.min(o,i)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for t=1,#i do
local t=i[t]
t:HpHealthWithDirect(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
if#t>8 and a then
local o=n*t[9]*MillionCoe
a:RealHurtWithBuff(o,e)
local i=t[3]
local n=t[4]
local o={}
for e=5,8 do
table.insert(o,t[e])
end
local o=a:AddBuff(e.CurrHeroCtrl,i,n,o,t[10])
if o then
local o={}
o[a.HeroId]=t[10]
local t=303111716
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoBeansActionBigSkill2(e,o)
end
end
end
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
return true
end
return s

