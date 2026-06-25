local s=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,s,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
o.GainJinBuff(e,t[7])
o.AddBuffImmune(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eOneBack)
if t then
o.AddBuffJinCourage(e,t)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local a=e.CurrHeroCtrl.HeroId
if a==s.HeroId then
o.GainJinBuff(e,t[19])
local a=t[11]
local a=i.HeroBattleInfo:GetBuff(a)
local n=n.criticalOrBlock
if n==1 or a then
local a=math.floor(t[20]*i.HeroBattleInfo.CurrFury*MillionCoe)
a=math.max(a,t[21])
ModulesInit.ProcedureNormalBattle.StealFury(e.CurrHeroCtrl,i,a,EBattleSrcType.Buff)
end
if n==2 then
o.GainJinBuff(e,t[22])
e.CurrHeroCtrl:AddFuryWithBuff(t[23])
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.fatalDmg then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=#t
for a=1,a do
local t=t[a]
o.AddBuffJinCourage(e,t)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GainJinBuff(e,i)
local t=e:GetBuffData()
local a=t[5]
local o=t[6]
local n={}
local t=t[8]
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,a,o,n,i,t)
end
function a.CheckJinFull(t)
local e=t:GetBuffData()
local a=e[5]
local o=e[8]
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local e=e:GetFloors()
if e>=o then
return true
end
end
return false
end
function a.ConsumeAllJin(e)
local t=e:GetBuffData()
local t=t[5]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
function a.AddBuffImmune(e,t)
local o=t[9]
local t=t[10]
local a={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,t,a)
end
function a.AddBuffJinCourage(e,i)
local t=e:GetBuffData()
local o=t[11]
local n=t[12]
local a={}
for e=13,18 do
table.insert(a,t[e])
end
local t=302108913
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
for e=8,10 do
table.insert(a,t[e])
end
end
i:AddBuff(e.CurrHeroCtrl,o,n,a)
end
function a.AddPursuitAttack(e,t,o)
local a=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
if t>0 then
local e={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
insertLevel=ETriggerSkillInsertLevel.ComboAttack,
cfgArgs=o,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
s:AddTriggerAttackTask(a,t,e,o)
end
end
end
return o

