local o=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,n,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return nil
end
local t=e.CurrHeroCtrl.HeroId
if t==s.HeroId and a.CheckBaseCondition(e)then
local t=e.CurrHeroCtrl.HeroId
local a=e.CurrHeroCtrl.BigSkillId
local e={
defHeroIds={n.HeroId},
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
needResetBeforeAction=true,
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if n==nil then
o:AddTriggerAttackTask(t,a,e,i)
end
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckBaseCondition(e,t)
local t=302107811
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local a=e:GetBuffData()
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local e=t.GetHorseFloor(e,a)
if e>0 then
return true
end
end
return false
end
function e.CheckCondition(e,t)
if a.CheckBaseCondition(e)==false then
return false
end
local e=a.GetProByHp(e,t)
if e<RandomMgr:GetBattleRandom()then
return false
end
return true
end
function e.HandleOnBeforeAction(t,e,a)
local e=t.CurrHeroCtrl.SmallSkillId
if e==0 then
e=t.CurrHeroCtrl.NormalSkillId
end
if t.CurrHeroCtrl:IsFullFury()then
e=t.CurrHeroCtrl.BigSkillId
end
local e=o:ResetTriggerAttackTaskSkillDid(a,e)
return e
end
function e.HandleOnDoAction(e,o,t)
if a.CheckCondition(e,o)==false then
return false
end
local a=302107811
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local i=t:GetBuffData()
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.reduceHorseFloor(t,i,o[4])
end
local t=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()-e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local t=math.floor(t*o[5]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
return true
end
function e.GetProByHp(t,e)
if e[3]<=0 then
return 0
elseif e[3]<10000 then
local a=(e[1]-e[2])/(10000-e[3])
local o=e[1]-a*10000
local t=t.CurrHeroCtrl:CurrHPPer()
local t=t*OneMillion
if t<e[3]then
t=e[3]
end
if t>10000 then
t=10000
end
local e=a*t+o
return e
else
return e[1]
end
end
return a

