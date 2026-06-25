local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[5]*MillionCoe)
end
function a.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(e[5]*MillionCoe)
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=t[1]
local a=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,t)
o.GeneratePerseusAbility(e)
elseif a.buffTriggerTime==BuffTriggerTime.resurgenceBefore then
o.GeneratePerseusAbility(e)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local i=303110603
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
for i=1,#o do
e.AddBuffBloodThorn(a,o[i],t[8],t[9])
end
e.GenerateSwordPerseus(a,t[10])
end
e.CurrHeroCtrl:ClearSepsisHpDirect(true)
local a=t[11]
local i=t[12]
local t={t[13],t[14]+t[15]*#o}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.resurgenceBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GeneratePerseusAbility(e)
local a=e:GetBuffData()
local t=303110603
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.GeneratePowerPerseus(e,a[6],0)
t.GenerateSwordPerseus(e,a[7])
end
end
return o

