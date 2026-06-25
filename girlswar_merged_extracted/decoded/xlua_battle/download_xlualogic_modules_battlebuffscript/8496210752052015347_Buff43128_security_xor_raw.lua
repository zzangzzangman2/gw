local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e,e)
end
function t.OnRemoveSelf(t,e,a)
if t==nil or t.CurrHeroCtrl==nil then
return
end
local a=e[3]
local i=e[4]
local o={e[5],e[6]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fHollow)
if e then
for n=1,#e do
local e=e[n]
e:AddBuff(t.CurrHeroCtrl,a,i,o)
end
end
end
function t.DoAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
e.isExec=true
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s 
