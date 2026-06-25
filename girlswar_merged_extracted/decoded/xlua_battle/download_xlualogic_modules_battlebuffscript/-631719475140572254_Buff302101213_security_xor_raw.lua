local o=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,s,n,h,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
i.ResetAttr(e)
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=e.CurrHeroCtrl.HeroId
if a==s.HeroId then
elseif a==n.HeroId then
local a=t[1]
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,t[13])
local a=t[5]
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,t[13])
local a=t[9]
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,t[13])
end
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play then
local o=t[14]
local a=t[15]
local i={t[16],t[17]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,i)
local a=t[18]
local t=302101211
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddFlower(e,a)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skill3Play)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.ResetAttr(t)
local e=t:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=#a
local n=e[1]
local i=e[2]
local o={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,o,a)
local n=e[5]
local i=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,o,a)
local o=e[9]
local i=e[10]
local e={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
return i

