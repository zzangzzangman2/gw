local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local o=t[2]
local i=t[3]
if a then
e.CurrHeroCtrl.HurtNumType=EBattleHurtNumType.ChangeGui
e.CurrHeroCtrl:RealHurtShow(a,o,i)
e.CurrHeroCtrl.isTriggerSkillEndBuff=false
t[1]=nil
t[2]=nil
t[3]=nil
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillEndBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

