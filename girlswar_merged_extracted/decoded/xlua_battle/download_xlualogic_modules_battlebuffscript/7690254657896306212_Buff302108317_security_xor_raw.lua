local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[7],t[8])
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionBigSkill(t,o)
local e=t:GetBuffData()
if(e[9]>=RandomMgr:GetBattleRandom())then
t.CurrHeroCtrl.IgnoreBlock=true
end
local a=0
local i=302108309
local i=o.HeroBattleInfo:GetBuff(i)
if(i)then
a=e[10]
else
a=e[11]
end
local i=e[12]
local e=e[13]
o:CheckAddBuff(a,t.CurrHeroCtrl,i,e,0)
end
function a.DoActionSmallSkill(a,o)
local e=a:GetBuffData()
local t=0
local i=302108309
local i=o.HeroBattleInfo:GetBuff(i)
if(i)then
t=e[14]
else
t=e[15]
end
local i=e[12]
local e=e[13]
o:CheckAddBuff(t,a.CurrHeroCtrl,i,e,0)
end
return i

