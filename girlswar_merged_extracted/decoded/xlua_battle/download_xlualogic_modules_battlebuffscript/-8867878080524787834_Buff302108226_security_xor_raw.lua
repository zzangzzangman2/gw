local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[1]==1 then
t[1]=0
local t=302108211
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local a=e:GetBuffData()
local a=t.GetCurState(e,a)
if a==t.ELiubeiState.King then
t.EnterBattleStateFromKing(e)
end
end
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillEndBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

