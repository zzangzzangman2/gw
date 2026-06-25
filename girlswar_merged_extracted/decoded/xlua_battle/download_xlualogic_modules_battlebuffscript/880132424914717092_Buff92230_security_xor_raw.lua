local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(t,o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fHollow,nil,nil,nil,nil,{isContainUsualState=true})
for a,e in ipairs(e)do
if e.HeroBattleInfo then
local a=o[1]
local o=e.HeroBattleInfo:GetBuff(a)
if o and o.releaseHeroId==t.CurrHeroCtrl.HeroId then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
for e,a in ipairs(e)do
local e=o[5]
local e=a.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetBuffData()
local o=e[4]
for i=1,#o do
local e=o[i]
if e.treasureHeroId==t.CurrHeroCtrl.HeroId then
table.remove(o,i)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
break
end
end
end
end
end
function t.DoAction(e,o,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fHollow,nil,nil,nil,nil,{isContainUsualState=true})
table.insert(a,e.CurrHeroCtrl)
if(a)then
local i=o[1]
local n=o[2]
local t={}
for e=3,10 do
table.insert(t,o[e])
end
table.insert(t,e.CurrHeroCtrl.HeroId)
local o=3
if e.CurrHeroCtrl.battleStationIndex==1 or e.CurrHeroCtrl.battleStationIndex==4 then
o=4
end
table.insert(t,o)
table.insert(t,e.CurrHeroCtrl.battleStationIndex)
for o,a in ipairs(a)do
if a.HeroBattleInfo then
a:AddBuff(e.CurrHeroCtrl,i,n,t)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.removeMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

