local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,h,o,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local o=#a
local i=t[1]
local a=t[2]
local t={t[3],t[4],t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,t,o)
elseif a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local i=t[1]
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a then
local n=a:GetFloors()
if n>0 then
local o=1
a:ReduceFloors(o)
if n-o<=0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
local a=t[7]
local o=t[8]
local t={t[9],t[10],t[11],t[12]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t,1)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
local a=s.attackType
if h.IsOurHero==e.CurrHeroCtrl.IsOurHero
and h:IsPet()==false
and a==AttackType.BigSkill then
local a=s.hurtValue
local a=math.floor(a*t[13]*MillionCoe)
local o=t[16]*MillionCoe
local o=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*o)
a=math.min(o,a)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
if(t[14]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.DoReduceFury then
e.CurrHeroCtrl:AddFuryWithBuff(t[15])
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.DoReduceFury)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return r

