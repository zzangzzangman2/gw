local e={}
local s=e
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
function e.DoActionBigSkill(e,a)
local t=e:GetBuffData()
local e=e.CurrHeroCtrl:GetFinalAtk()
local t=math.min(t[2]*a,t[3])
local e=math.floor(e*t*MillionCoe)
return e
end
function e.AddSuperHelplessBuff(t,n,o)
local e=t:GetBuffData()
local a=e[4]
local i=e[5]
local e={e[6]}
local e=n:CheckAddBuff(o,t.CurrHeroCtrl,a,i,e)
if e then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(302109003,BuffRemoveType.Expire)
end
end
return s

