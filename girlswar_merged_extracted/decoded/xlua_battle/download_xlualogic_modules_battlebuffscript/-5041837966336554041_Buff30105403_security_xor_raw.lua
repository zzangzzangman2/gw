local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if e.releaseHeroId==e.CurrHeroCtrl.HeroId then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
for a=1,#t do
local o=t[a]
local t=30105406
local a=o.HeroBattleInfo:GetBuff(t)
if a and a.releaseHeroId==e.CurrHeroCtrl.HeroId then
o.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
end
function a.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
if#t>=4 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
if#t>=6 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

