local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,t,a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e.isExec==true then
return
end
e.isExec=true
if#t>=3 then
local o=t[2]
local a=t[3]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=t[1]*MillionCoe
local t=math.floor(a*t)
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,HeroAttrId.shield,t)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

