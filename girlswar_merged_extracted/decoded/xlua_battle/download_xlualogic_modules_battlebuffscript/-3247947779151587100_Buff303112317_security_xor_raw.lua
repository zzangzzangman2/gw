local o=require("Modules/Battle/BattleUtil")
local s=require("DataNode/DataManager/DataMgr/DataUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneBuffWithBuffList(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneBuffWithBuffList(e.buffId)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ImmuneBuff(t,a,n)
local e=t:GetBuffData()
local i=ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound
if e[2]~=i then
e[2]=i
e[3]=0
end
if e[3]>=e[1]then
return false
end
e[3]=e[3]+1
local e=s:GetBuffCfg(a.buffId)
if o:IsCanStealBuff(e)==false then
return true
end
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t.releaseHeroId)
if e==nil then
return true
end
o:AddBuffWithBuffCopy(e,n,a,{
buffAddType=EBuffAddType.FightBack,
buffTriggerAddType=EBuffAddType.FightBack,
})
return true
end
return n

