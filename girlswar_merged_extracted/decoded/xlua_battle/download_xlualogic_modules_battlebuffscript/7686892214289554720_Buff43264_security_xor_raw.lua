local e={}
local h=e
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
function e.Explode(e)
local t=e:GetBuffData()
local i=43261
local a=0
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
a=o:GetFloors()
end
if a>0 then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eRandom,t[2])
if(o)then
local i=t[3]
local s=t[4]
local n=e.CurrHeroCtrl:GetFinalAtk()
local t=math.floor(n*t[5]*MillionCoe)
local t={t}
for n,o in ipairs(o)do
o:AddBuff(e.CurrHeroCtrl,i,s,t,a)
end
end
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
return h

