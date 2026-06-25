local n=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[22],e[23])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[24],e[25])
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
local a=e[26]or{}
for o=1,#a do
local a=a[o]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a and a:IsNothingToDoState()==false and a:CheckHeroCanDoAction()then
local o=0
if(e[8]>=RandomMgr:GetBattleRandom())then
o=1
end
local i=e[6]
local n=e[7]
local e={o,e[3],e[4],e[5]}
a:AddBuff(t.CurrHeroCtrl,i,n,e)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionBigSkill1(t,a)
local e=t:GetBuffData()
local n=e[1]
local s=e[2]
local o={}
for t=3,8 do
table.insert(o,e[t])
end
e[26]={}
for i=1,#a do
local a=a[i]
table.insert(e[26],a.HeroId)
a:AddBuff(t.CurrHeroCtrl,n,s,o)
end
local a=e[10]
local o=e[11]
local i={e[12],e[13]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i)
local a=e[14]
local o=e[15]
local i={e[16],e[17]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i)
local o=e[18]
local a=e[19]
local e={e[20],e[21]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
function a.DoActionBigSkill2(t,e,o)
if e==nil or e.HeroBattleInfo==nil or e.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t:GetBuffData()
local a=a[9]
if a>0 then
local a=math.floor(o*a*MillionCoe)
n:AddSepsisHp(t.CurrHeroCtrl,e,a)
end
end
return h

