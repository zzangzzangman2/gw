local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,n,i,a,s,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=e.CurrHeroCtrl.HeroId
if t==i.HeroId then
elseif t==a.HeroId then
local a=n[4]
local t=302108709
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(t)then
local e=t:GetBuffData()
a=e[3]
end
if a>=RandomMgr:GetBattleRandom()then
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
o:AddTriggerAttackTask(a,t,i,s)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffBloodFury(e)
local t=e:GetBuffData()
local a=t[9]
local i=t[10]
local o={t[11],t[12]}
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t==nil then
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,o)
end
end
function t.AddBuffBlood(t,a)
local e=t:GetBuffData()
local s=e[9]
local o=t.CurrHeroCtrl:GetFinalAtk()
local n=math.floor(o*e[7]*MillionCoe)
local o=e[5]
local r=e[6]
local h={n}
local n=1
local s=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(s)
if s then
n=e[13]
end
a:AddBuff(t.CurrHeroCtrl,o,r,h,n)
if a.HeroBattleInfo then
local a=a.HeroBattleInfo:GetBuff(o)
if a then
local a=a:GetFloors()
if a>=e[8]then
i.AddBuffBloodFury(t)
end
end
end
end
return i

