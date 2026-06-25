local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl.HeroBattleInfo:GetCurrFury()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#a>0 then
local a=o*#a*t[1]*MillionCoe
local i=t[2]
local n=t[3]
local o=math.floor(a*t[5])
local o={t[4],o}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,o)
local i=t[6]
local o=t[7]
local a=math.floor(a*t[9])
local t={t[8],a}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

