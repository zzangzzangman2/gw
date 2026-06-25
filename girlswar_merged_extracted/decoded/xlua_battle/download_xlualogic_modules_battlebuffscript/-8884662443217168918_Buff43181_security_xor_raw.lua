local o=require("DataNode/DataManager/DataMgr/DataUtil")
local i={}
local s=i
function i.GetCanAdd(e,e)
return true
end
function i.DoAction(t,e,i,i,a,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffHeroId~=t.CurrHeroCtrl.HeroId then
return
end
local n=a.addBuffId
local a=o:GetBuffCfg(n)
if a~=nil and a.isGran==1 and a.canDispel>=1 then
local o=0
local a=nil
local i=e[1]
for e=1,#i do
local e=i[e]
o=o+e[2]
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e[1])
end
end
if o>=RandomMgr:GetBattleRandom()then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Dispel)
local o=RandomMgr:GetBattleRandomWithRange(1,4)
if o==1 then
t.CurrHeroCtrl:AddBuff(a,e[3],e[6],{e[4],e[5]})
elseif o==2 then
t.CurrHeroCtrl:AddBuff(a,e[7],e[10],{e[8],e[9]})
elseif o==3 then
t.CurrHeroCtrl:AddBuff(a,e[11],e[14],{e[12],e[13]})
elseif o==4 then
t.CurrHeroCtrl:AddBuff(a,e[15],e[18],{e[16],e[17]})
elseif o==5 then
t.CurrHeroCtrl:AddBuff(a,e[19],e[20],{})
end
end
end
end
function i.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function i.SetLogicData(e,e)
end
return s

