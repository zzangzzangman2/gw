local n=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,i,s,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
elseif o.buffTriggerTime==BuffTriggerTime.evade then
if a==nil or i==nil then
return
end
t.CurrHeroCtrl.HeroBattleInfo:ReduceBuffValue(t.buffId,e[1],e[3],nil,0)
if e[15]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[15]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[14]=0
end
e[14]=e[14]or 0
if e[14]>=e[9]then
return
end
e[14]=e[14]+1
local o=a:GetFinalAtk()
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=nil
if#i>0 then
local e,t=n:FindMostBigAtk(i)
o=t
a=e
end
if a then
local o=math.floor(o*e[4]*MillionCoe)
local n=e[5]
local s=e[6]
local i={HeroAttrId.atkAdd,o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,s,i)
local i=e[7]
local e=e[8]
local o={HeroAttrId.atkAdd,-o}
a:AddBuff(t.CurrHeroCtrl,i,e,o)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.eMinHpPercentWithCount)
local a=a[1]
if a then
local o=t.CurrHeroCtrl:GetFinalAtk()
local e=math.floor(o*e[10]*MillionCoe)
a:RealHurtWithBuff(e,t)
end
if(e[11]>=RandomMgr:GetBattleRandom())then
t.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,e[12])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.evade)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

