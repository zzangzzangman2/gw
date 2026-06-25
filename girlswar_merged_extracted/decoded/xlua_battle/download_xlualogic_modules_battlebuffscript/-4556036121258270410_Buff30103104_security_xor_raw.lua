local a=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
e.CurrHeroCtrl:PlayUndeadAnimInTimeLine()
end
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
local o=t[1]
local a=t[2]
local t={t[3]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
e.CurrHeroCtrl.isExcuteInTimeLine=false
e.CurrHeroCtrl.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enterUnUsualStateBefore,nil,nil,{buffTriggerTime=BuffTriggerTime.fatalDmgBefore})
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.UnDead
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

