local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a.hurtValue
if a>0 then
if t.CurrHeroCtrl:IsOnAttack()then
return
end
if e[13]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[13]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[12]=0
end
local o=e[11]
e[12]=e[12]or 0
if(e[12]>=o)then
return nil
end
local o=t.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local o=o+a
if o>0 then
local a=a/o
if a>e[1]*MillionCoe then
local o=e[2]
local i=e[3]
local a={}
for t=4,10 do
table.insert(a,e[t])
end
e[12]=e[12]+1
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,a)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.afterSufferDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

