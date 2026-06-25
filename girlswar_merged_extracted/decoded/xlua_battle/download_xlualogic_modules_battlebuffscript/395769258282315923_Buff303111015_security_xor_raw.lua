local n=require("Modules/Battle/BattleUtil")
local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,h,a,s,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
local a=e[1]
local n=e[2]
local o={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,n,o)
local a=e[5]
local n=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,n,o)
i.AddBuffPuti(t,e[9])
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart
or o.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if n.IsBigRoundStart(o.buffTriggerTime,t.CurrHeroCtrl)then
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>t.CurrHeroCtrl.appearBattleBigRound then
local a=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-t.CurrHeroCtrl.appearBattleBigRound
if a%2==0 then
i.AddBuffPuti(t,e[10])
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if a.IsOurHero==t.CurrHeroCtrl.IsOurHero then
e[21]=e[21]+1
if e[21]>=e[18]then
e[21]=0
t.CurrHeroCtrl:AddFuryWithBuff(e[19])
end
local o=e[11]
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
local i=s.reduceHpValue
if i>=a.HeroBattleInfo.CurrHP then
if e[20][a.HeroId]and e[20][a.HeroId]>=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
n:ReduceHeroBuffFloor(t.CurrHeroCtrl,o,1)
e[20][a.HeroId]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local n=e[13]
local i=e[14]
local o=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*e[15]*MillionCoe)
local o={HeroAttrId.shield,o}
a:AddBuff(t.CurrHeroCtrl,n,i,o)
local o=a.HeroBattleInfo.MaxHP
local o=math.floor(o*e[16]*MillionCoe)
a:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
a:AddFuryWithBuff(e[17])
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart
or e==BuffTriggerTime.anyHeroSkillBeAttack)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.AddBuffPuti(t,a)
local e=t:GetBuffData()
local o=e[22]
if e[23]>=o then
return
end
e[23]=e[23]+1
local o=e[11]
local i=e[12]
local e={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
return i

