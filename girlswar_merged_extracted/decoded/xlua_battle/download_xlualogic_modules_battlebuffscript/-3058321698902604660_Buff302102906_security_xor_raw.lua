local h=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[3]*MillionCoe)
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AdBuffHateRedButterfly(i,o,a)
local t=i:GetBuffData()
local e=a.furyValue or 0
local n=a.operSrcType
local a=a.isDirect
if o and type(e)=="number"and e>0 and a==true then
local a=t[4]
local n=t[5]
local s={t[6],e}
local t=o.HeroBattleInfo:GetBuff(a)
if t then
local t=t:GetBuffData()
t[2]=t[2]+e
else
o:AddBuff(i.CurrHeroCtrl,a,n,s)
end
end
end
function e.AddCharonMarkStatCount(e,o)
local a=e:GetBuffData()
a[9]=a[9]+o
if t.CheckCondition(e,a)then
t.AddPursuitAddHp(e)
end
end
function e.AddPursuitAddHp(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl:GetFinalAtk()
local o=math.floor(a*t[8]*MillionCoe)
local t=e.CurrHeroCtrl.HeroId
local a=21029102
local o={
ignoreControl=true,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
addHp=o,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
h:AddTriggerAttackTask(t,a,o,e)
end
end
function e.CheckCondition(t,e)
if e[9]>=e[7]then
return true
end
return false
end
function e.HandleOnDoAction(a,e)
if t.CheckCondition(a,e)==false then
return false
end
e[9]=e[9]-e[7]
return true
end
return t

