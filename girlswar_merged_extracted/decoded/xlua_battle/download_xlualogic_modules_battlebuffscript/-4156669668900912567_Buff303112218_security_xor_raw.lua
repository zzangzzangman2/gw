local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skill2Play then
t[2]=0
elseif a.buffTriggerTime==BuffTriggerTime.skill2Attack then
if t[2]==nil then
return
end
if t[2]>=1 then
return
end
if o==nil then
return
end
local a=e:GetFloors()
ModulesInit.ProcedureNormalBattle.StealFury(e.CurrHeroCtrl,o,t[1]*a,EBattleSrcType.SkillSmall,true)
t[2]=t[2]+1
end
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill2Attack then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

