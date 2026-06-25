local i=require("Modules/Battle/BattleUtil")
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
function e.DoFire2ActionSkill(e,o)
local a=e:GetBuffData()
local t=303112104
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffLightlessPear(e,o,a[2],a[1])
end
end
function e.OnAddBuffGrowth(a)
local e=a:GetBuffData()
if e[18]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[18]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[17]=0
end
if e[17]>=e[7]then
return
end
e[17]=e[17]+1
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.eRandom,1)
local t=t[1]
if t==nil then
return
end
local o={1,e[9],2,e[11],3,e[16]}
local o=i:GetDataByWeight(o)
if o==1 then
local e=e[8]
local e=math.floor(t.HeroBattleInfo.MaxHP*e*MillionCoe)
i:AddSepsisHp(a.CurrHeroCtrl,t,e,true,true)
elseif o==2 then
t:ReduceFuryWithBuffImmediately(e[10])
elseif o==3 then
local i=e[12]
local o=e[13]
local e={e[14],e[15]}
t:AddBuff(a.CurrHeroCtrl,i,o,e)
end
end
return n

