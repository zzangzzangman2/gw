local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#t do
local e=t[e]
if(e.HeroBattleInfo:GetBuff(303101202)or e.HeroBattleInfo:GetBuff(303101203))then
table.insert(o,e)
end
end
if(o)then
local a={}
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.furyRate
t.value=i[1]*#o
a[#a+1]=t
return a
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.recoverFury)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

