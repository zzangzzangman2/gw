local i=require("Modules/Battle/BattleUtil")
local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,t,o,n,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attack then
local n=e.CurrHeroCtrl:GetLostHp()
local a=43279
local a=i:GetHeroBuffFloor(e.CurrHeroCtrl,a)
local a=n*a*t[1]*MillionCoe
local i=o:GetFinalAtk()
a=math.min(a,i*t[2]*MillionCoe)
a=math.floor(a)
if a>0 then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.trueDmg
t.value=a
o.HeroBattleInfo:AddTempBuffValue(t)
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
t[4]={}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
for a=1,#e do
local e=e[a].HeroId
t[4][e]=true
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if t[4]then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
for e=1,#a do
local e=a[e].HeroId
t[4][e]=nil
end
local a=false
for e,e in pairs(t[4])do
a=true
break
end
if a then
local a=43275
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffFallingCherry(e,t[3])
end
end
end
t[4]={}
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

