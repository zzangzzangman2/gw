local s=require("Modules/Battle/BattleUtil")
local h=require("Modules/BattleSkillScript/21088/Skill21088Util")
local o={}
local a=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,n,o,r,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
a.GainEnergy(t,e[7])
a.AddBuffLingyu(t.CurrHeroCtrl,e)
elseif i.buffTriggerTime==BuffTriggerTime.skillPlay then
a.AddBuffLingyu(t.CurrHeroCtrl,e)
elseif i.buffTriggerTime==BuffTriggerTime.allSkillAttack then
local o=0
local i=e[5]
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
o=i:GetFloors()
end
if o>e[9]then
if n.IsOurHero==t.CurrHeroCtrl.IsOurHero then
a.ConumeEnergy(t,e[16])
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
if t and#t>0 then
for a=1,#t do
local t=t[a]
local a={
attrId=e[17],
value=e[18],
}
t:AddAttrValueInCurAttack(a)
local e={
attrId=e[19],
value=e[20],
}
t:AddAttrValueInCurAttack(e)
end
end
else
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=s:GetMinHpPercentHeroArr(o,1)
local o=o[1]
if o then
local n=o.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
local i=e[30]
if a.CheckProvidedShield(i,o.HeroId)==false and n<=0 then
a.ConumeEnergy(t,e[10])
local a=e[13]*MillionCoe
local s=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*a)
local n=e[11]
local a=e[12]
local e={s}
o:AddBuff(t.CurrHeroCtrl,n,a,e)
i[o.HeroId]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
else
if o.HeroBattleInfo.CurrHP<o.HeroBattleInfo.MaxHP then
local s=e[38]
local n=e[39]
local i=n[o.HeroId]
if i==nil or i.bigRound~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound or i.count<s then
a.ConumeEnergy(t,e[14])
local a=1
if i then
a=i.count+1
end
n[o.HeroId]={
bigRound=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound,
count=a
}
local e=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[15]*MillionCoe
o:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
end
end
end
end
end
elseif i.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if n.IsOurHero==t.CurrHeroCtrl.IsOurHero
and n:IsPet()==false
and e[37]==0 then
local o=r.criticalOrBlock
if(o==1)then
e[37]=1
if e[32]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[32]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[31]=0
end
e[31]=e[31]+1
a.CheckAddExtraEnergy(t)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or i.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or i.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if(n.IsOurHero==t.CurrHeroCtrl.IsOurHero
and n:IsPet()==false)then
e[37]=0
end
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if h.HasAllMusicBuff(t.CurrHeroCtrl)then
h.ClearAllMusicBuff(t.CurrHeroCtrl)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.CheckAddEnergy(o,t,i)
local e=o:GetBuffData()
a.GainEnergy(o,t)
e[33]=t
e[34]=t
e[35]=i
e[36]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
a.CheckAddExtraEnergy(o)
end
function o.CheckAddExtraEnergy(o)
local e=o:GetBuffData()
if e[36]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
if e[32]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[32]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[31]=0
end
local i=e[31]
local t=o.CurrHeroCtrl:GetTeamBuff(302108817)
if t then
local t=a.CalculateEnergy(e[33],i)
t=math.min(t,e[35])
local i=t-e[34]
e[34]=t
if i>0 then
a.GainEnergy(o,i)
end
end
end
function o.CalculateEnergy(e,t)
local a=2
local e=e
for t=1,t do
e=e*a
end
return e
end
function o.GainEnergy(e,n)
local t=e:GetBuffData()
local a=t[5]
local i=t[6]
local o={}
local t=t[8]
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,a,i,o,n,t)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local a=0
if t then
a=t:GetFloors()
end
local t=302108823
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.OnEnergyChange(e,a)
end
end
function o.GetEnergyCount(e)
local t=e:GetBuffData()
local a=t[5]
local t=0
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
t=e:GetFloors()
end
return t
end
function o.ConumeEnergy(e,a)
local t=e:GetBuffData()
local t=t[5]
s:ReduceHeroBuffFloor(e.CurrHeroCtrl,t,a)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local a=0
if t then
a=t:GetFloors()
end
local t=302108823
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.OnEnergyChange(e,a)
end
end
function o.CheckProvidedShield(e,t)
if e[t]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return true
end
return false
end
function o.AddBuffLingyu(e,t)
local o=t[21]
local i=t[22]
local a={}
for o=23,29 do
table.insert(a,t[o])
end
e.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
e:AddTeamBuff(e,o,i,a)
end
return a

