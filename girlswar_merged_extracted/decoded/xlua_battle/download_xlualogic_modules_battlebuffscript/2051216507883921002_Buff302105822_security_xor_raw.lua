local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[22],t[23])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[24],t[25])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local o=0
for t=1,#a do
local t=a[t]
if t.HeroId~=e.CurrHeroCtrl.HeroId and t:IsFullFury()then
o=o+1
end
end
local o=t[29]-o*t[30]
if o>0 then
for i=1,#a do
local n=a[i]
local i=t[26]
local a=t[27]
local t={t[28],o}
n:AddBuff(e.CurrHeroCtrl,i,a,t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionBigSkill(t)
local e=t:GetBuffData()
local n=e[1]
local i=e[2]
local a=e[3]
local o={e[4],e[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o)
local a=0
local o=302105817
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
a=e.GetfloorsFightLoss(i)
end
local i=e[6]
local o=e[7]
local a={e[8],e[9]+a*e[10]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local i=e[11]
local o=e[12]
local a={}
for o=13,20 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local a=0
local t=t.CurrHeroCtrl:GetFinalDef()
a=math.floor(t*e[21]*MillionCoe)
return n,a
end
return n

