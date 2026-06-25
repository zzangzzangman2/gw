local o=require("Modules/BattleSkillScript/21088/Skill21088Util")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=t[3]
local a=t[1]
local i=e.CurrHeroCtrl:GetTeamBuff(302108817)
if i then
a=a+t[2]
end
o.AddMultiMusicBuff(e.CurrHeroCtrl,n,a)
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

