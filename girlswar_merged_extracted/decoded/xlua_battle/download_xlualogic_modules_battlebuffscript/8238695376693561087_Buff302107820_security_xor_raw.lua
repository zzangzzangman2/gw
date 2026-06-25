local e={}
local o=e
local i=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,e,t,o)
i.DoResurgence(a,e,t,o)
end
function e.DoResurgence(e,t,a,a)
local n=t[1]
local i=t[2]
local a={}
for o=3,10 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
o.RemoveAllHorse(e)
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function e.CheckCondition(e)
local t=false
local a=302107811
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local o=e:GetBuffData()
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t=a.IsMaxHorseFloor(e,o)
end
return t
end
function e.RemoveAllHorse(e)
local t=302107811
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local a=e:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.RemoveAllHorse(e,a)
end
end
return o

