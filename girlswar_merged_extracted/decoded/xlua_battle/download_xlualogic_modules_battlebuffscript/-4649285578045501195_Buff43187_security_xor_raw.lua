local s=require("Modules/Battle/BattleUtil")
local h=require('Modules/BattleBuffScript/BuffPairTools')
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,s,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
local e=n.triggerSkillAtkType
if e==ETriggerSkillAtkType.TeamAttack then
t[12]=-1
return
end
t[12]=0
return
end
if t[12]~=0 then
return
end
t[12]=1
local a=e.CurrHeroCtrl.HeroId
if a==o.HeroId then
if t[1]>=RandomMgr:GetBattleRandom()then
local o=RandomMgr:GetBattleRandomWithRange(1,3)
if o==1 then
i.AddGiftBombs(e.CurrHeroCtrl,t,n)
return
elseif o==3 then
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[7])
if e~=nil then
return
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eRandom,1)
if a then
for n=1,#a do
local a=a[n]
if o==3 then
i.AddDummyDoll(e.CurrHeroCtrl,t,a)
else
a:AddBuff(e.CurrHeroCtrl,t[5],t[6],{})
end
end
end
end
end
end
function a.AddGiftBombs(t,e,i)
local a=e[3]*MillionCoe
local o=t:GetFinalAtk()
local o=o*a
local a=t:GetTeamId()
local e={e[2],e[4],a,o}
local a=1912201
local o={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
skillParam=e
}
local e=t.HeroId
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,e)
if t==nil then
s:AddTriggerAttackTask(e,a,o,i)
end
end
function a.AddDummyDoll(a,t,i)
local o=t[10]
local n=t[11]
local e={}
local e=i:AddBuff(a,o,n,e)
if e then
local e=h.GetDefaultHpChainData()
e.assumedamagePercent=t[8]
e.reduceDamagePercent=0
e.minHpPercent=0
e.defHeroId=i.HeroId
e.defBuffId=o
local o=t[7]
local t=t[9]
local e={e}
a:AddBuff(a,o,t,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)
or(e==BuffTriggerTime.skillPlay)
or(e==BuffTriggerTime.skill2Play)
or(e==BuffTriggerTime.skill3Play)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i 
