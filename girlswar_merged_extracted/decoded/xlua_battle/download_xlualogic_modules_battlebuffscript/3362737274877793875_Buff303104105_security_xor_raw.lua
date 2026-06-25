local e={}
local d=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[11])
if t==nil then
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(303104103)
local e=e:GetBuffData()
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckHasEnemyLessHp(e)
local a=e:GetBuffData()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for t=1,#e do
if e[t]:CurrHPPer()<=a[1]*MillionCoe then
return true
end
end
return false
end
function e.DoActionAllSkill(t,n)
local e=t:GetBuffData()
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[11])
if a==nil then
return
end
local a=e[6]
local o=e[9]
local h=e[10]
local i=303104108
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
local e=i:GetBuffData()
a=e[18]
o=e[19]
h=e[20]
end
local r=e[7]
local i=e[8]
local e=303104113
local s=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
local e={}
if(s)then
e=s:GetBuffData()
i=e[1]
end
local s=#n
for s=1,s do
local n=n[s]
if a>=RandomMgr:GetBattleRandom()then
local a={math.floor(t.CurrHeroCtrl:GetFinalAtk()*o*MillionCoe),h}
for t=2,7 do
table.insert(a,e[t])
end
n:AddBuff(t.CurrHeroCtrl,r,i,a)
end
end
end
function e.CheckChangeGod(e,a)
local t=e:GetBuffData()
if a>=t[2]then
local a=t[11]
local t=t[12]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
end
end
return d

