local t={}
local r=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function t.GetCanTrigger(e)
return false
end
function t.SetLogicData(e,e)
end
function t.AddNightmareEnergy(e,r)
local t=e:GetBuffData()
local a=t[2]
local s=t[3]
local h={t[4],t[5]}
local i=t[6]
local o=0
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if n then
o=n:GetFloors()
end
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,a,s,h,r,i)
if o<i then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetFloors()
local o=a-o
if o>0 then
e.CurrHeroCtrl:AddFuryWithBuff(t[8])
end
if a>=i then
local a=e.CurrHeroCtrl:GetFinalAtk()
local a=math.floor(a*t[1]*MillionCoe)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if(t~=nil)then
for o,t in ipairs(t)do
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
end
end
end
function t.CheckNightmareEnergyMaxFloor(t,e)
local e=t:GetBuffData()
local a=e[2]
local o=e[6]
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local e=e:GetFloors()
if e>=o then
return true
end
end
return false
end
function t.RemoveNigthmareEnergyBuff(i,e)
local t=e[2]
local a=i.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local o=0
if a then
o=a:GetFloors()
end
local e={e[4],e[5]*o}
i.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
return e
end
return r

