local i=require("Modules/Battle/Formula")
local n=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local n=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,a)
local n=e[5]
local o=e[6]
local a={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,o,a)
local a=e[9]
local n=e[10]
local o={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,n,o)
local a=e[13]
local o=e[14]
local e={e[15],e[16]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
t.CurrHeroCtrl.minFinalAtk=i:CalculateHeroFinalAtk(t.CurrHeroCtrl)
elseif a.buffTriggerTime==BuffTriggerTime.evadeed then
local o=e[17]
local a=e[18]
local e={e[19],e[20]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.evadeed)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffWireRestraint(t,n,a)
local e=t:GetBuffData()
local i=e[25]
local o=e[26]
local e={e[27],e[28],e[29],e[30]}
n:AddBuff(t.CurrHeroCtrl,i,o,e,a)
end
function a.DoBeansActionSmallSkill(e,r,h)
local i=e:GetBuffData()
local t=303101233
local a=n:GetHeroMostBuffFloor(e.CurrHeroCtrl,BattleHeroType.enemyAll,t)
local o={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if a then
for e=1,#t do
if t[e].HeroId~=a.HeroId then
table.insert(o,t[e])
end
end
else
o=t
end
local t=RandomTableWithSeed(o,i[23])
table.insert(t,a)
for a=1,#t do
s.AddBuffWireRestraint(e,t[a],i[24])
end
s.AddAttackTaskNormalSkill(e,r,h)
end
function a.AddAttackTaskNormalSkill(e,s,a)
local t=e:GetBuffData()
local o=i:GetSmallSkillRate(e.CurrHeroCtrl)
if(o*t[31]*MillionCoe>=RandomMgr:GetBattleRandom())then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.NormalSkillId
if e>0 then
local a={
defHeroIds={a},
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if o==nil then
n:AddTriggerAttackTask(t,e,a,s)
end
end
end
end
function a.AddAttackTaskSmallSkill(e,o,a)
local s=e:GetBuffData()
local t=i:GetSmallSkillRate(e.CurrHeroCtrl)
if(t*s[31]*MillionCoe>=RandomMgr:GetBattleRandom())then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.SmallSkillId
if e>0 then
local a={
defHeroIds={a},
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if i==nil then
n:AddTriggerAttackTask(t,e,a,o)
end
end
end
end
return s

