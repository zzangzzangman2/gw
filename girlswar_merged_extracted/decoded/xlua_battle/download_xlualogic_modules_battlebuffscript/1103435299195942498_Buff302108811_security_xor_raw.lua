local a=require("Modules/BattleSkillScript/21088/Skill21088Util")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,t)
a.RemoveMatesMusicBuff(e.CurrHeroCtrl)
end
function t.DoAction(e,o,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
if a.IsMusicHero(e.CurrHeroCtrl)then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
e:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
end
elseif t.buffTriggerTime==BuffTriggerTime.teamHeroDead
or t.buffTriggerTime==BuffTriggerTime.addMyMate then
local t=o[1]
local o=0
local i=t[21]
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
o=t[23]
end
a.AddMusicBuffToMates(e.CurrHeroCtrl,t,o)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.addMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

