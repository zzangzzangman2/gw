local n=require("DataNode/DataManager/DataMgr/DataUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(a,e,t,t,s,i)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=a.CurrHeroCtrl
local o=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if i.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local a=e[2]
local i={e[3],e[4]}
t:AddBuff(t,o,a,i)
local a=e[5]
local o=e[6]
local e={e[7],e[8]}
t:AddBuff(t,a,o,e)
elseif i.buffTriggerTime==BuffTriggerTime.removeBuff then
local i=s[1]
local i=n:GetBuffCfg(i)
if i.isGran~=1 then
return
end
if e[21]~=o then
e[21]=o
e[22]=0
end
if e[22]>=e[11]then
return
end
e[22]=e[22]+1
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,1)
if o==nil or#o==0 then
return
end
local o=o[1]
if o==nil then
return
end
local e=math.floor(t:GetFinalAtk()*e[10]*MillionCoe)
o:RealHurtWithBuff(e,a)
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.removeBuff then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ModifyExSkillBaseHurtRate(e)
local e=e:GetBuffData()
return e[9]
end
function t.DoBeansActionAfterExSkill(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl
local e=e:GetBuffData()
local o=e[12]
local a=e[13]
local i={e[14],e[15],e[16],e[17]}
t:AddBuff(t,o,a,i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if o==nil then
return
end
local a=nil
local i=-1
for e=1,#o do
local t=o[e]
local e=#t.HeroBattleInfo:GetGranBuff(true)
if e>i then
i=e
a=t
end
end
if a then
local o=e[18]
local i=e[19]
local e={e[20],0,0}
a:AddBuff(t,o,i,e)
end
end
return s

