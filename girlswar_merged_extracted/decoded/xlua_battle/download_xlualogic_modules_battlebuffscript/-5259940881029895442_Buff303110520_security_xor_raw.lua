local n=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,h,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local n=t[1]
local a=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,a,i)
local n=t[5]
local a=t[6]
local i={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,a,i)
local n=t[9]
local a=t[10]
local i={t[11],t[12]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,a,i)
o.AddBuffSepsisRes(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart
or a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if t[31]+t[15]<=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
o.AddBuffSepsisRes(e,t)
end
elseif a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if i.IsOurHero~=e.CurrHeroCtrl.IsOurHero then
if(t[16]>=RandomMgr:GetBattleRandom())then
o.RandomAddBuffKnife(e)
if o.CheckCondition(e,t)then
local o=t[18]
local a=true
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#t do
local e=t[e].HeroBattleInfo:GetBuff(o)
if e==nil then
a=false
end
end
if a then
local t=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.BigSkillId
local o={}
local o={
defHeroIds={i.HeroId},
costMp=false,
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
n:AddTriggerAttackTask(t,a,o,s)
end
end
end
end
else
o.AddBuffNoKnife(e,1)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart
or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffSepsisRes(t,e)
local o=e[13]
local a=e[14]
local e={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
function a.RandomAddBuffKnife(n,r)
local a=n:GetBuffData()
local h=a[18]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n.CurrHeroCtrl,BattleHeroType.enemyAll)
local s={}
local i={}
for t=1,#e do
if e[t].HeroId~=r then
local a=e[t].HeroBattleInfo:GetBuff(h)
if a==nil then
table.insert(i,e[t])
else
table.insert(s,e[t])
end
end
end
local e={}
if#i>0 then
e=RandomTableWithSeed(i,a[17])
end
if#e<a[17]then
local t=a[17]-#e
local t=RandomTableWithSeed(s,t)
table.appendList(e,t)
end
for t=1,#e do
o.AddBuffKnife(n,e[t])
end
end
function a.AddBuffKnife(t,i)
local e=t:GetBuffData()
local a=e[18]
local o=e[19]
local e={e[20],e[21]}
i:AddBuff(t.CurrHeroCtrl,a,o,e)
end
function a.AddBuffNoKnife(t,i)
local e=t:GetBuffData()
local o=e[23]
local a=e[24]
local e={e[25],e[26],e[27],e[28],e[29],e[30]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e,i)
end
function a.CheckCondition(t,e)
if e[32]~=0 and e[32]+e[22]>ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return false
end
return true
end
function a.HandleOnDoAction(t,e,a)
if o.CheckCondition(t,e)==false then
return false
end
e[32]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
return true
end
return o

