local s=require("Modules/Battle/BattleUtil")
local o={}
local a=o
local n=31111
function o.GetCanAdd(e,e)
return true
end
function o.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:SetMaxFury(t[5])
end
function o.DoAction(t,e,h,o,r,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t.CurrHeroCtrl
if i.buffTriggerTime==BuffTriggerTime.now then
o.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[1],e[2])
o.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[3],e[4])
if a.IsPvpSectionEnabled(t,e)then
if s.HasOnFieldHeroDid(o,BattleHeroType.ourAll,n)then
a.AddBuffLiuXiangHeBing(t,e,o,false)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.ourAll)
for i=1,#o do
local o=o[i]
if o.heroDid==n then
a.AddBuffLiuXiangHeBing(t,e,o,false)
end
end
end
if s.HasOnFieldHeroDid(o,BattleHeroType.enemyAll,n)then
a.AddBuffChuHanZhiZheng(t,e,o,false)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.addMyMate then
if a.IsPvpSectionEnabled(t,e)and h.heroDid==n then
a.AddBuffLiuXiangHeBing(t,e,h,true)
a.AddBuffLiuXiangHeBing(t,e,o,true)
end
elseif i.buffTriggerTime==BuffTriggerTime.addEnemy then
if a.IsPvpSectionEnabled(t,e)and h.heroDid==n then
a.AddBuffChuHanZhiZheng(t,e,o,true)
end
elseif i.buffTriggerTime==BuffTriggerTime.DoAddFury
or i.buffTriggerTime==BuffTriggerTime.DoAddFuryWithReset then
local o=r.addFuryValueIncludingOverflow
e[24]=e[24]+o
local o=math.floor(e[24]/e[7])
if o>=1 then
e[24]=e[24]-o*e[7]
a.AddBuffDestiny(t,e,o)
end
end
end
function o.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.DoAddFury
or e==BuffTriggerTime.DoAddFuryWithReset then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.IsPvpSectionEnabled(t,e)
return ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[23]==1
end
function o.CheckAddBuffDestiny(o,e,t)
if e[25]>0 then
return
end
e[25]=e[25]+1
a.AddBuffDestiny(o,e,t)
end
function o.AddBuffDestiny(e,a,o)
if o<=0 then
return
end
local e=e.CurrHeroCtrl
local t=a[8]
local n=a[9]
local i={}
for e=10,14 do
table.insert(i,a[e])
end
local a=s:GetHeroBuffFloor(e,t)
e:AddBuff(e,t,n,i,o)
local t=s:GetHeroBuffFloor(e,t)
local t=t-a
local a=303112307
local o=e.HeroBattleInfo:GetBuff(a)
if t>0 and o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.HealSepsisOnDestinyFloorAdded(o,t)
end
local a=303112313
local e=e.HeroBattleInfo:GetBuff(a)
if t>0 and e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.OnDestinyMilestone(e,t)
end
end
function o.AddBuffLiuXiangHeBing(n,e,a,o)
local t=e[15]
local i=e[16]
local e={e[17],e[18]}
if o and a.HeroBattleInfo:GetBuff(t)~=nil then
return
end
a:AddBuff(n.CurrHeroCtrl,t,i,e)
end
function o.AddBuffChuHanZhiZheng(i,e,t,o)
local a=e[19]
local n=e[20]
local e={e[21],e[22]}
if o and t.HeroBattleInfo:GetBuff(a)~=nil then
return
end
t:AddBuff(i.CurrHeroCtrl,a,n,e)
end
return a

