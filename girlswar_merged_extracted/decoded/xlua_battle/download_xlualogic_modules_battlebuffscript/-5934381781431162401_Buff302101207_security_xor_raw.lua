local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(a,e,i,n)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e[1]
if(t>=RandomMgr:GetBattleRandom())then
local o=0
local t=302101209
local t=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(t)then
local e=t:GetBuffData()
o=e[1]
end
local t=nil
local s=302101218
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(s)
if(a)then
local e=a:GetBuffData()
t=e[1]
end
if(i.HeroBattleInfo:IsExistsSkill(21012301))then
local a=e[2]
local s=e[3]
if t==nil then
t=e[4]
end
local e={t,o}
n:AddBuff(i,a,s,e)
else
local a=e[5]
local s=e[6]
if t==nil then
t=e[7]
end
local e={t,o}
n:AddBuff(i,a,s,e)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack or e==BuffTriggerTime.skill2Attack)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

