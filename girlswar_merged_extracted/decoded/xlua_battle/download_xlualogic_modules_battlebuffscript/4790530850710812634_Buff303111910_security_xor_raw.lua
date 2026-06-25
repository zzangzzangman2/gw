local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill1(e,t)
local a=e:GetBuffData()
ModulesInit.ProcedureNormalBattle.StealFury(e.CurrHeroCtrl,t,a[1],EBattleSrcType.SkillSmall,true)
end
function e.DoActionSmallSkill2(e,t)
local t=e:GetBuffData()
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[2]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
return o

