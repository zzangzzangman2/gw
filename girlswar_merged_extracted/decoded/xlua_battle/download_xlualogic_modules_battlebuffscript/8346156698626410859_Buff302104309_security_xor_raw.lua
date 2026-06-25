local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuffWithBuffList(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneDebuffWithBuffList(e.buffId)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ImmuneDebuff(o)
local e=o:GetBuffData()
if e[3]>=e[1]then
return false
end
e[3]=e[3]+1
local t=e[2]
local a=302104309
if e[3]>=e[1]then
for e=1,#t do
local e=t[e]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
else
for i=1,#t do
local t=t[i]
if t~=o.CurrHeroCtrl.HeroId then
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t and t.HeroBattleInfo then
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local t=t:GetBuffData()
t[3]=e[3]
end
end
end
end
end
return true
end
return n

