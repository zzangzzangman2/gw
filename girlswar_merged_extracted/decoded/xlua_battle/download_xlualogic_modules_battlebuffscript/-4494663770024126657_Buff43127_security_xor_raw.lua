local n=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=nil
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eWithoutBuff,nil,nil,e[2])
if#o>0 then
local e=n:GetMinHpPercentHeroArr(o,1)
a=e[1]
else
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eMinHpPercent)
end
if a then
local o=e[1]
local n=e[2]
local i=e[3]
local e={e[4],e[5],e[6],e[7],e[8],e[9]}
a:CheckAddBuff(o,t.CurrHeroCtrl,n,i,e)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

