local a=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
local a,t=a:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf,e.buffId)
if#t<=0 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for t=1,#e do
local t=e[t]
local e=303111404
t.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
end
function t.DoAction(e,i,a,a,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.enemyRoundEnd then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eMinHpPercent)
if a then
local t=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for e=1,#o do
local a=o[e]
local e=303111404
local e=a.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetBuffData()
t=t+e[9]
e[9]=0
end
end
t=math.min(t,i[1])
if t>0 then
a:RealHurtWithBuff(t,e)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

