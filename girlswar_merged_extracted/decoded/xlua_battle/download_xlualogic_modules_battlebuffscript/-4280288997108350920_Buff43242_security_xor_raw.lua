local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
local r={43232,43235,43236,43239}
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,a,h,s,n,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.after then
local t=o.GetBuffPotionList(e)
o.AddBuffPotion(e,t,a[1])
elseif t.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or t.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or t.buffTriggerTime==BuffTriggerTime.allSkillAttack then
local s=n.triggerSkillAtkType
if h.IsOurHero==e.CurrHeroCtrl.IsOurHero and i:IsDependAtkType(s)==false then
local a=a[2]
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43243)
if s and(t.buffTriggerTime==BuffTriggerTime.allSkillAttack or i:IsNormalSkillAtkType(n.triggerSkillAtkType)==false)then
local e=s:GetBuffData()
a=e[1]
end
o.AddBuffMaterial(e,a)
end
elseif t.buffTriggerTime==BuffTriggerTime.attack then
local o=43233
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if t then
local t=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroTable()
local t=RandomTableWithSeed(t,1)
local t=t[1]
if t and t.IsOurHero~=e.CurrHeroCtrl.IsOurHero then
local i=1
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43243)
if n then
local e=n:GetBuffData()
i=e[2]
end
local h=a[8]
local s=a[9]
local n={}
local a=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a[10]*i*MillionCoe)
table.insert(n,a)
t:AddBuff(e.CurrHeroCtrl,h,s,n)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.after
or e==BuffTriggerTime.attack
or e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffMaterial(e,l)
local h=e:GetBuffData()
local a=43241
local d=-1
local r={}
local n=o.GetBuffPotionList(e)
local i=#n
if i>0 then
local t=0
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if s then
t=s:GetFloors()
end
local s=t+l
local t=math.floor(s/h[3])
if t>0 then
o.AddBuffPotion(e,n,t)
end
if t>=i then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
else
local t=s-t*h[3]
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,a,d,r,t)
end
else
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
function a.GetBuffPotionList(t)
local e={43232,43235,43236}
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43243)
if a then
table.insert(e,43239)
end
local o={}
local i
for a=1,#e do
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[a])
if t==nil then
table.insert(o,e[a])
end
end
return o,i
end
function a.AddBuffPotion(e,o,n)
local t=e:GetBuffData()
local a=1
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43243)
if i then
local e=i:GetBuffData()
a=e[2]
end
local o=RandomTableWithSeed(o,n)
for n=1,#o do
local o=o[n]
if o==43232 then
local i=t[4]
local o=t[5]
local a={}
for o=6,7 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
elseif o==43235 then
local i=t[11]
local n=t[12]
local o={}
for e=13,14 do
table.insert(o,t[e])
end
table.insert(o,a)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,o)
elseif o==43236 then
local i=t[15]
local n=t[16]
local o={}
for e=17,20 do
table.insert(o,t[e])
end
table.insert(o,a)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,o)
elseif o==43239 then
if i then
local o=i:GetBuffData()
local i=o[3]
local n=o[4]
local t={}
for e=5,13 do
table.insert(t,o[e])
end
table.insert(t,a)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,t)
end
end
end
end
function a.UseAllPotion(e,t,t)
local o=false
for t=1,#r do
local t=r[t]
if e.CurrHeroCtrl then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(t)
i.UsePotion(a)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
o=true
end
end
end
if(o and ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle2510UnderwearUsePotionEffect,e.x,e.y,50,3,0,false,function()
end)
end
end
return o

