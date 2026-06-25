local i=require("Modules/Battle/Formula")
local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
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
function e.DoActionSmallSkill(t,n)
local e=t:GetBuffData()
local h=e[1]
local r=e[2]
local a=i:GetInjureData(n)
local s=math.floor(a.attackFinalInjureRate*e[4])
local o=s
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n,BattleHeroType.selfColumn)
for n=1,#a do
if a[n].battleStationRow==2 then
local i=i:GetInjureData(a[n])
local i=math.floor(i.attackFinalInjureRate*e[5])
o=o+i
if i>0 then
local e={e[3],-i}
a[n]:AddBuffAfterRemove(t.CurrHeroCtrl,h,r,e)
end
break
end
end
if s>0 then
local e={e[3],-s}
n:AddBuffAfterRemove(t.CurrHeroCtrl,h,r,e)
end
if o>0 then
local a=e[6]
local i=e[2]
local e={e[3],o}
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,a,i,e)
end
local a=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[7]*MillionCoe)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
t.CurrHeroCtrl:AddFuryWithBuff(e[8])
end
return d

