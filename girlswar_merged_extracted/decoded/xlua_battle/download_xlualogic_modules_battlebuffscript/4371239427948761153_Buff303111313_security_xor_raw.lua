local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,i,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
t.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif o.buffTriggerTime==BuffTriggerTime.allHeroAfterSufferDmg then
if a.IsOurHero~=t.CurrHeroCtrl.IsOurHero then
return
end
local o=e[20]
if(e[22]>=o)then
return nil
end
local a=a
if a then
local n=a:CurrHPPer()
local o=a.HeroId
local i=e[7]*MillionCoe
if(e[23][o]==nil or e[23][o]>i)and n<=i then
local i=e[8]
local n=e[9]
local o=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*e[10]*MillionCoe)
local o={o}
a:AddBuff(t.CurrHeroCtrl,i,n,o)
local i=e[11]
local n=e[12]
local o={e[13],e[14]}
a:AddBuff(t.CurrHeroCtrl,i,n,o)
local n=e[15]
local o=e[16]
local i={e[17],e[18]}
a:AddBuff(t.CurrHeroCtrl,n,o,i)
local a=303111308
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddGuardLight(t,e[19])
end
e[22]=e[22]+1
end
e[23][o]=n
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.allHeroAfterSufferDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.RecordGuardLightCount(a,t)
local e=a:GetBuffData()
e[21]=e[21]+t
if e[21]>=e[5]then
local t=math.floor(e[21]/e[5])
local o=303111308
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.AddBuffPhotonCharging(a,t)
e[21]=e[21]-e[5]*t
end
end
end
return s

