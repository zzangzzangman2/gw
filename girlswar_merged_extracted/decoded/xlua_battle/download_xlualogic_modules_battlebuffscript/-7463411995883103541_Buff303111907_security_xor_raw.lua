local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,h,s,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
o.AddBuffKing(t,e[5])
elseif a.buffTriggerTime==BuffTriggerTime.allNormalSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack
or a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
local a=s.triggerSkillAtkType
if n.IsOurHero~=t.CurrHeroCtrl.IsOurHero and i:IsDependAtkType(a)==false then
e[19]=e[19]+1
if e[19]>=e[12]then
e[19]=0
o.AddBuffKing(t,e[13])
end
end
elseif a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fMinHpPercentWithCount)
if#a>0 then
local a=a[1]
local i=e[14]
local o=e[15]
local n=t.CurrHeroCtrl:GetFinalAtk()
local e=math.floor(n*e[16]*MillionCoe)
local e={e}
a:AddBuff(t.CurrHeroCtrl,i,o,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffKing(t,n)
local e=t:GetBuffData()
local s=e[6]
local i=e[7]
local a={}
for o=8,11 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,s,i,a,n)
end
function a.AddBuffLiquidation(e,a,s)
local t=e:GetBuffData()
local h=t[17]
local n=t[18]
local o={}
local t=303111922
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(t)then
local i=t:GetBuffData()
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local t=t-1
local t=a:GetTotalDamageInBigRound(t,EBattleTurnType.OurTurn)
local t=math.floor(t*i[1]*MillionCoe)
local e=e.CurrHeroCtrl:GetFinalAtk()
local e=math.floor(e*i[2]*MillionCoe)
t=math.min(t,e)
table.insert(o,t)
end
a:AddBuff(e.CurrHeroCtrl,h,n,o,s)
end
return o

