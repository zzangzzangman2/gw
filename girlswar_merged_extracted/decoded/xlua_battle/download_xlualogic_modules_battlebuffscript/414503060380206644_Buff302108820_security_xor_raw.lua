local e={}
local n=e
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
function e.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
local o=e[1]
local i=e[2]
local s=e[3]
local n={}
local n=a:CheckAddBuff(o,t.CurrHeroCtrl,i,s,n)
local o=e[4]
local i=e[8]
if n then
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
a.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if e then
a.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
else
local n=e[5]
local s={e[6],e[7]}
a:AddBuff(t.CurrHeroCtrl,o,n,s)
local o=e[9]
local e={e[10],e[11]}
a:AddBuff(t.CurrHeroCtrl,i,o,e)
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.selfRow)
for t=1,#e do
e[t].HeroBattleInfo:DispelAllGranBuff(false)
e[t]:SetMustSmallSkill()
end
end
return n

