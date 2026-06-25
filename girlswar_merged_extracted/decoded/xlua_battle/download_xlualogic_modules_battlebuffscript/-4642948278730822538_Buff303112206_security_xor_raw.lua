local n=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl:AddAttrMinValue(e.buffId,t[5],t[6])
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:RemoveAttrMinValue(e.buffId,t[5])
end
function t.DoAction(e,t,s,a,n,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
if a==nil or n==nil then
return
end
if e.CurrHeroCtrl.HeroId~=a.HeroId then
return
end
if n.criticalOrBlock~=2 then
return
end
i.AddBuffHeartEye(e,t[9])
i.AddBuffEmptyMark(e,s)
elseif o.buffTriggerTime==BuffTriggerTime.attack then
if a~=nil and a.HeroBattleInfo and a.HeroBattleInfo:GetBuff(t[12])then
a.ignoreShildByDamage=true
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffHeartEye(e,a)
if e==nil or e.CurrHeroCtrl==nil then
return
end
if a==nil or a<=0 then
return
end
local t=e:GetBuffData()
local o=t[7]
local s=t[8]
local i=t[10]
local h=t[11]
local t=n:GetHeroBuffFloor(e.CurrHeroCtrl,o)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,s,{},a)
local a=n:GetHeroBuffFloor(e.CurrHeroCtrl,o)
local t=math.max(a-t,0)
if e.CurrHeroCtrl.HeroBattleInfo then
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*i*MillionCoe)*t
if t>0 then
e.CurrHeroCtrl:HpHealthWithDirect(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
if t>0 then
e.CurrHeroCtrl:AddFuryWithBuffImmediately(h*t)
end
if t>0 then
local a=303112214
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.OnHeartEyeFloorsAdded(e,t)
end
end
end
function t.AddBuffEmptyMark(o,a)
if a==nil then
return
end
local e=o:GetBuffData()
local i=e[12]
local n=e[13]
local t={}
for a=14,20 do
table.insert(t,e[a])
end
table.insert(t,0)
a:AddBuff(o.CurrHeroCtrl,i,n,t)
end
function t.TriggerAllEmptyMarks(e)
local t=e:GetBuffData()
local t=t[12]
local e=e.CurrHeroCtrl
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local o=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local e=0
for i=1,#a do
local a=a[i]
local t=a.HeroBattleInfo:GetBuff(t)
if t then
o.ApplyEmptyMarkHurtAndInjureRes(t)
e=e+1
end
end
return e
end
return i

