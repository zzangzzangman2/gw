local n=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,h,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if i.buffTriggerTime==BuffTriggerTime.now
or i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if t[1]>0 then
if i.buffTriggerTime==BuffTriggerTime.now or ModulesInit.ProcedureNormalBattle.CurrBattleBigRound~=1 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fRandomFuryNotFullExcludeSelf,1)
local a=a[1]
if a==nil and e.CurrHeroCtrl:IsFullFury()==false then
a=e.CurrHeroCtrl
end
if a then
a:AddFuryWithBuffImmediately(t[1])
end
end
end
if i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=t[7]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local o=o:GetFloors()
e.CurrHeroCtrl:AddFuryWithBuffImmediately(o*t[11])
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
elseif i.buffTriggerTime==BuffTriggerTime.now then
o.GainGodShield(e,t[14])
end
end
elseif i.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if(a.IsOurHero==e.CurrHeroCtrl.IsOurHero
and a.HeroId~=e.CurrHeroCtrl.HeroId
and a:IsPet()==false)then
if s.triggerSkillAtkType==ETriggerSkillAtkType.Normal then
if t[42]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[42]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[41]=0
end
if t[40][a.HeroId]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[40][a.HeroId]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local a=t[2]+t[41]
local i=303110725
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local e=e.GetUpSmallSkillRate(o)
a=a+e
end
if a>=RandomMgr:GetBattleRandom()then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.SmallSkillId
local a=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable()
if e>0 then
local o={
defHeroIds=a,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
n:AddTriggerAttackTask(t,e,o,s)
end
end
else
t[41]=t[41]+t[3]
end
end
end
end
end
elseif i.buffTriggerTime==BuffTriggerTime.attacked then
if t[4]>0 and t[5]>0 and e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if o.CheckCondition(e,t)then
if e.CurrHeroCtrl:IsOnAttack()==false then
local o=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
if t>0 then
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
defHeroIds={a.HeroId},
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if a==nil then
n:AddTriggerAttackTask(o,t,e,s)
end
end
end
end
o.GainGodAnger(e,t[6])
local i=t[9]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[7])
if n then
local e=n:GetFloors()
i=i+e*t[10]
end
local n=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=math.floor(n*i*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(i,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
o.ReduceGodShield(e,t[16])
local i=t[12]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
local i=0
if n then
i=n:GetFloors()
end
if a:GetFinalAtk()>e.CurrHeroCtrl:GetFinalAtk()then
if i>=t[17]then
o.ReduceGodShield(e,t[17])
local i=t[18]
local o=t[19]
local t={t[20],t[21]}
a:AddBuffWithFloorNotRefreshRound(e.CurrHeroCtrl,i,o,t,1)
end
end
local n=t[24]
local n=a.HeroBattleInfo:GetBuff(n)
if n==nil then
if i>=t[23]and t[22]>=RandomMgr:GetBattleRandom()then
o.ReduceGodShield(e,t[23])
o.GainGodPunish(e,a,t[25])
end
end
end
elseif i.buffTriggerTime==BuffTriggerTime.resurgence then
o.GainGodShield(e,t[32])
o.ResetFirstBigSkill(e)
elseif i.buffTriggerTime==BuffTriggerTime.fatalDmgBeforeCheckSuccess then
o.GainGodShield(e,t[32])
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.resurgence
or e==BuffTriggerTime.fatalDmgBeforeCheckSuccess)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckCondition(e,t)
local e=e:GetBuffData()
if e[44]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[44]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[43]=0
end
if e[43]<e[5]then
return true
end
return false
end
function a.HandleOnDoAction(t,e)
if o.CheckCondition(t,e)==false then
return false
end
local t=t.CurrHeroCtrl:CurrHPPer()
if t>=e[4]*MillionCoe then
return false
end
e[43]=e[43]+1
return true
end
function a.GainGodAnger(e,a)
local t=e:GetBuffData()
local o=t[7]
local i=t[8]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,t,a)
end
function a.GainGodShield(t,o)
local e=t:GetBuffData()
local i=e[12]
local n=e[13]
local a={}
local e=e[15]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,n,a,o,e)
end
function a.ReduceGodShield(e,t)
local a=e:GetBuffData()
local a=a[12]
n:ReduceHeroBuffFloor(e.CurrHeroCtrl,a,t)
end
function a.GainGodPunish(t,o,a)
local e=t:GetBuffData()
local n=e[24]
local i={e[26],e[27],e[28],e[29]}
o:AddBuff(t.CurrHeroCtrl,n,a,i)
local i=e[30]
local e={e[31]}
o:AddBuffAfterRemove(t.CurrHeroCtrl,i,a,e)
end
function a.GainGodMusic(t,n)
local e=t:GetBuffData()
local o=e[36]
local i=e[38]
local a=303110711
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local e=a:GetBuffData()
o=e[1]
i=e[2]
end
local a=e[33]
local s=e[34]
local o={e[35],o,e[37],i}
local e=e[39]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,a,s,o,n,e)
end
function a.isMaxGodMusic(e,t)
local t=e:GetBuffData()
local a=t[33]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local e=e:GetFloors()
if e>=t[39]then
return true
end
end
return false
end
function a.IsFirstBigSkill(e)
local e=e:GetBuffData()
if e[45]==0 then
return true
end
return false
end
function a.UseFirstBigSkill(e)
local e=e:GetBuffData()
e[45]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
function a.ResetFirstBigSkill(e)
local e=e:GetBuffData()
e[45]=0
end
function a.AddAttackTask(e,o,a)
local t=e:GetBuffData()
local e=e.CurrHeroCtrl.HeroId
local t=31107304
local a={
triggerSkillAtkType=ETriggerSkillAtkType.AttachAttack,
defHeroIds=o,
round=a,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,e)
if o==nil then
n:AddTriggerAttackTask(e,t,a,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return o

