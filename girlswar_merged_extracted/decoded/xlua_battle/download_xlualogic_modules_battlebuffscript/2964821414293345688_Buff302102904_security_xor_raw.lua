local h=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,n,o,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
if e[3]>0 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
if e[5]>0 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[5],e[6])
end
elseif i.buffTriggerTime==BuffTriggerTime.ReduceFury then
local i=302102906
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AdBuffHateRedButterfly(n,a,o)
else
local i=o.furyValue or 0
local n=o.operSrcType
local o=o.isDirect
if e[7]>0 and a and type(i)=="number"and i>0 and o==true then
local o=e[7]
local n=e[8]
local s={e[9],i}
local e=a.HeroBattleInfo:GetBuff(o)
if e then
local e=e:GetBuffData()
e[2]=e[2]+i
else
a:AddBuff(t.CurrHeroCtrl,o,n,s)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.ReduceFury)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddPursuitAttack(t,n,i)
local o=t:GetBuffData()
local a=t.CurrHeroCtrl.HeroId
local e=21029304
if e>0 then
o[10]=n
local o={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
insertLevel=ETriggerSkillInsertLevel.ComboAttack,
costMp=false
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if t==nil then
local t={
triggerSkillAtkType=i
}
h:AddTriggerAttackTask(a,e,o,t)
end
end
end
function a.CheckCondition(t,e)
local a=302102908
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
return true
end
local e=e[10]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
if e and e.HeroBattleInfo and e.HeroBattleInfo.CurrHP>0 then
return true
end
end
return false
end
function a.HandleOnDoAction(t,e)
if s.CheckCondition(t,e)==false then
return false
end
e[10]=0
return true
end
return s

