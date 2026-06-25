local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionBigSkill(t)
local e=t:GetBuffData()
local i=e[1]
local a=false
local a=303110703
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if t.isMaxGodMusic(o)then
i=e[2]
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local o=303110709
for t=1,#a do
if i>=RandomMgr:GetBattleRandom()then
if a[t].HeroBattleInfo:GetBuff(o)then
a[t]:ReduceFuryWithBuffImmediately(e[3])
end
end
end
local o=e[4]
local a=e[5]
local i={e[6],e[7]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=e[8]
local o=e[9]
local e={e[10],e[11]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return n

