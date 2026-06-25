local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuffWithBuffList(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneDebuffWithBuffList(e.buffId)
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ImmuneDebuff(e,a)
local t=e:GetBuffData()
if o:IsDispelDeBuff(a.buffId)then
if o:IsCtlBuff(a.buffId)then
if(t[5]+t[6]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
return true
end
else
if(t[5]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
return true
end
end
end
return false
end
return i

