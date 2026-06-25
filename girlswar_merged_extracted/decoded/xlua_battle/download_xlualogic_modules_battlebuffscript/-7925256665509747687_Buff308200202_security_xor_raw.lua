local i=require("Modules/Battle/BattleUtil")
local t={}
local a=t
local o=require('Modules/BattleBuffScript/BuffResurgenceMgr')
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,a,i)
o.DoResurgence(t,e,a,i)
end
function t.DoResurgence(e,t,o,o)
local s=t[1]
local n=t[2]
local o={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,s,n,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:HideHero()
if a.CheckBaseCondition(e)then
local e=t[6]
local t=t[5]
local o={
buffId=308200201,
triggerSkillAtkType=ETriggerSkillAtkType.HelpMate,
defHeroIds={}
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,e)
if a==nil then
local a={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
i:AddTriggerAttackTask(e,t,o,a)
end
end
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.DyingState
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.fatalDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function t.CheckBaseCondition(e)
local t=e:GetBuffData()
local t=t[1]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
return true
end
return false
end
function t.HandleOnDoAction(e,t)
if a.CheckBaseCondition(e)==false then
return false
end
return true
end
return a

