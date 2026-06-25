local o=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
s.AddBuffRune(e)
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf,nil,nil,nil,{isContainUsualState=true})
local a=false
for o=1,#t do
if t[o].heroDid==e.CurrHeroCtrl.heroDid then
a=true
break
end
end
if a==false then
local a=303111401
local i,t=o:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.enemyAll,a,nil,true)
for e=1,#t do
t[e].HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
local t=303111417
local a,e=o:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,t,nil,true)
for a=1,#e do
e[a].HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffRune(t)
local e=t:GetBuffData()
local a=e[5]
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(303111411)
if o then
local e=o:GetBuffData()
a=e[5]+a
end
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(303111415)
if o then
local e=o:GetBuffData()
a=e[10]+a
end
local o={303111406,303111407,303111408}
local n={}
local i={}
for e=1,#o do
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o[e])
if t==nil then
table.insert(n,o[e])
else
table.insert(i,o[e])
end
end
local o=RandomTableWithSeed(n,a)
local a=a-#o
if a>0 and#i>0 then
local e=RandomTableWithSeed(i,a)
table.appendList(o,e)
end
for a=1,#o do
local a=o[a]
if a==303111406 then
local n=e[6]
local i=e[7]
local a={}
for o=8,8 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,a)
elseif a==303111407 then
local n=e[9]
local i=e[10]
local a={}
for o=11,12 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,a)
elseif a==303111408 then
local a=e[13]
local o=e[14]
local e={e[15]}
table.insert(e,0)
table.insert(e,0)
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
end
function a.AddBuffShadowHunt(e)
local t=e:GetBuffData()
local o=t[17]
local i=t[18]
local a={}
for o=19,22 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
if e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(o)
end
end
return s

