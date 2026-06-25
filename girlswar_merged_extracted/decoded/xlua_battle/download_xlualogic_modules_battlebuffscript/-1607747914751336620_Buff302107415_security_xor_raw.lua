local n=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,h,a,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
local a=e[5]
local i=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,o,1)
local a=302107423
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddEyeBuff(t,e[23],1)
end
elseif o.buffTriggerTime==BuffTriggerTime.skillPlay then
local a=i.triggerSkillAtkType
if a~=ETriggerSkillAtkType.Normal then
return
end
local a=t.CurrHeroCtrl:GetTeamStatFuryChangeInCurBigRound()
local a=math.floor(a/e[9])
if a>0 then
e[25]=e[25]or 0
if e[24]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[24]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[25]=0
end
local o=e[19]
if(e[25]>=o)then
return nil
end
e[25]=e[25]+1
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=n:FindMostBigAtk(i)
if o then
local n=e[10]
local s=e[11]
local i={e[12],e[13]}
local e=e[18]
o:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,s,i,a,e)
end
local o=n:FindMostBigDef(i)
if o then
local s=e[14]
local i=e[15]
local n={e[16],e[17]}
local e=e[18]
o:AddBuffWithMaxFloor(t.CurrHeroCtrl,s,i,n,a,e)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
local a=s:GetHeroControlResRate(t.CurrHeroCtrl)
local a=a.defFinalControlResRate
local o=s:GetHeroControlResRate(h)
local o=o.defFinalControlResRate
if a>o then
if(e[20]>=RandomMgr:GetBattleRandom())then
local e={
attrId=e[21],
value=e[22],
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(e)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

