local i=require("Modules/Battle/BattleUtil")
local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,h,o,a,s)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if s.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local r=e.CurrHeroCtrl.HeroId
if r==o.HeroId then
if i:CheckCanTriggerAttackTask(a.triggerSkillAtkType)==false then
return
end
local o=h.HeroId
local n=1046399
local s={
realHurt=t[1],
defHeroIds={e.CurrHeroCtrl.HeroId},
}
local h=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(n,o)
if h==nil then
i:AddTriggerAttackTask(o,n,s,a)
end
local o=t[2]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o)
if t then
local t=t.HeroBattleInfo:GetBuff(30104604)
if t then
local t=t:GetBuffData()
local n=t[1]
local t=t[2]
if(n>=RandomMgr:GetBattleRandom())then
local s=1046102
local n={
skillHurtRate=t,
hpPer=e.CurrHeroCtrl:CurrHPPer(),
defHeroIds={e.CurrHeroCtrl.HeroId},
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(s,o)
if t==nil then
i:AddTriggerAttackTask(o,s,n,a)
else
local a=t.skillData
if a.hpPer>n.hpPer then
t.skillData=n
t.fireHeroId=e.CurrHeroCtrl.HeroId
end
end
end
end
end
elseif r==h.HeroId then
if t[5]then
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if o then
local i=t[5]*MillionCoe
local t=a.hurtValue
o:HpHealthWithBuffImmediately(t*i,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
elseif s.buffTriggerTime==BuffTriggerTime.HeroDead then
if t[3]==1 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if(a~=nil)then
for o=1,#a do
local a=a[o]
if a.HeroId~=e.CurrHeroCtrl.HeroId then
local i=e.buffId
local o=a.HeroBattleInfo:GetBuff(i)
if o==nil then
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
local o=o
if o==nil then
o=e.CurrHeroCtrl
end
local e=i
local i=t[4]
a:AddBuff(o,e,i,table.deepCopy(t))
break
end
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return d

