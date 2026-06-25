local e={}
local n=e
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
function e.DoActionSmallSkill(t,e)
local e=t:GetBuffData()
local a=t.CurrHeroCtrl.CurrBattleTeam:GetFrontOrBackHeros(true)
for o=1,#a do
local a=a[o]
local o=e[1]
local i=e[2]
local e={e[3],e[4]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
local a=302108905
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.GainJinBuff(t,e[5])
end
local t=false
if(e[6]>=RandomMgr:GetBattleRandom())then
t=true
end
return t
end
return n

