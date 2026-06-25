local a={}
local l=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i)
local a=t[5]
local i=t[6]
local o={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,o)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[17],t[18])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[19],t[20])
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoBeansActionSmallSkill(t,r)
local e=t:GetBuffData()
local h={}
local i={}
local l=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(303101511)
local u=e[11]
local o=e[12]
local s=e[13]
local n={e[14],e[15],e[16]}
local e=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#a do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(o)
if t then
i[e.HeroId]=true
end
end
local d=#r
for a=1,d do
local a=r[a]
local t=a:CheckAddBuff(u,t.CurrHeroCtrl,o,s,n)
if t then
if l then
local e=a.HeroBattleInfo:GetBuff(303101501)
if e then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t]
h[e.HeroId]=true
end
end
end
if i[a.HeroId]==true then
e=e+1
end
end
end
for r=1,#a do
local a=a[r]
if h[a.HeroId]then
local t=a:AddBuff(t.CurrHeroCtrl,o,s,n)
if t then
if i[a.HeroId]==true then
e=e+1
end
end
end
end
return e
end
return l

