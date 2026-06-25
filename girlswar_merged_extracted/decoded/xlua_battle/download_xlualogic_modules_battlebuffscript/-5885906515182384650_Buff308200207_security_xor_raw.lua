local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[7]==1 then
t[7]=0
local a=o.HeroBattleInfo:GetBuff(308200205)
if a then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[1]
a.value=t[2]
n.HeroBattleInfo:AddTempBuffValue(a)
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or t[6]==1 then
i.AddFireDamage(e,t,o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.fHollow)
for o=1,#a do
local a=a[o]
i.AddFireDamage(e,t,a)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack
or e==BuffTriggerTime.skill2Attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddFireDamage(i,e,a)
local o=e[3]
local n=e[4]
local s={e[5],1}
local t=a.HeroBattleInfo:GetBuff(o)
if t then
local t=t:GetBuffData()
if t[2]==1 then
t[1]=t[1]+e[5]
else
t[1]=e[5]
t[2]=1
end
else
a:AddBuff(i.CurrHeroCtrl,o,n,s)
end
a.isTriggerSkillEndBuff=true
end
return i

