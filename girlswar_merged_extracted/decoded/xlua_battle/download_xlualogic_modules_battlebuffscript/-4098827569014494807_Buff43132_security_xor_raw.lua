local o=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,i,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if i[3]<=0 then
return
end
if t~=BuffRemoveType.Expire then
return
end
local a=e:GetRound()
local n=e:GetFloors()
if a<=0 or n<=0 then
return
end
local t=o:GetMatesWithBuff(e.CurrHeroCtrl,e.buffId,1)
local t=t[1]
if t==nil then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#e>0 then
t=o:FindMostBigAtk(e)
end
end
if t then
t:AddBuff(e.CurrHeroCtrl,e.buffId,a,i,n)
end
end
function t.DoAction(e,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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

