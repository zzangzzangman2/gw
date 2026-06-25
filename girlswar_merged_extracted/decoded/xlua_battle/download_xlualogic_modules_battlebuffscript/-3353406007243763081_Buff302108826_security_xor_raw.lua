local e=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)==false then
return
end
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
e.CurrHeroCtrl.HeroBattleInfo:SetHp(1,true)
end
if ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true then
e.CurrHeroCtrl:CheckPlayUndead2AnimInTimeLine(false)
end
local i=t[1]
local o=t[2]
local t={t[3],t[4],t[5]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,t)
e.CurrHeroCtrl.isExcuteInTimeLine=false
e.CurrHeroCtrl.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enterUnUsualStateBefore,nil,nil,{buffTriggerTime=a.buffTriggerTime})
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.UnDead
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.buffDamageComplete
or e==BuffTriggerTime.skillEndBuff
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

