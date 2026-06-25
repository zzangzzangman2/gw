local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if(a==nil or#a<=0)then
return
end
local o=a[1]
local a=a[2]
if(o==t[1])then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eFront)
if(a~=nil)then
local o=#a
for o=1,o do
local a=a[o]
a:ReduceFuryWithSkillImmediately(t[2],ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId),EBattleSrcType.Buff,false)
end
end
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local a=t[3]
local o=t[4]
local t={t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
e.isExec=true
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

