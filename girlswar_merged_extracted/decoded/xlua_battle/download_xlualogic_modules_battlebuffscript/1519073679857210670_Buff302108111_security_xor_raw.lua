local r=require("Modules/Battle/BattleUtil")
local t={}
local a=t
local o={
Normal=1,
Super=2,
}
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.ChangeState(e,t,t[31])
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.HandleEachRoundStart(e,t)
end
elseif o.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
a.HandleFatalDmgBefore(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.IsSuperState(e)
local e=e:GetBuffData()
if e[31]==o.Super then
return true
else
return false
end
end
function t.ChangeState(t,e,i)
e[31]=i
if i==o.Super then
a.DoChangeSuperState(t,e)
else
a.DoChangeNormalState(t,e)
end
end
function t.DoChangeNormalState(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(302108110,BuffRemoveType.Expire)
end
function t.DoChangeSuperState(t,e)
t.CurrHeroCtrl:AddImmuneReduceFury(t.buffId)
local a=302108110
local i=-1
local o=0
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,o)
if t.CurrHeroCtrl.HeroBattleInfo then
t.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#a do
local a=a[o]
local s=e[10]
local n=e[11]
local i=e[13]
local o=e[15]
if a:IsRealFirstRowHero()then
i=e[13]*e[16]*MillionCoe
o=e[15]*e[16]*MillionCoe
end
local e={e[12],i,e[14],o}
a:AddBuff(t.CurrHeroCtrl,s,n,e,1)
end
local a=302108117
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.ResetFightBackCount(e)
end
end
function t.HandleEachRoundStart(i,e)
local h=e[31]
if h==o.Normal then
local s=302108106
local n=i.CurrHeroCtrl.HeroBattleInfo:GetBuff(s)
local s=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if s.CheckFightValueMax(n)then
if a.CheckTriggerMaxCount(i,e)then
return
end
e[30]=e[30]+1
t.ChangeState(i,e,o.Super)
a.AddAttrInSuper(i,e)
s.SetFightValue(n,0)
end
elseif h==o.Super then
a.AddAttrInSuper(i,e)
end
end
function t.AddAttrInSuper(t,e)
local a=t.CurrHeroCtrl.CurrBattleTeam:GetAllHerosCountInBattle()
local n=e[1]
local o=e[2]
local i={e[3],e[4]*a,e[5],e[6]*a,e[7],e[8]*a}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,o,i)
t.CurrHeroCtrl:AddFuryWithBuff(e[9]*a)
t.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
function t.HandleFatalDmgBefore(e,t)
local n=t[31]
e.isExcuteInTimeLine=false
local i=302108118
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if n==o.Normal then
if a.CheckTriggerMaxCount(e,t)then
return false
end
if r:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
t[30]=t[30]+1
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local n=t[19]
local s=t[20]
if i then
local e=i:GetBuffData()
n=e[8]
s=e[9]
end
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local i=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=math.floor(i*n*MillionCoe)
e.CurrHeroCtrl:HpHealthSimple(e.CurrHeroCtrl,i,EBattleSrcType.DeathImmune)
e.CurrHeroCtrl:AddFuryWithBuff(s)
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
local s=t[21]
local n=t[22]
local i={}
for a=23,28 do
table.insert(i,t[a])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,s,n,i)
a.ChangeState(e,t,o.Super)
elseif n==o.Super then
if r:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
local n=t[17]
local s=t[18]
if i then
local e=i:GetBuffData()
n=e[8]
s=e[9]
end
local i=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=math.floor(i*n*MillionCoe)
e.CurrHeroCtrl:HpHealthSimple(e.CurrHeroCtrl,i,EBattleSrcType.DeathImmune)
e.CurrHeroCtrl:AddFuryWithBuff(s)
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
a.ChangeState(e,t,o.Normal)
end
end
function t.CheckIgnoreDead(i)
local t=i:GetBuffData()
local e=t[31]
if e==o.Normal then
if a.CheckTriggerMaxCount(i,t)==false then
return true
end
elseif e==o.Super then
return true
end
return false
end
function t.CheckTriggerMaxCount(o,t)
local e=0
local a=302108118
local o=o.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e=t.GetStateChangeCount(o)
end
if t[30]>=t[29]+e then
return true
end
return false
end
return a

