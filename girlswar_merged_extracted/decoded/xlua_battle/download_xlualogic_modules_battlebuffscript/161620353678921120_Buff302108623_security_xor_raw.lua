local o=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
local a=302108610
local a,s=o:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,1)
if a then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
local o=t[1]
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*o*MillionCoe)
e.CurrHeroCtrl:HpHealthSimple(e.CurrHeroCtrl,a,EBattleSrcType.DeathImmune)
e.CurrHeroCtrl:PlayHpHealth()
local a=t[2]
e.CurrHeroCtrl:AddFuryWithBuffImmediately(a)
local n=t[3]
local i=t[4]
local a={}
for o=5,10 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,a)
end
if s<=0 then
e.isExec=true
end
else
e.isExec=true
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

