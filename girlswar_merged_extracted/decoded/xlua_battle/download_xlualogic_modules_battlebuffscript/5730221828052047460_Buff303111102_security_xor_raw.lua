local s=require("DataNode/DataManager/DataMgr/DataUtil")
local l=require("Modules/Battle/BattleUtil")
local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,o,r,h)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if h.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif h.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=e.CurrHeroCtrl.HeroId
if o==a.HeroId then
local a=r.reduceHpValue
t[21]=t[21]+a
local a=303111114
local n=t[5]
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(i)then
local e=i:GetBuffData()
n=e[10]
end
local o=t[6]
local h=s:GetBuffCfg(o)
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
local s=0
if a then
s=a:GetFloors()
end
if s<h.layerLimit then
local n=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*n*MillionCoe
if t[21]>n then
local a=math.floor(t[21]/n)
a=math.min(a,h.layerLimit-s)
t[21]=t[21]-n*a
local s=t[7]
local n={}
for a=8,19 do
table.insert(n,t[a])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,s,n,a)
if(i)then
local t=i:GetBuffData()
local o=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*t[11]*MillionCoe*a)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[12]*a)
end
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e~=nil then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.RefreshAction(e)
end
end
end
end
elseif h.buffTriggerTime==BuffTriggerTime.skill2Attack then
if t[20]>RandomMgr:GetBattleRandom()then
local t=e.CurrHeroCtrl
local e=e.CurrHeroCtrl.HeroId
local t=31111102
local o={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
isSmall=true
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,e)
if a==nil then
l:AddTriggerAttackTask(e,t,o,r)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skill2Attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffBrokenArmy(t,i,o)
local e=t:GetBuffData()
local a=e[23]
local n=e[24]
local e={e[25],e[26],e[27],e[28]}
i:AddBuff(t.CurrHeroCtrl,a,n,e,o)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if t.CurrHeroCtrl.HeroBattleInfo then
t.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
end
end
return d

