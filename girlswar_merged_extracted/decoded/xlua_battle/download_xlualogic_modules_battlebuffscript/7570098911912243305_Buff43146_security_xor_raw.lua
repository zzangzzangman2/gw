local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
local t={
buffId=e.buffId,
reduceHpMinHpPercent=t[10],
reduceHpResRate=t[11],
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=t[1]
local i=t[2]
local a={}
for e=3,8 do
table.insert(a,t[e])
end
local o=t[9]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,n,i,a,1,o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fHollow)
for s=1,#t do
local t=t[s]
t:AddBuffWithMaxFloor(e.CurrHeroCtrl,n,i,a,1,o)
end
return nil
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

