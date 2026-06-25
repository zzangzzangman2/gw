local e=require('Modules/BattleBuffScript/BuffResurgenceMgr')
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,a,i,o)
e.DoResurgence(t,a,i,o)
end
function t.DoResurgence(e,t,a,a)
local o=t[1]
local i=t[2]
local a={}
for o=3,4 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(30106424)
if t then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t.buffId,BuffRemoveType.Expire)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

