local n=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,t,a,a,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=h.GetSkyChild(e)
if i.buffTriggerTime==BuffTriggerTime.eachRoundStart or i.buffTriggerTime==BuffTriggerTime.now then
if a==nil then
local o=n:GetHeroListByHeroAndProfession(e.CurrHeroCtrl,t[1])
local a=nil
if#o>0 then
a=n:GetHeroByFinalHighAtk(o)
else
a=e.CurrHeroCtrl
end
t[11]=a.HeroId
local o=a:GetFinalAtk()
local n=math.floor(o*t[5]*MillionCoe)
local h=t[2]
local o=t[3]
local n={t[4],n}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,h,o,n)
local o=s:GetInjureResData(a)
local o=o.defFinalInjureResRate
local n=math.floor(o*t[9])
local o=t[6]
local h=t[7]
local t={
injureId=t[8],
injureValue=n,
srcHeroId=e.CurrHeroCtrl.HeroId,
totalAttackCount=t[10],
curAttackCount=0,
curAttackInBigGround=0,
}
local r={t,{t}}
local s=303107014
local n=a.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddNewHero(n,t)
else
a:AddBuff(e.CurrHeroCtrl,o,h,r)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if i.buffTriggerTime==BuffTriggerTime.now then
a:DelayPlayBuffEffect(1,o)
else
a:DelayPlayBuffEffect(0,o)
end
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.GetSkyChild(e)
local e=e:GetBuffData()
local e=e[11]or 0
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
return e
end
return h

