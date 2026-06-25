local s=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
local o=nil
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfColumn)
if#a>=2 then
for t=1,#a do
if a[t].HeroId~=e.CurrHeroCtrl.HeroId then
o=a[t]
break
end
end
end
if o~=nil then
local i=t[1]
local n=t[2]
local a={}
for e=3,9 do
table.insert(a,t[e])
end
table.insert(a,e.CurrHeroCtrl.HeroId)
o:AddBuff(e.CurrHeroCtrl,i,n,a)
t[11]=o.HeroId
else
t[11]=e.CurrHeroCtrl.HeroId
end
elseif i.buffTriggerTime==BuffTriggerTime.attacked then
local a=t[11]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a then
local i=t[3]
local o=t[4]
local t={t[5],t[6]}
a:AddBuff(e.CurrHeroCtrl,i,o,t)
end
elseif i.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
if n.CheckCondition(e)==false then
return
end
local a=t[11]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a==nil then
return
end
if s:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*t[7]*t[8]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId)
a:AddFuryWithBuffImmediately(t[9])
n.RecordCanImmuneDead(e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckCondition(e)
local e=e:GetBuffData()
if e[12]>=e[10]then
return false
end
return true
end
function a.RecordCanImmuneDead(e)
local e=e:GetBuffData()
e[12]=e[12]+1
end
function a.ShowTreasure(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle259TreasureImmuneDeadEffect,e.x,e.y,50,3,0,false,function()
end)
end
end
return n

