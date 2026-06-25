local e={}
local r=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
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
function e.DoActionSmallSkill(t)
local e=t:GetBuffData()
t.CurrHeroCtrl:AddFuryWithBuff(e[1])
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local a=RandomTableWithSeed(a,e[2])
local a=a[1]
if a then
local o=a.HeroBattleInfo:GetMaxHP()
local e=math.floor(o*e[3]*MillionCoe)
a:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local s=e[4]
local h=e[5]
local o={e[6],e[7]}
local i=e[8]
local n=e[9]
local r={e[10],e[11]}
for e=1,#a do
a[e]:AddBuff(t.CurrHeroCtrl,s,h,o)
a[e]:AddBuff(t.CurrHeroCtrl,i,n,r)
end
end
return r

