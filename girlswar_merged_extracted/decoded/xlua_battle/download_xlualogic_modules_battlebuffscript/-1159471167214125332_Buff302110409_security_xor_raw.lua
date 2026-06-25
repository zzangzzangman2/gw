local s=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[3]*MillionCoe)
a.GetWineBibberBuff(e,t[13],{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
local o=302110405
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local a=a:GetBuffData()
o.GetWineFumeBuff(e,a,1000000,t[20],false)
end
elseif o.buffTriggerTime==BuffTriggerTime.HeroDead then
local o=t[6]
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local a=a:GetFloors()
if a>0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for i=1,#o do
local o=o[i]
local t=a*t[19]*MillionCoe
local t=o.HeroBattleInfo.MaxHP*t
o:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWineBibberBuffOneFloor(e,o)
local t=e:GetBuffData()
a.GetWineBibberBuff(e,t[5],o)
end
function t.GetWineBibberBuff(t,r,h)
local e=t:GetBuffData()
local a=e[6]
local o=e[7]
local n={e[8],e[9],e[10],e[11]}
local i=e[12]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,a,o,n,r,i)
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local o=0
if a then
o=a:GetFloors()
end
if o>=i then
local a=t.CurrHeroCtrl.HeroId
local o=21104102
local t={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
cfgArgs={e[14],e[15],e[16],e[17],e[18]},
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,a)
if e==nil then
s:AddTriggerAttackTask(a,o,t,h)
end
end
end
function t.HandleOnDoAction(a,e,t)
local t=e[6]
local t=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetFloors()
local e=e[12]
if t>=e then
return true
end
end
return false
end
return a

