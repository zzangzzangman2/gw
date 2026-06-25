local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
if#t>=4 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
elseif a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if(o.HeroId==e.CurrHeroCtrl.HeroId)then
if(t[5]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl:AddFuryWithBuff(t[6])
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

