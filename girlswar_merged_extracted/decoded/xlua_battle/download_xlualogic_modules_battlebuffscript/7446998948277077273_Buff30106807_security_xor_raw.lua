local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o={}
local a={}
local i=t[1]
local s=t[2]
local n={t[3],t[4],t[5],t[6]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for n=1,#t do
local t=t[n]
if t:IsCampionLeader()and t.HeroId~=e.CurrHeroCtrl.HeroId then
if t.HeroBattleInfo:GetBuff(i)then
table.insert(a,t)
else
table.insert(o,t)
end
end
t.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
local t=nil
if#o>0 then
local e=RandomTableWithSeed(o,1)
t=e[1]
elseif#a>0 then
local e=RandomTableWithSeed(a,1)
t=e[1]
else
t=e.CurrHeroCtrl
end
t:AddBuff(e.CurrHeroCtrl,i,s,n)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

