local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,s,s,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e.CurrHeroCtrl
local o=i.GetOtherHeroInSameColumn(e.CurrHeroCtrl)
if o then
a=o
end
local i=t[1]
local n=t[2]
local o={t[3],t[4]}
for e=7,12 do
table.insert(o,t[e])
end
a:AddBuff(e.CurrHeroCtrl,i,n,o)
t[14]=a.HeroId
t[15]={}
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=e.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle2602TreasureCareEffect,t.x,t.y,t.z,3,0,false,function()
end)
if a.HeroId~=e.CurrHeroCtrl.HeroId then
local e=a:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle2602TreasureCareEffect,e.x,e.y,e.z,3,0,false,function()
end)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
local e=t[14]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
local t=t[1]
e.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
o.HurtByConvert(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
local t=n.triggerSkillAtkType
if i:IsDependAtkType(t)==false then
o.RefreshAddDamageConvertPercent(e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.HurtByConvert(n,e)
local t=0
local a=e[15]
if#a>0 then
for o=#a,1,-1 do
local e=a[o]
local i=e.leftPercent/e.round
local n=e.totalHurtValue*i*MillionCoe
t=t+n
e.round=e.round-1
e.leftPercent=e.leftPercent-i
if e.leftPercent<=0 or e.round<=0 then
table.remove(a,o)
end
end
end
if t>0 then
n.CurrHeroCtrl:RealHurtWithBuff(t,n)
end
end
function a.RefreshAddDamageConvertPercent(e)
local e=e:GetBuffData()
e[16]=e[16]or 0
if e[17]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[17]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[16]=0
end
local t=e[6]
if(e[16]>=t)then
return nil
end
local t=e[15]
if#t>0 then
e[16]=e[16]+1
for a=#t,1,-1 do
local t=t[a]
t.leftPercent=t.leftPercent*(1-e[5]*MillionCoe)
end
end
end
return o

