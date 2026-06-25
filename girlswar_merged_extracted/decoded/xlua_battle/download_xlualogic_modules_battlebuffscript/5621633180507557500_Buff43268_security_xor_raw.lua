local i=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,s,s,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4])
t[9]=0
t[10]=0
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
if o.CheckCondition(e,t)==false then
return
end
local t=e.CurrHeroCtrl.HeroId
local a=1929101
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
hurtDataMap={},
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if e==nil then
i:AddTriggerAttackTask(t,a,o,n)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckCondition(t,e)
local t=e[5]
e[9]=e[9]or 0
if e[10]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[10]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[9]=0
end
if e[9]>=t then
return false
end
return true
end
function t.HandleOnDoAction(t,e,a)
if o.CheckCondition(t,e)==false then
return false
end
local r=a.skillData
local s=e[6]
local i=e[7]
local a=e[8]
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43272)
if o then
local e=o:GetBuffData()
s=e[8]
i=e[9]
a=e[10]
end
e[9]=e[9]+1
local n=43270
local e={}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for t=1,#o do
local t=o[t]
local o=t.HeroBattleInfo:GetBuff(n)
local a=0
if o then
a=o:GetFloors()
local t={
enemy=t,
floors=a,
battleStationIndex=t.battleStationIndex
}
table.insert(e,t)
end
end
if#e>0 then
table.sort(e,function(t,e)
if t.floors~=e.floors then
return t.floors<e.floors
end
return t.battleStationIndex<e.battleStationIndex
end)
local n={}
local h=t.CurrHeroCtrl:GetFinalAtk()
for t=1,#e do
local o=e[t].enemy
local e=e[t].floors
local e=math.min(s*e+i*(t-1),a)
local e=math.floor(h*e*MillionCoe)
local e={
defHeroId=o.HeroId,
realhurt=e,
}
n[o.HeroId]=e
end
r.hurtDataMap=n
return true
end
return false
end
return o

