local i=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=t[1],
damageResHeroId=e.CurrHeroCtrl.HeroId
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
return nil
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.OnReduceHpRes(e,a,t)
local o=e:GetBuffData()
if t==HeroHurtType.buff then
local e={
isSeparately=true,
realHurtValue=a
}
return e
end
local t=43278
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.AddBuffBrokenCherry(o,1)
end
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,e.buffId,1)
local e={
isSeparately=false,
realHurtValue=a
}
return e
end
return n

