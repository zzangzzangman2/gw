local n=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,h,s,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=e.CurrHeroCtrl.HeroId
if o==i.HeroId then
elseif o==h.HeroId then
if a.CheckCondition(e,t)then
local t=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.BigSkillId
local e={
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if o==nil then
n:AddTriggerAttackTask(t,a,e,s)
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[3]*MillionCoe)
elseif o.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if i.HeroId~=e.CurrHeroCtrl.HeroId then
if a.CheckCondition(e)==false then
local o=t[24]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if t then
local i=t:GetFloors()
t:ReduceFloors(1)
if i<=1 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
a.GainSnowMan(e,1)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.FrozenEnemy(t)
local e=t:GetBuffData()
e[26]=e[26]+1
a.GainSnowMan(t,e[6])
end
function t.GainSnowMan(t,s)
local e=t:GetBuffData()
local o=e[4]
local h=e[5]
local r={}
local a=e[7]
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
local i=0
if n then
i=n:GetFloors()
end
if i<a then
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,o,h,r,s,a)
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
local i=0
if o then
i=o:GetFloors()
end
if i>=a then
local o=e[8]
local a=e[9]
local e={e[10],e[11]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
end
function t.GetFrozenCount(e)
local e=e:GetBuffData()
return e[26]
end
function t.AddSnowFrozenBuff(t,n)
local e=t:GetBuffData()
local o=e[14]
local i=e[15]
local a={}
for t=16,23 do
table.insert(a,e[t])
end
n:AddBuff(t.CurrHeroCtrl,o,i,a)
end
function t.DoActionFightBackOnSelf(e)
local t=e:GetBuffData()
local t=t[4]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
end
function t.DoActionFightBack(e,t)
local o=e:GetBuffData()
local i=t.HeroBattleInfo.MaxHP*o[12]*MillionCoe
local n=o[13]
local o=o[14]
if s:CalculateCtrlSuccess(o,n,e.CurrHeroCtrl,t)then
a.AddSnowFrozenBuff(e,t)
end
return i
end
function t.GainSnowBall(e,i)
local t=e:GetBuffData()
local a=t[24]
local o=t[25]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t,i)
end
function t.CheckCondition(t)
local e=t:GetBuffData()
local a=e[4]
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local t=0
if a then
t=a:GetFloors()
end
if t>=e[7]then
return true
end
return false
end
function t.HandleOnDoAction(e,t)
if a.CheckCondition(e)==false then
return false
end
return true
end
return a

