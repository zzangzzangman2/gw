local d=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,r,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=t[1]
local h=t[3]
local s=t[6]
if n.buffTriggerTime==BuffTriggerTime.skill2Attack then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local i=a.SearchTarget(e)
if i then
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43216)
if n then
a.AddBuffLoveInspiring(e,i)
end
local e=0
local a=i.HeroBattleInfo:GetBuff(h)
if a then
e=a:GetFloors()
end
if t[5]*e>RandomMgr:GetBattleRandom()then
local e=i.HeroBattleInfo:GetBuff(o)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.AddSmallSkillTask(e,r)
end
end
end
end
elseif n.buffTriggerTime==BuffTriggerTime.skillAttack then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local i=a.SearchTarget(e)
if i and t[6]then
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43219)
if n then
a.AddBuffLoveMusic(e,i)
end
local a=0
local e=i.HeroBattleInfo:GetBuff(s)
if e then
a=e:GetFloors()
end
if t[8]*a>RandomMgr:GetBattleRandom()then
local e=i.HeroBattleInfo:GetBuff(o)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.AddBigSkillTask(e,r)
end
end
end
end
elseif n.buffTriggerTime==BuffTriggerTime.HeroDead then
local e=a.SearchTarget(e)
if e then
e.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
e.HeroBattleInfo:RemoveBuffWithId(h,BuffRemoveType.Expire)
if s then
e.HeroBattleInfo:RemoveBuffWithId(s,BuffRemoveType.Expire)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Attack
or e==BuffTriggerTime.skillAttack
or e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.SearchTarget(e)
local t=e:GetBuffData()
local o=t[1]
local t=e.CurrHeroCtrl.CurrBattleTeam:GetAllHeros()
for a=1,#t do
local a=t[a]
local t=a.HeroBattleInfo:GetBuff(o)
if t then
local t=t:GetBuffData()
if t[1]==e.CurrHeroCtrl.HeroId then
return a
end
end
end
return nil
end
function t.SearchAndAddTarget(e)
local t=e:GetBuffData()
local o=t[1]
local n=t[2]
local s={e.CurrHeroCtrl.HeroId,0,0}
local t=a.SearchTarget(e)
if t==nil then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local a={}
for e=1,#i do
local e=i[e]
local t=e.HeroBattleInfo:GetBuff(o)
if t==nil then
table.insert(a,e)
end
end
if#a>0 then
local a=d:FindMostBigAtk(a)
if a then
t=a
t:AddBuff(e.CurrHeroCtrl,o,n,s)
end
end
end
return t
end
function t.AddBuffLoveInspiring(t,a)
local e=t:GetBuffData()
local i=e[3]
local o=e[4]
local e={}
a:AddBuff(t.CurrHeroCtrl,i,o,e)
end
function t.SearchAndAddTargetBuffLoveInspiring(e)
local t=e:GetBuffData()
local t=a.SearchAndAddTarget(e)
if t then
a.AddBuffLoveInspiring(e,t)
end
end
function t.SearchAndAddTargetBuffLoveMusice(e)
local t=e:GetBuffData()
local t=a.SearchAndAddTarget(e)
if t then
a.AddBuffLoveMusic(e,t)
a.AddBuffLoveMusicInjure(e,t)
end
end
function t.AddBuffLoveMusic(e,o)
local t=e:GetBuffData()
local a=t[6]
local t=t[7]
local i={}
o:AddBuff(e.CurrHeroCtrl,a,t,i)
end
function t.AddBuffLoveMusicInjure(t,a)
local e=t:GetBuffData()
local o=e[9]
local i=e[10]
local e={e[11],e[12]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
return a

