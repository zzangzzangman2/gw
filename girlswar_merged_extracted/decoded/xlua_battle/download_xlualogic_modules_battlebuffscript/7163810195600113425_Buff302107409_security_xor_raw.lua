local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,i,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.attacked then
if a~=nil then
e[20]=a.HeroId
e[21]=ModulesInit.ProcedureNormalBattle.GetSkillFireCount()
end
elseif o.buffTriggerTime==BuffTriggerTime.skillComplete then
local o=ModulesInit.ProcedureNormalBattle.GetSkillFireCount()
local a=e[20]
if a and o==e[21]then
e[20]=0
e[21]=0
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a and a:CheckHeroCanDoAction()then
local o=e[1]
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(302107424)
if i and t.CurrHeroCtrl:CurrHPPer()<=e[2]*MillionCoe then
o=e[3]
end
local n=302107422
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if i then
local n=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local o=n.AddControl(i,o,a)
if o then
a.HeroBattleInfo:PlayBattleEffectWithBuffId(3132)
e[22]=e[22]+1
if e[22]>=e[23]then
local i=e[24]
local o=e[25]
local e={e[26],e[27]}
a:AddBuff(t.CurrHeroCtrl,i,o,e)
end
end
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
t:PlayBuffPrefabEffect(EBuffEffectType.eachRoundStart)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.OnSuccessAddWind(t,a)
local e=t:GetBuffData()
local o=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*e[4]*MillionCoe)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
local n=e[5]
local i=e[6]
local o={e[7],e[8]}
local s=e[9]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,i,o,1,s)
local i=e[10]
local o=e[11]
local n={e[12],e[13]}
local s=e[14]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,o,n,1,s)
if a then
ModulesInit.ProcedureNormalBattle.StealFury(t.CurrHeroCtrl,a,e[15],EBattleSrcType.Buff,false)
if e[19]<e[18]then
e[19]=e[19]+1
end
end
end
function a.DoActionBigSkill(t)
local e=t:GetBuffData()
if e[19]>0 then
local a={
attrId=e[16],
value=e[17]*e[19],
}
t.CurrHeroCtrl:AddAttrValueInCurAttack(a)
e[19]=0
end
end
return h

