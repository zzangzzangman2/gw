local i=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
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
function e.DoActionSmallSkill(e,t)
local t=e:GetBuffData()
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if#a>t[1]then
local a=t[2]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if n then
local t=i.GetShieldCanAdd(e.CurrHeroCtrl,a,o,t[4],t[5])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(a,HeroAttrId.shield,t)
else
local o=t[3]
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[4]*MillionCoe)
local t={t}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
end
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[6]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuff(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local a=math.floor(o*t[7]*MillionCoe)
i:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,a,true,true)
local e=math.floor(o*t[8]*MillionCoe)
return e
end
return s

