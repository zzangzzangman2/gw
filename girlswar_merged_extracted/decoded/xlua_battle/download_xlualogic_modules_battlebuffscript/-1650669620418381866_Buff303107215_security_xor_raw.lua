local h=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
o.CheckAddDamageRes(e)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i)
local a=t[5]
local o=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoBeansActionSmallSkill(e,o,n)
local t=e:GetBuffData()
local a=t[14]
local i=n
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if s then
i=n+t[17]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
if o.HeroBattleInfo.CurrFury>t[12]then
local t=math.floor(o.HeroBattleInfo.CurrFury*t[13]*MillionCoe)
if t>0 then
ModulesInit.ProcedureNormalBattle.StealFury(e.CurrHeroCtrl,o,t,EBattleSrcType.SkillSmall,true)
end
end
local o=t[15]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
return i
end
function e.ConsumeBeansDamageRate(e,a)
local t=e:GetBuffData()
local o=t[14]
local i=a
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if n then
i=a+t[16]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
return i
end
function e.OnDamageRes(e,t)
local t=e:GetBuffData()
o.OnDamageResOnce(e)
end
function e.OnDamageResOnce(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*t[10]*MillionCoe)
h:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,a,true,true)
e.CurrHeroCtrl:AddFuryWithBuffImmediately(t[11])
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
end
function e.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t[9],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=false,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
return o

