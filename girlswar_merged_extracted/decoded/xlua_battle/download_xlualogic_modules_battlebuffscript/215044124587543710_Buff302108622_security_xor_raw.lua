local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4])
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoLimitAction(e,t,a)
local t=e:GetBuffData()
local a=o:GetSkillActData(a)
if a.type==EBattleSkillType.SkillBig then
local a=t[5]
local o=t[6]
local t=t[7]
local t=e.CurrHeroCtrl:CheckAddBuff(a,e.CurrHeroCtrl,o,t,0)
if t then
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleAllBuffEffect()
end
end
return t
end
return false
end
return i

