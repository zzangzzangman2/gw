local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
local a=e[1]
local o=e[2]
local n={e[3]}
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if i then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,n)
local o=e[3]
local a=e[4]
local e={e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,i,t,a,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=e.CurrHeroCtrl.HeroId
if o==t.HeroId then
elseif o==a.HeroId then
if t:GetTeamId()~=a:GetTeamId()then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for t=1,#e do
local t=e[t]
if t.HeroBattleInfo then
local e=302107708
local t=t.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddNightmareEnergyWithAttack(t)
end
end
end
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

