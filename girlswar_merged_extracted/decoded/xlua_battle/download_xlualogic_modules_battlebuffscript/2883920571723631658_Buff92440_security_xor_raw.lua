local s=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,r,u)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[1]>=RandomMgr:GetBattleRandom()then
local o=t[3]
local d=t[4]
local l={}
local h=t[2]
local n=0
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
n=i:GetFloors()
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,d,l,h)
local i=0
local h=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if h then
i=h:GetFloors()
end
if i>n then
a.TriggerEffect(e,t,e.CurrHeroCtrl,1)
end
if i>=t[13]then
local a=e.CurrHeroCtrl.HeroId
local i=1919101
local n={
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
skillParam=t
}
if u.buffTriggerTime==BuffTriggerTime.eachRoundStart then
r={triggerSkillAtkType=ETriggerSkillAtkType.Normal}
end
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,a)
if t==nil then
s:AddTriggerAttackTask(a,i,n,r)
end
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.TriggerEffectMate(e,o)
local t=e:GetBuffData()
a.TriggerEffect(e,t,o,t[14])
end
function t.TriggerEffect(i,o,t,e)
local n={1,2,3}
local n=RandomTableWithSeed(n,1)
local n=n[1]
if n==1 then
a.TriggerEffect1(i,o,t,e)
elseif n==2 then
a.TriggerEffect2(i,o,t,e)
else
a.TriggerEffect3(i,o,t,e)
end
end
function t.TriggerEffect1(e,t,a,i)
local o=a.HeroBattleInfo.MaxHP
local n=math.floor(o*t[5]*i*MillionCoe)
a:HpHealthWithBuffImmediately(n,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local t=math.floor(o*t[6]*i*MillionCoe)
s:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
end
function t.TriggerEffect2(o,e,a,t)
local i=e[7]
local n=e[8]
local e={e[9],e[10]}
a:AddBuff(o.CurrHeroCtrl,i,n,e,t)
end
function t.TriggerEffect3(o,e,i,a)
local t=e[11]
local n=e[12]
local e={}
i:AddBuff(o.CurrHeroCtrl,t,n,e,a)
end
return a

