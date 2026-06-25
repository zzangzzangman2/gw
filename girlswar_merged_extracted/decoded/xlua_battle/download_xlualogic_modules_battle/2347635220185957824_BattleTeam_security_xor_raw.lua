local e=1
local D=require("DataNode/DataManager/DataMgr/DataUtil")
local o
if(GameInit.IsClient)then
o=require("Common/cs_coroutine")
else
o=require("Common/cs_coroutine_server")
end
local n=require("Modules/Battle/Formula")
local a=require("Modules/Battle/BattleUtil")
local F=table.add
local C=nil
if(GameInit.IsClient)then
C=require("Modules/Battle/BattleResPreloadMgr")
end
BattleTeam={}
function BattleTeam:New()
local e={
TeamId=0,
OpponentTeam=nil,
HeroCtrls={},
PetCtrls={},
MaxHeroCount=0,
CurrHeroCount=0,
OnBattleTeamReady=nil,
CurrAttackHeroIndex=1,
CurrAttackHeroCtrl=nil,
TempList=nil,
OnTeamBattleRoundBeginAddBuffComplete=nil,
SmallSkillAttackQueue=List.New(),
OnRefreshFirstAttack=nil,
TotalMaxHP=0,
TotalMaxArmor=0,
TotalHP=0,
PrevTotalHP=0,
OnRefreshTotalHP=nil,
OnResetTotalHP=nil,
OnRefreshTotalArmor=nil,
TotalFirstValue=0,
IsHeroAttacking=false,
supplementData=nil,
actionData_Explosive=nil,
actionData_Big=nil,
actionData_Normal=nil,
IsBigAttackWaiting=false,
SuppleMaxHp=0,
TotalSuppleHP=0,
coroutine_HeroBigAttack=nil,
coroutine_HeroBigAttack_FightPlay=nil,
coroutine_HeroNormalAttack=nil,
coroutine_HeroNormalAttack_FightPlay=nil,
coroutine_SupplementPosition=nil,
coroutine_process=nil,
enemyFirstBigSkill=false,
mBigAttackManualTask=nil,
mSupplementHeros={},
mCampionBuffId=0,
mFirstAddRate=0,
mOfficer=0,
mTeamTreasures={},
mTeamBuffDic={},
mTeamBuffGroupDic={},
mTeamFuryAddDic={},
mTeamFuryReduceDic={},
mTeamOverdrowFuryAddDic={},
mTeamOverdrowFuryReduceDic={},
attackTask=nil,
mTeamFightAttackCallback=nil,
mBuffTeamStatCountMap={},
mIsNeedCheckTargetLevel=false,
}
setmetatable(e,self)
self.__index=self
return e
end
function BattleTeam:Init()
self:AddEventListener()
end
function BattleTeam:StopCoroutine()
if(GameInit.IsClient)then
if(self.coroutine_HeroBigAttack)then
o.stop(self.coroutine_HeroBigAttack)
self.coroutine_HeroBigAttack=nil
end
if(self.coroutine_HeroBigAttack_FightPlay)then
o.stop(self.coroutine_HeroBigAttack_FightPlay)
self.coroutine_HeroBigAttack_FightPlay=nil
end
if(self.coroutine_HeroNormalAttack)then
o.stop(self.coroutine_HeroNormalAttack)
self.coroutine_HeroNormalAttack=nil
end
if(self.coroutine_HeroNormalAttack_FightPlay)then
o.stop(self.coroutine_HeroNormalAttack_FightPlay)
self.coroutine_HeroNormalAttack_FightPlay=nil
end
if(self.coroutine_SupplementPosition)then
o.stop(self.coroutine_SupplementPosition)
self.coroutine_SupplementPosition=nil
end
self:StopProcessCoroutine()
end
end
function BattleTeam:Dispose()
self:StopCoroutine()
self:RemoveEventListener()
self.TeamId=nil
self.OpponentTeam=nil
self.HeroCtrls={}
self.PetCtrls={}
self.TotalFirstValue=0
self.MaxHeroCount=0
self.CurrHeroCount=0
self.OnBattleTeamReady=nil
self.CurrAttackHeroIndex=nil
self.CurrAttackHeroCtrl=nil
self.TempList=nil
self.OnTeamBattleRoundBeginAddBuffComplete=nil
self.SmallSkillAttackQueue=nil
self.supplementData=nil
self.actionData_Explosive=nil
self.actionData_Big=nil
self.actionData_Normal=nil
self.enemyFirstBigSkill=false
self.mBigAttackManualTask=nil
self.mCampionBuffId=0
self.OnRefreshTotalArmor=nil
self.mFirstAddRate=0
self.mOfficer=0
self.mTeamTreasures={}
self:DisposeAllTeamBuff()
self.mTeamFuryAddDic={}
self.mTeamFuryReduceDic={}
self.mTeamOverdrowFuryAddDic={}
self.mTeamOverdrowFuryReduceDic={}
self.attackTask=nil
self.mTeamFightAttackCallback=nil
self.mBuffTeamStatCountMap={}
self.mIsNeedCheckTargetLevel=false
end
function BattleTeam:Reset()
self:StopCoroutine()
self.TotalMaxHP=0
self.TotalMaxArmor=0
self.TotalHP=0
self.SuppleMaxHp=0
self.TotalSuppleHP=0
end
function BattleTeam:ResetHeroDataWhenNextWave()
List.Clear(self.SmallSkillAttackQueue)
for t,e in ipairs(self.HeroCtrls)do
e:ResetHeroDataWhenNextWave()
end
end
function BattleTeam:AddEventListener()
EventSystem.AddListener(CommonEventId.OnBattleRoundBeginCheckBuff,self.OnBattleRoundBeginCheckBuff,self)
EventSystem.AddListener(CommonEventId.OnBattleRoundEndCheckBuff,self.OnBattleRoundEndCheckBuff,self)
EventSystem.AddListener(CommonEventId.OnHeroBigSkillAttack,self.OnHeroBigSkillAttack,self)
end
function BattleTeam:RemoveEventListener()
EventSystem.RemoveListener(CommonEventId.OnBattleRoundBeginCheckBuff,self.OnBattleRoundBeginCheckBuff,self)
EventSystem.RemoveListener(CommonEventId.OnBattleRoundEndCheckBuff,self.OnBattleRoundEndCheckBuff,self)
EventSystem.RemoveListener(CommonEventId.OnHeroBigSkillAttack,self.OnHeroBigSkillAttack,self)
end
function BattleTeam:LoadTeamTreasure(o)
local function h(e,t)
if e==nil then
return true
end
if e.skillPara~=t.skillPara then
return e.skillPara<t.skillPara
end
if e.fightValue~=t.fightValue then
return e.fightValue<t.fightValue
end
return e.heroId<t.heroId
end
local i={}
for n=1,#o do
local e=o[n].treasures
if e then
for t=1,#e do
local e=e[t]
local t=a:GetTreasureCfgData(e.treasureDid)
if t then
local s=a:GetTreasureSkillCfgData(t.skill)
if s.type==EtreasureSkillType.teamAll then
local a=a:GetTreasureStrengCfgData(e.treasureDid,e.level,e.breakLevel)
local s=i[t.type]
local e={
treasure=e,
skillPara=a.skillPara,
fightValue=o[n].fightValue,
heroId=o[n].heroId,
}
if h(s,e)then
i[t.type]=e
end
end
end
end
end
end
self.mTeamTreasures={}
for t,e in pairs(i)do
table.insert(self.mTeamTreasures,e)
end
table.sort(self.mTeamTreasures,function(e,t)
return e.treasure.treasureDid<t.treasure.treasureDid
end)
end
function BattleTeam:CheckTeamTreasure(t,a)
for e=1,#self.mTeamTreasures do
local e=self.mTeamTreasures[e]
if e.heroId==t and e.treasure.treasureDid==a then
return true
end
end
return false
end
function BattleTeam:OnBattleRoundBeginCheckBuff(e)
if(self.TeamId~=e)then
self:TriggerBuffWhenEnemyRoundStart()
end
end
function BattleTeam:OnBattleRoundEndCheckBuff(e)
if(self.TeamId~=e)then
self:TriggerBuffWhenEnemyRoundEnd()
end
end
function BattleTeam:AddHeroCtrl(e)
self.CurrHeroCount=self.CurrHeroCount+1
local t=e.battleStationIndex+1
if(t>#self.HeroCtrls)then
self.HeroCtrls[#self.HeroCtrls+1]=e
else
table.insert(self.HeroCtrls,t,e)
end
e.CurrBattleTeam=self
ModulesInit.ProcedureNormalBattle.AddHeroCtrl(e)
self:SaveHeroMaxHp()
self.TotalHP=self:GetTotalHP()
self.TotalMaxArmor=self:GetTotalMaxArmor()
e.OnHPChange=function()
self:RefreshTotalHP()
end
e.OnArmorChange=function()
self:RefreshTotalArmor()
end
self:TriggerAllBuff(BuffTriggerTime.addMyMate,e,e)
if self.OpponentTeam then
self.OpponentTeam:TriggerAllBuff(BuffTriggerTime.addEnemy,e,e)
end
if(e.IsSupplementHero)then
e:OnDragonWarSupplementRefreshUI()
self:RefreshTotalHP()
else
if(self.MaxHeroCount==self.CurrHeroCount)then
self.PrevTotalHP=self.TotalHP
if(self.OnResetTotalHP)then
self.OnResetTotalHP(self:GetTotalMaxHP(),self:GetTotalHP())
end
if(self.OnRefreshTotalArmor)then
self.OnRefreshTotalArmor(self:GetTotalMaxArmor(),self:GetTotalArmor())
end
self.OnBattleTeamReady(self)
end
end
end
function BattleTeam:RemoveHeroCtrl(e)
for a,t in ipairs(self.HeroCtrls)do
if t.HeroId==e then
self.CurrHeroCount=self.CurrHeroCount-1
ModulesInit.ProcedureNormalBattle.RemoveHeroCtrl(e)
table.remove(self.HeroCtrls,a)
break
end
end
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.removeMyMate)
end
end
end
function BattleTeam:AddPetCtrl(e)
table.insert(self.PetCtrls,e)
e.CurrBattleTeam=self
ModulesInit.ProcedureNormalBattle.AddHeroCtrl(e)
end
function BattleTeam:RemovePetCtrl(e)
for t,a in ipairs(self.PetCtrls)do
if a.HeroId==e then
ModulesInit.ProcedureNormalBattle.RemoveHeroCtrl(e)
table.remove(self.PetCtrls,t)
break
end
end
end
function BattleTeam:HeroLeaveBattle()
local e=true
for a,t in ipairs(self.HeroCtrls)do
local t=t:HeroLeaveBattle()
if t==false then
e=false
end
end
return e
end
function BattleTeam:AllHeroDead()
for t,e in ipairs(self.HeroCtrls)do
if e.HeroBattleInfo then
e.HeroBattleInfo.CurrHP=0
end
e:ChangeDeathState()
end
end
function BattleTeam:GetHeroCtrl(t)
for a,e in ipairs(self.HeroCtrls)do
if e.HeroId==t then
return e
end
end
end
function BattleTeam:GetPetCtrl(t)
for a,e in ipairs(self.PetCtrls)do
if e.HeroId==t then
return e
end
end
end
function BattleTeam:GetHeroCtrlWithBuffId(a)
local e={}
local t=#self.HeroCtrls
for t=1,t do
local t=self.HeroCtrls[t]
if(t.HeroBattleInfo:GetBuff(a))then
e[#e+1]=t
end
end
return e
end
function BattleTeam:GetFighting()
local e=0
local t=ModulesInit.ProcedureNormalBattle.GetTeamHerosByTeamId(self.TeamId)
if t then
e=a:GetFightingWithHeros(t)
else
for a,t in ipairs(self.HeroCtrls)do
e=e+t.HeroBattleInfo:GetFighting()
end
end
return e
end
function BattleTeam:GetFirst()
local e=0
for a,t in ipairs(self.HeroCtrls)do
e=e+t.HeroBattleInfo.First
end
return e
end
function BattleTeam:ShowFirst()
if(self.OnRefreshFirstAttack)then
self.OnRefreshFirstAttack(self:GetTotalFirstValueWithRate(),self.mFirstAddRate,self.mOfficer)
end
end
function BattleTeam:GetAllHerosCountInBattle()
local e={}
local e=#self.HeroCtrls
return e
end
function BattleTeam:GetAllEnemyHerosCountInBattle()
if self.OpponentTeam then
return self.OpponentTeam:GetAllHerosCountInBattle()
end
return 0
end
function BattleTeam:GetHeroCtrlByStation(t)
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.battleStationIndex+1==t)then
return e
end
end
return nil
end
function BattleTeam:GetAllHeros(a)
local t={}
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if a==true or(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
t[#t+1]=e
end
end
end
return t
end
function BattleTeam:GetAllHerosExcludeHero(a)
local t={}
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState()and e.HeroId~=a)then
t[#t+1]=e
end
end
end
return t
end
function BattleTeam:GetAllHeroWithBuff(i,a)
local e=self:GetAllHeros()
a=a or#e
local t={}
for o=1,#e do
if#t>=a then
break
end
if e[o].HeroBattleInfo:GetBuff(i)~=nil then
table.insert(t,e[o])
end
end
return t
end
function BattleTeam:GetAllHerosExcludeHeroWithBuff(e,i,a)
local e=self:GetAllHerosExcludeHero(e)
a=a or#e
local t={}
for o=1,#e do
if#t>=a then
break
end
if e[o].HeroBattleInfo:GetBuff(i)~=nil then
table.insert(t,e[o])
end
end
return t
end
function BattleTeam:GetAllHerosWithoutBuff(i,t)
local e=self:GetAllHeros()
t=t or#e
local a={}
for o=1,#e do
if#a>=t then
break
end
if e[o].HeroBattleInfo:GetBuff(i)==nil then
table.insert(a,e[o])
end
end
return a
end
function BattleTeam:GetColomnWithBuffId(n)
local a=self:GetAllHeros()
local e={}
for o=1,#a do
local t=a[o]
local t=t.battleStationColumn
if e[t]==nil then
e[t]={
column=t,
buffCount=0,
heroArr={}
}
end
local i=e[t].heroArr
if a[o].HeroBattleInfo:GetBuff(n)~=nil then
e[t].buffCount=e[t].buffCount+1
end
table.insert(i,a[o])
end
local t={}
for a,e in pairs(e)do
table.insert(t,e)
end
table.sort(t,function(e,t)
if e.buffCount~=t.buffCount then
return e.buffCount>t.buffCount
end
return e.column<t.column
end)
local e=t[1]
if e then
if e.buffCount>0 then
return e.heroArr
end
end
return nil
end
function BattleTeam:GetTeamFightPet()
for e=1,#self.PetCtrls do
if self.PetCtrls[e]:IsFightPet()then
return self.PetCtrls[e]
end
end
end
function BattleTeam:GetAllTeamPet()
return self.PetCtrls
end
function BattleTeam:GetMostTotalDamage(o)
local a=self:GetAllHeros()
table.sort(a,function(e,t)
if e.TotalDamage~=t.TotalDamage then
return e.TotalDamage>t.TotalDamage
end
return e.HeroId<t.HeroId
end)
return RandomTableWithSeed(a,o)
end
function BattleTeam:HideHeroInRun()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e:IsNotUsualStateOrType())then
e:ShowHeroRoot(false)
end
end
end
end
function BattleTeam:ShowHeroAfterRun()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
e:ShowHeroRoot(true)
end
end
end
function BattleTeam:ShowOrHideHeadBarView(t)
for a,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
e:ShowOrHideHeadBarView(t)
end
end
end
end
function BattleTeam:ShowOrHideSpecialEffect(t)
for a,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
e:ShowOrHideSpecialEffect(t)
end
end
end
end
function BattleTeam:GetAllHerosCount()
local t=0
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 or(e.HeroBattleInfo.CurrHP==0 and e:IsNotUsualState()))then
t=t+1
end
end
end
return t
end
function BattleTeam:GetLackCount()
local e=self:GetAllHerosCount()
return math.max(0,g_BattleTeamMaxCount-e)
end
function BattleTeam:GetBeControlHeros()
local t={}
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo:HasControlBuff())then
t[#t+1]=e
end
end
end
return t
end
function BattleTeam:ResurgenceHero()
local t={}
for a,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e:IsNotUsualState()and(e.NotUsualType==HeroState.DyingState
or e.NotUsualType==HeroState.Freeze
or e.NotUsualType==HeroState.UnDead and e:IsMuteSpecialState()==false))then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.resurgenceBefore)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.resurgence)
table.add(t,e)
end
end
end
return t
end
function BattleTeam:GetHeroCtrlWithId(t)
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroId==t)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
return e
end
end
end
end
return nil
end
function BattleTeam:GetHeroCtrlWithPos(a)
local e
for o,t in ipairs(self.HeroCtrls)do
if(t:GetPos()==a)then
e=t
break
end
end
return e
end
function BattleTeam:GetHeroPosMap()
local e={}
for a,t in ipairs(self.HeroCtrls)do
local a=t:GetPos()
e[a]=t
end
return e
end
function BattleTeam:GetRandomHeros(e)
return RandomTableWithSeed(self:GetAllHeros(),e)
end
function BattleTeam:GetManyRandomHeroExcludeHeroId(a,o)
local e=self:GetAllHeros()
local t={}
for o,e in ipairs(e)do
if(e.HeroId~=a)then
table.add(t,e)
end
end
return RandomTableWithSeed(t,o)
end
function BattleTeam:GetOneRandomHeroExcludeHeroId(a)
local t=self:GetAllHeros()
local e={}
for o,t in ipairs(t)do
if(t.HeroId~=a)then
table.add(e,t)
end
end
local e=RandomTableWithSeed(e,1)
if(e and#e>0)then
return e[1]
end
return nil
end
function BattleTeam:GetFrontOrBackHeros(a)
local t={}
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.battleStationRow==(a and 1 or 2))then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
t[#t+1]=e
end
end
end
end
return t
end
function BattleTeam:GetHerosWithColumn(a,o)
local t={}
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.battleStationColumn==a)then
if o==true or(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
t[#t+1]=e
end
end
end
end
return t
end
function BattleTeam:GetHerosWithRow(o,a)
local t={}
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.battleStationRow==o)then
if a==true or(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
t[#t+1]=e
end
end
end
end
return t
end
function BattleTeam:GetMinHpHero()
local e=self:GetAllHeros()
local t=nil
local a=#e
for a=1,a do
local e=e[a]
if(e.HeroBattleInfo)then
if e.HeroBattleInfo.CurrHP>0 and(t==nil or e.HeroBattleInfo.CurrHP<t.HeroBattleInfo.CurrHP)then
t=e
end
end
end
return t
end
function BattleTeam:GetMinHpPercentHero()
local e=self:GetAllHeros()
local t=nil
local a=#e
for a=1,a do
local e=e[a]
if(e.HeroBattleInfo)then
if e.HeroBattleInfo.CurrHP>0 and(t==nil or e:CurrHPPer()<t:CurrHPPer())then
t=e
end
end
end
return t
end
function BattleTeam:GetMinHpPercentHeroArr(e)
local t=self:GetAllHeros()
return a:GetMinHpPercentHeroArr(t,e)
end
function BattleTeam:GetMaxAddHpHeroArr(a,t)
local e=self:GetAllHeros()
table.sort(e,function(e,o)
local a=e:GetAddHpInBigRound(t)
local t=o:GetAddHpInBigRound(t)
if a~=t then
return a>t
end
return e.HeroId<o.HeroId
end)
local o={}
local t=#e
if a~=nil then
t=math.min(a,#e)
end
for t=1,t do
table.insert(o,e[t])
end
return o
end
function BattleTeam:GetMaxHpPercentHeroArr(e)
local t=self:GetAllHeros()
return a:GetMaxHpPercentHeroArrByHeroArr(t,e)
end
function BattleTeam:GetHeroArrWithBuff(t,o,i)
local e=self:GetAllHeros()
local e=a:GetHeroArrWithBuff(e,t,o,i)
return e
end
function BattleTeam:GetMostDebuffHero(e)
local o
if e~=nil then
o=self:GetManyRandomHeroExcludeHeroId(e)
else
o=self:GetAllHeros()
end
local e=nil
local i={}
local t=#o
for t=1,t do
local t=o[t]
if(t.HeroBattleInfo)then
if t.HeroBattleInfo.CurrHP>0 then
local a=t.HeroBattleInfo:GetGranBuffSort(false,true)
if#a>0 then
if e==nil then
e=t
i=a
else
local o=i[1].cfgData
local n=a[1].cfgData
if o.isControl<n.isControl then
e=t
i=a
elseif o.isControl==n.isControl then
if#i<#a then
e=t
i=a
end
end
end
end
end
end
end
if e==nil then
local t=RandomTableWithSeed(o,1)
e=t[1]
end
return e
end
function BattleTeam:GetRandomHeroWithGranBuff(o,a)
local t=self:GetAllHeros()
local e={}
local i=#t
for a=1,i do
local t=t[a]
if(t.HeroBattleInfo)then
if t.HeroBattleInfo.CurrHP>0 then
local a=t.HeroBattleInfo:GetGranBuffSort(o,true)
if#a>0 then
table.insert(e,t)
end
end
end
end
local t
if a==nil then
t=e
else
if#e>a then
t=RandomTableWithSeed(e,a)
else
t=e
end
end
return t
end
function BattleTeam:GetRandomHeroWithSepsisHp(a)
local t=self:GetAllHeros()
local e={}
local o=#t
for a=1,o do
local t=t[a]
if(t.HeroBattleInfo)then
if t.HeroBattleInfo.SepsisHp>0 then
table.insert(e,t)
end
end
end
local t
if a==nil then
t=e
else
if#e>a then
t=RandomTableWithSeed(e,a)
else
t=e
end
end
return t
end
function BattleTeam:GetMostHeroWithSepsisHp(a)
local t=self:GetAllHeros()
local e={}
local o=#t
for a=1,o do
local t=t[a]
if(t.HeroBattleInfo)then
if t.HeroBattleInfo.SepsisHp>0 then
table.insert(e,t)
end
end
end
table.sort(e,function(t,e)
if t.HeroBattleInfo.SepsisHp~=e.HeroBattleInfo.SepsisHp then
return t.HeroBattleInfo.SepsisHp>e.HeroBattleInfo.SepsisHp
end
return t.HeroId<e.HeroId
end)
local t={}
if a==nil then
t=e
else
if#e>a then
for a=1,a do
table.insert(t,e[a])
end
else
t=e
end
end
return t
end
function BattleTeam:GetEnemyPriorityFromBack()
local e=self:GetFrontOrBackHeros(false)
if(#e<=0)then
e=self:GetFrontOrBackHeros(true)
end
if(#e>0)then
return e[RandomMgr:GetBattleRandomWithRange(1,#e)]
end
return nil
end
function BattleTeam:GetHerosPriorityFromBack(a)
a=a or 1
local i=self:GetFrontOrBackHeros(false)
local o=a-#i
local t={}
if(o>0)then
t=i
local e={}
local a=self:GetFrontOrBackHeros(true)
if(#a<=o)then
e=a
else
e=RandomTableWithSeed(a,o)
end
for a=1,#e do
table.insert(t,e[a])
end
else
t=RandomTableWithSeed(i,a)
end
return t
end
function BattleTeam:GetMaxFinalAtk()
local a=-1
local t=nil
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
local o=n:CalculateHeroFinalAtk(e)
if t==nil or o>a then
a=o
t=e
end
end
end
end
return t
end
function BattleTeam:GetMaxFinalAtkByPriorBack()
local e=self:GetMaxFinalAtkFromBack()
if e==nil then
e=self:GetMaxFinalAtkFromFront()
end
return e
end
function BattleTeam:GetMaxFinalAtkFromBack()
local t=0
local a=nil
local e=self:GetFrontOrBackHeros(false)
local o=#e
for o=1,o do
local e=e[o]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
local o=n:CalculateHeroFinalAtk(e)
if o>t then
t=o
a=e
end
end
end
end
return a
end
function BattleTeam:GetMaxFinalAtkFromFront()
local o=0
local a=nil
local e=self:GetFrontOrBackHeros(true)
local t=#e
for t=1,t do
local e=e[t]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
local t=n:CalculateHeroFinalAtk(e)
if t>o then
o=t
a=e
end
end
end
end
return a
end
function BattleTeam:TriggerBuffWhenEnemyRoundStart()
for e=#self.HeroCtrls,1,-1 do
local e=self.HeroCtrls[e]
if(e~=nil and e.HeroBattleInfo~=nil and e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyRoundStart)
end
end
for e=1,#self.PetCtrls do
local e=self.PetCtrls[e]
if e~=nil and e.HeroBattleInfo~=nil then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyRoundStart)
end
end
end
function BattleTeam:TriggerBuffWhenEnemyRoundEnd()
for e=#self.HeroCtrls,1,-1 do
local e=self.HeroCtrls[e]
if(e~=nil and e.HeroBattleInfo~=nil and e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyRoundEnd)
end
end
for e=1,#self.PetCtrls do
local e=self.PetCtrls[e]
if e~=nil and e.HeroBattleInfo~=nil then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyRoundEnd)
end
end
end
function BattleTeam:TriggerAllBuff(e,t,a,o)
for i=1,#self.HeroCtrls do
local i=self.HeroCtrls[i]
if i~=nil and i.HeroBattleInfo~=nil then
i.HeroBattleInfo:TriggerBuff(e,t,a,o)
end
end
for i=1,#self.PetCtrls do
local i=self.PetCtrls[i]
if i~=nil and i.HeroBattleInfo~=nil then
i.HeroBattleInfo:TriggerBuff(e,t,a,o)
end
end
self:TriggerTeamBuff(e,t,a,o)
end
function BattleTeam:GetTeamTreasures()
return self.mTeamTreasures
end
function BattleTeam:AddTreasure()
local e=false
local t=#self.HeroCtrls
for t=1,t do
local t=self.HeroCtrls[t]
if(t~=nil)then
local t=t:AddTreasure()
if t==true then
e=t
end
end
end
return e
end
function BattleTeam:BattleRoundBeginAddFrontBuff()
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
e:BattleRoundBeginAddFrontBuff()
end
end
function BattleTeam:BattleRoundBeginAddPetFrontBuff()
local e=#self.PetCtrls
for e=1,e do
local e=self.PetCtrls[e]
e:BattleRoundBeginAddPetFrontBuff()
end
end
function BattleTeam:BattleRoundBeginAddAfterBuff()
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e~=nil)then
e.IsBattleRoundBeginAddBuffing=true
e.OnBattleRoundBeginAddBuffComplete=function()
self:OnBattleRoundBeginAddBuffComplete()
end
end
end
self:BattleRoundBeginExcuteAddAfterBuff()
end
function BattleTeam:BattleRoundBeginExcuteAddAfterBuff()
local e=#self.HeroCtrls
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=0
for e=1,e do
local e=self.HeroCtrls[e]
if(e~=nil and e.IsBattleRoundBeginAddBuffing==true)then
t=t+1
e:BattleRoundBeginAddAfterBuff()
end
end
if(t==0)then
self:OnBattleRoundBeginAddBuffComplete()
end
end
function BattleTeam:OnBattleRoundBeginAddBuffComplete()
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e~=nil and e.IsBattleRoundBeginAddBuffing)then
return
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(self.OnTeamBattleRoundBeginAddBuffComplete)then
self.OnTeamBattleRoundBeginAddBuffComplete()
end
end
function BattleTeam:BattleRoundBeginExplosive_FightPlay()
local e=self:GetFightAction()
self.actionData_Big=self:GetFightActionWithType(e,1)
self.actionData_Normal=self:GetFightActionWithType(e,2)
self.actionData_Explosive=self:GetFightActionWithType(e,3)
local e=self:GetFightActionWithType(e,4)
if(e and#e>0)then
for t,e in ipairs(e)do
local e=self:GetHeroCtrl(e.heroId)
if(e)then
e:CancelExplosive()
end
end
end
if(self.actionData_Explosive and#self.actionData_Explosive>0)then
self:StopProcessCoroutine()
self.coroutine_process=o.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
for t,e in ipairs(self.actionData_Explosive)do
local e=self:GetHeroCtrl(e.heroId)
if(e)then
e:Explosive()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
for t,e in ipairs(self.actionData_Explosive)do
local e=self:GetHeroCtrl(e.heroId)
if(e)then
e:ExplosiveAfter()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
for t,e in ipairs(self.actionData_Explosive)do
local e=self:GetHeroCtrl(e.heroId)
if(e)then
e:ExplosiveAfter2()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
self.coroutine_process=nil
self:ExplosiveAllEnd()
end
)
else
ModulesInit.ProcedureNormalBattle.BattleRoundExplosiveComplete()
end
end
function BattleTeam:CheckHasCanExplosiveHero()
local t=false
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
if(e:CanExplosiveHero())then
t=true
break
end
end
end
end
return t
end
function BattleTeam:BattleRoundBeginExplosive()
if GameInit.DebugLog and ModulesInit.ProcedureNormalBattle.IsOpenReadOperCommond then
local e=self:GetFightAction()
self.actionData_Big=self:GetFightActionWithType(e,1)
self.actionData_Normal=self:GetFightActionWithType(e,2)
end
local t=false
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
if(e:CanExplosiveHero())then
t=true
break
end
end
end
end
if(t)then
self:ExplosiveAll()
else
ModulesInit.ProcedureNormalBattle.BattleRoundExplosiveComplete()
end
end
function BattleTeam:ExplosiveAll()
self:StopProcessCoroutine()
self.coroutine_process=o.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
if(e:CanExplosiveHero())then
e:Explosive(false)
end
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
if(e:CanExplosiveHero())then
e:ExplosiveAfter(false)
end
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
if(e:CanExplosiveHero())then
e:ExplosiveAfter2(false)
end
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
self.coroutine_process=nil
self:ExplosiveAllEnd()
end
)
end
function BattleTeam:ExplosiveAllEnd()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
ModulesInit.ProcedureNormalBattle.AddTimer(e)
e:Init(
0,
1,
1,
nil,
nil,
function()
ModulesInit.ProcedureNormalBattle.RemoveTimer(e)
ModulesInit.ProcedureNormalBattle.BattleRoundExplosiveComplete()
end
):Run()
else
ModulesInit.ProcedureNormalBattle.BattleRoundExplosiveComplete()
end
end
function BattleTeam:CancelExplosive()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
e:CancelExplosive()
end
end
end
ModulesInit.ProcedureNormalBattle.BattleRoundExplosiveComplete()
end
function BattleTeam:SetCurrRoundCanTriggerSmallSkill()
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
e:SetCurrRoundCanTriggerSmallSkill()
end
end
function BattleTeam:HasCanBigAttackHero()
for t,e in ipairs(self.HeroCtrls)do
if(e:GetCanBigAttack())then
return true
end
end
return false
end
function BattleTeam:GetBigAttackTask()
for e=1,#self.HeroCtrls do
local e=self.HeroCtrls[e]
if e~=nil and e:GetCanBigAttack()then
local e={
heroId=e.HeroId,
fireHeroId=nil,
actionType=EBattleActionType.BigSkill
}
return e
end
end
end
function BattleTeam:SetBigAttackManualTask(e)
self.mBigAttackManualTask=e
end
function BattleTeam:PickBigAttackManualTask()
local e=self.mBigAttackManualTask
self.mBigAttackManualTask=nil
return e
end
function BattleTeam:GetNextWillBigAttackManualTask()
return self.mBigAttackManualTask
end
function BattleTeam:GetNormalAttackTask()
for e=1,#self.HeroCtrls do
local e=self.HeroCtrls[e]
if e~=nil and e:GetCanNormalAttack(false)then
local e={
heroId=e.HeroId,
fireHeroId=nil,
actionType=EBattleActionType.NormalOrSmallSkill
}
return e
end
end
end
function BattleTeam:GetPetAttackTask(t)
for e=1,#self.PetCtrls do
local e=self.PetCtrls[e]
if self:CheckPetTriggerTime(e,t)then
if e~=nil and e:GetCanPetFightAttack(e.PetFightSkillId,t)then
local e={
heroId=e.HeroId,
fireHeroId=nil,
actionType=EBattleActionType.PetFightSkill,
triggerTime=t,
}
return e
end
end
end
end
function BattleTeam:CheckPetTriggerTime(t,e)
if t:IsFightPet()then
if e==BuffTriggerTime.bigRoundEndPetFightSkill then
return true
end
else
if e~=BuffTriggerTime.bigRoundEndPetFightSkill then
return true
end
end
return false
end
function BattleTeam:GetBigAttackTaskFightPlay()
self.CurrAttackHeroIndex=self.CurrAttackHeroIndex+1
local e=self.actionData_Big[self.CurrAttackHeroIndex]
return e
end
function BattleTeam:GetNextWillBigAttackTaskFightPlay()
local e=self.CurrAttackHeroIndex+1
local e=self.actionData_Big[e]
return e
end
function BattleTeam:GetNormalAttackTaskFightPlay()
self.CurrAttackHeroIndex=self.CurrAttackHeroIndex+1
local e=self.actionData_Normal[self.CurrAttackHeroIndex]
return e
end
function BattleTeam:GetNextWillNormalAttackTaskFightPlay()
local e=self.CurrAttackHeroIndex+1
local e=self.actionData_Normal[e]
return e
end
function BattleTeam:GetHandNormalAttackTask()
local e=List.PopFront(self.SmallSkillAttackQueue)
while e do
if e:GetCanNormalAttack(false)then
local e={
heroId=e.HeroId,
fireHeroId=nil,
actionType=EBattleActionType.NormalOrSmallSkill
}
return e
else
e=List.PopFront(self.SmallSkillAttackQueue)
end
end
end
function BattleTeam:GetNextHandNormalAttackTask()
local t=self.SmallSkillAttackQueue.first
local e=self.SmallSkillAttackQueue.last
for e=t,e do
local e=self.SmallSkillAttackQueue[e]
if e:GetCanNormalAttack(false)then
local e={
heroId=e.HeroId,
fireHeroId=nil,
actionType=EBattleActionType.NormalOrSmallSkill
}
return e
end
end
return nil
end
function BattleTeam:HandleNormalAttackManualComplete()
if ModulesInit.ProcedureNormalBattle.CheckBattleEnd()
or self.OpponentTeam:IsAllFreeze()
or self:CheckHasCanNormalAttackHero()==false
then
ModulesInit.ProcedureNormalBattle.BattleRoundEndCheckBuff()
return
end
if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then
self:BeginHeroNormalAttack()
else
ModulesInit.ProcedureNormalBattle:CheckSetReadyHeadIconTipScale()
end
end
function BattleTeam:BeginHeroBigAttack()
self:BeginAttackTask()
end
function BattleTeam:GetFightAction()
local e=ModulesInit.ProcedureNormalBattle.FightPlay_CurrWave.bigRoundData
for t,e in pairs(e)do
if(e.bigRoundNo==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)then
local e=e.smallRoundData
for t,e in pairs(e)do
if(e.smallRoundNo==ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound)then
return e.actionData
end
end
end
end
return nil
end
function BattleTeam:GetSupplementData()
local e=ModulesInit.ProcedureNormalBattle.FightPlay_CurrWave.bigRoundData
for t,e in pairs(e)do
if(e.bigRoundNo==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)then
local e=e.smallRoundData
for t,e in pairs(e)do
if(e.smallRoundNo==ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound)then
return e.supplementData
end
end
end
end
return nil
end
function BattleTeam:GetFightActionWithType(t,a)
local e={}
if(t==nil)then
return e
end
for o,t in pairs(t)do
if(t.actionType==a)then
table.add(e,t)
end
end
return e
end
function BattleTeam:BeginHeroBigAttack_FightPlay()
self:BeginAttackTask()
end
function BattleTeam:BeginHeroNormalAttack()
self:BeginAttackTask()
end
function BattleTeam:BeginPetAttack(t,e)
self:BeginAttackTask(t,e)
end
function BattleTeam:BeginTeamAttack(e,t)
self:BeginAttackTask(e,t)
end
function BattleTeam:BeginHeroNormalAttack_FightPlay()
self:BeginAttackTask()
end
function BattleTeam:BeginAttackTask(t,e)
self.CurrAttackHeroIndex=0
self.CurrAttackHeroCtrl=nil
self.IsHeroAttacking=false
ModulesInit.ProcedureNormalBattle.StartAttackTask(t,e)
end
function BattleTeam:ResetExplosiveState()
for t,e in ipairs(self.HeroCtrls)do
e.HasBeenExplosive=false
end
end
function BattleTeam:ResetHerosRoundIsAttack(t)
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e)then
if(t)then
e.CurrRoundIsBigSkillAttack=false
else
e.CurrRoundIsNormalSkillAttack=false
end
end
end
end
function BattleTeam:ResetPetRoundIsAttack(e)
local e=#self.PetCtrls
for e=1,e do
local e=self.PetCtrls[e]
if(e)then
e.CurrRoundIsPetFightSkillAttack=false
end
end
end
function BattleTeam:ShowOrHideBattleBeginEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e and e.HeroHeadItem~=nil)then
e.HeroHeadItem:ShowOrHideBattleBeginEffect(true)
end
end
end
function BattleTeam:HideHeadMask()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e and e.HeroHeadItem~=nil)then
e.HeroHeadItem:HideHeadMask()
end
end
end
function BattleTeam:HideBigSkillStatus()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
for t,e in ipairs(self.HeroCtrls)do
if(e and e.HeroHeadItem~=nil)then
e.HeroHeadItem:HideBigSkillStatus()
end
end
end
function BattleTeam:HideAllEffectStatusAndShowMask()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
for t,e in ipairs(self.HeroCtrls)do
if(e and e.HeroHeadItem~=nil)then
e.HeroHeadItem:HideAllEffectStatusAndShowMask()
end
end
end
function BattleTeam:CheckHasCanBigAttackHero()
for t,e in ipairs(self.HeroCtrls)do
if(e and e:GetCanBigAttack())then
return true
end
end
return false
end
function BattleTeam:CheckBattleEndWhenBigAttackManual()
if(ModulesInit.ProcedureNormalBattle.CheckBattleEnd())then
ModulesInit.ProcedureNormalBattle.BattleRoundEndCheckBuff()
return
end
if(not self:CheckHasCanBigAttackHero())then
ModulesInit.ProcedureNormalBattle.BattleRoundNormalSkill()
else
if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then
self:BeginHeroBigAttack()
else
ModulesInit.ProcedureNormalBattle:CheckSetReadyHeadIconTipScale()
end
end
end
function BattleTeam:CheckHasCanNormalAttackHero()
for t,e in ipairs(self.HeroCtrls)do
if(e:GetCanNormalAttack(false))then
return true
end
end
return false
end
function BattleTeam:GetHeroCtrlWithAttrId(e,t,a)
return self:GetHeroCtrlWithAttrIdWithExcludeHeroId(e,t,a,0)
end
function BattleTeam:GetHeroCtrlWithAttrIdWithExcludeHeroId(e,n,i,t)
local a={}
local o=#self.HeroCtrls
for e=1,o do
local e=self.HeroCtrls[e]
if(e.HeroBattleInfo and e.HeroId~=t)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
a[#a+1]=e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(e==HeroAttrId.hpPer)then
table.sort(
a,
function(e,t)
if(i)then
if(e:CurrHPPer()>t.HeroBattleInfo:CurrHPPer())then
return true
elseif(e:CurrHPPer()==t:CurrHPPer())then
return e.HeroId>t.HeroId
end
return false
else
if(e:CurrHPPer()<t:CurrHPPer())then
return true
elseif(e:CurrHPPer()==t:CurrHPPer())then
return e.HeroId>t.HeroId
end
return false
end
end
)
else
table.sort(
a,
function(a,t)
if(i)then
if(a.HeroBattleInfo:GetAttrValue(e)>t.HeroBattleInfo:GetAttrValue(e))then
return true
elseif(a.HeroBattleInfo:GetAttrValue(e)==t.HeroBattleInfo:GetAttrValue(e))then
return a.HeroId>t.HeroId
end
return false
else
if(a.HeroBattleInfo:GetAttrValue(e)<t.HeroBattleInfo:GetAttrValue(e))then
return true
elseif(a.HeroBattleInfo:GetAttrValue(e)==t.HeroBattleInfo:GetAttrValue(e))then
return a.HeroId>t.HeroId
end
return false
end
end
)
end
local e={}
o=#a
for t=1,o do
if(t<=n)then
e[#e+1]=a[t]
end
end
return e
end
function BattleTeam:ChangeToIdle(a,t)
self:StopProcessCoroutine()
self.coroutine_process=o.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
for t,e in ipairs(self.HeroCtrls)do
if(e and e.HeroBattleInfo)then
if(e:IsUsualState()and e.HeroBattleInfo:HasReposeControlBuff()==false and e:IsHeroSpecialState()==false)then
e.CurrFsm.ParamDic["changeToIdleType"]=a
e:ChangeState(HeroState.Idle)
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
self.coroutine_process=nil
if t then
t()
end
end
)
end
function BattleTeam:GetMaxChangeToIdleNeedTime()
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t and t.ChangeToIdleNeedTime>e)then
e=t.ChangeToIdleNeedTime
end
end
return e
end
function BattleTeam:ChangeToRun()
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:ChangeState(HeroState.Run)
end
end
for t,e in ipairs(self.PetCtrls)do
if(e)then
e:ChangeState(HeroState.Run)
end
end
end
function BattleTeam:CheckHeroDie(a)
self:StopProcessCoroutine()
self.coroutine_process=o.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
for e=#self.HeroCtrls,1,-1 do
local e=self.HeroCtrls[e]
if(e and e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP<=0 or e:IsDeathWaitState())then
if(e:IsDeathState()==false and(e:IsDeathWaitState()or e:IsUsualState()or e:IsLeaveStateOrType()))then
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview then
local t=e:GetHeroPreviewDeadState()
if t==ModulesInit.BattlePreviewMgr.EHeroDeadState.KneelOnDie
or t==ModulesInit.BattlePreviewMgr.EHeroDeadState.KneelOnDieAndAudio then
e:ChangePreviewDeadState(t)
else
self:DoHeroDieInTimeLine(e)
self:DoHeroDieInLogic(e)
end
else
if ModulesInit.ProcedureNormalBattle.isTimeLine then
self:DoHeroDieInTimeLine(e)
else
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
self:DoHeroDieInTimeLine(e)
end
self:DoHeroDieInLogic(e)
end
end
end
else
if e.needChangeSepsisHP~=0 then
e:ShowTimeLineSepsisHp()
else
e:CheckShowImmuneSepsisHpEffect()
end
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
self.coroutine_process=nil
if a then
a()
end
end
)
end
function BattleTeam:CheckHeroDieWhenWaiting()
for e=#self.HeroCtrls,1,-1 do
local e=self.HeroCtrls[e]
if(e and e.HeroBattleInfo)then
if e:IsDeathWaitState()then
e:ChangeDeathState()
end
end
end
end
function BattleTeam:ResetBuffInCurAttack()
for e=#self.HeroCtrls,1,-1 do
local e=self.HeroCtrls[e]
if(e and e.HeroBattleInfo)then
e:CheckClearOnAttackBuff()
end
end
end
function BattleTeam:DoHeroDieInTimeLine(e)
if e.willNotUsualStateInTimeLine==true then
return
end
local t=e:GetHeroMustDie()
if t then
e:PlayDeadAnimInTimeLine()
return
end
if e:IsLeaveStateOrType()then
return
end
local t=false
local a=e:GetPreviewHeroSpecialState()
if a==HeroSpecialState.Tomb then
t=true
end
local o=e:IsHeroSpecialState()
e.willNotUsualStateInTimeLine=true
if o then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:PlayDeadAnimInTimeLine()
elseif(e.WillNotUsual==true)then
if(e.NotUsualType==HeroState.Freeze)then
e:CheckPlayFreezeAnimInTimeLine(t)
elseif(e.NotUsualType==HeroState.DyingState)then
e:PlayDyingAnimInTimeLine()
elseif(e.NotUsualType==HeroState.UnDead)then
e:CheckPlayUndeadAnimInTimeLine(t)
end
elseif self:DoHeroDieInTimeLineImmuneAvoidDeath11(e,t)then
elseif self:DoHeroDieInTimeLineImmuneAvoidDeath(e,t)then
elseif self:DoHeroDieInTimeLineResurgence11(e,t)then
elseif self:DoHeroDieInTimeLineResurgence(e,t)then
else
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.idle)then
if(e.HeroBattleInfo.CurrHP==0 and e.CurrBattleTeam.TeamId==1)then
e:PlayDyingAnimInTimeLine()
else
if e:IsImmortalState()==true then
e:PlayStandAnimInTimeLine()
return
end
e:PlayDeadAnimInTimeLine()
end
else
if e:IsImmortalState()==true then
e:PlayStandAnimInTimeLine()
return
end
if a==HeroSpecialState.Ice then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:PlayIceAnimInTimeLine()
elseif a==HeroSpecialState.Mute then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:PlayDyingAnimInTimeLine()
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:PlayDeadAnimInTimeLine()
end
end
end
end
function BattleTeam:DoHeroDieInTimeLineImmuneAvoidDeath11(t,o)
if t.ImmuneAvoidDeath>EBuffTriggerlLevel.Eleven then
return false
end
local e=t.HeroBattleInfo:GetBuff(303111010)
local a=false
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303111010)
if t.CheckCondition(e)then
a=true
end
end
if a==true then
if e.isExcuteInTimeLine~=true then
e.isExcuteInTimeLine=true
t:CheckPlayStandAnimInTimeLine(o)
t.willNotUsualStateInTimeLine=false
end
else
return false
end
return true
end
function BattleTeam:DoHeroDieInTimeLineImmuneAvoidDeath(e,t)
if e.ImmuneAvoidDeath>EBuffTriggerlLevel.Zero then
return false
end
local u=e.HeroBattleInfo:GetBuff(302107018)
local c=e.HeroBattleInfo:GetBuff(303107018)
local o=e.HeroBattleInfo:GetBuff(92270)
local I=false
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(92270)
if e.CheckCondition(o)then
I=true
end
end
local n=e.HeroBattleInfo:GetBuff(92430)
local _=false
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(92430)
if e.CheckCondition(n)then
_=true
end
end
local s=e.HeroBattleInfo:GetBuff(92431)
local z=false
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(92431)
if e.CheckCondition(s)then
z=true
end
end
local x=e.HeroBattleInfo:GetBuff(30105617)
local l=e.HeroBattleInfo:GetBuff(30103008)
local v=e.HeroBattleInfo:GetBuff(302107019)
local b=e.HeroBattleInfo:GetBuff(303107019)
local r=e.HeroBattleInfo:GetBuff(302107311)
local h=e.HeroBattleInfo:GetBuff(30106216)
local E=false
if h then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(30106216)
if e.CheckRageInFatalDmg(h)then
E=true
end
end
local T=e.HeroBattleInfo:GetBuff(302107605)
local A=false
local d=e.HeroBattleInfo:GetBuff(302108111)
if d then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302108111)
if e.CheckIgnoreDead(d)then
A=true
end
end
local w=e.HeroBattleInfo:GetBuff(30103104)
local p=e.HeroBattleInfo:GetBuff(30105006)
local O=e.HeroBattleInfo:GetBuff(30106013)
local i=e.HeroBattleInfo:GetBuff(302102509)
if i then
local e=e.HeroBattleInfo:GetBuff(302102508)
if e==nil then
i=nil
end
end
local N=e.HeroBattleInfo:GetBuff(43142)
local a=e.HeroBattleInfo:GetBuff(302103916)
local D=false
if a then
D=true
end
local R=e.HeroBattleInfo:GetBuff(302107916)
local j=e.HeroBattleInfo:GetBuff(302108006)
local y=e.HeroBattleInfo:GetBuff(302108623)
if y then
local e=e.HeroBattleInfo:GetBuff(302108610)
if e==nil then
y=nil
end
end
local L=e.HeroBattleInfo:GetBuff(302108826)
local C=e.HeroBattleInfo:GetBuff(302109012)
local U=e.HeroBattleInfo:GetBuff(302110118)
local a=e.HeroBattleInfo:GetBuff(303102509)
if a then
local e=e.HeroBattleInfo:GetBuff(303102508)
if e==nil then
a=nil
end
end
local f=e.HeroBattleInfo:GetBuff(303107311)
local M=e.HeroBattleInfo:GetBuff(303107916)
local q=e.HeroBattleInfo:GetBuff(303110510)
local m=e.HeroBattleInfo:GetBuff(303111010)
local H=false
if m then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303111010)
if e.CheckCondition(m)then
H=true
end
end
local k=e.HeroBattleInfo:GetBuff(303111310)
local S=false
if k then
if e.HeroBattleInfo:GetBuff(303111320)then
S=true
end
end
local g=e.HeroBattleInfo:GetBuff(303112310)
if u and u.isExec==false and u.isExcuteInTimeLine~=true then
u.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif c and c.isExec==false and c.isExcuteInTimeLine~=true then
c.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif I==true and o.isExcuteInTimeLine~=true then
o.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
if t==false then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(92270)
e.ShowTreasure(o)
end
e.willNotUsualStateInTimeLine=false
elseif _==true and n.isExcuteInTimeLine~=true then
n.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
if t==false then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(92430)
e.ShowTreasure(n)
end
e.willNotUsualStateInTimeLine=false
elseif z==true and s.isExcuteInTimeLine~=true then
s.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
if t==false then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(92431)
e.ShowTreasure(s)
end
e.willNotUsualStateInTimeLine=false
elseif x and x.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif O and O.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif i and i.isExec==false and i.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif l and l.isExec==false and l.isExcuteInTimeLine~=true then
l.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif v and v.isExcuteInTimeLine~=true then
v.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif b and b.isExcuteInTimeLine~=true then
b.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif r and r.isExec==false and r.isExcuteInTimeLine~=true then
r.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif N and N.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif D then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif R and R.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif y and y.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif j and j.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif L and L.isExec==false then
e:CheckPlayUndead2AnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif C and C.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif U and U.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif h and E==true and h.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif T and T.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif A and d.isExcuteInTimeLine~=true then
d.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif w and w.isExec==false and w.isExcuteInTimeLine~=true then
w.isExcuteInTimeLine=true
e:CheckPlayUndeadAnimInTimeLine(t)
elseif a and a.isExec==false and a.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif p and p.isExec==false and p.isExcuteInTimeLine~=true then
p.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif f and f.isExec==false and f.isExcuteInTimeLine~=true then
f.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif M and M.isExec==false then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif q and q.isExec==false and q.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
elseif H==true then
if m.isExcuteInTimeLine~=true then
m.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
end
elseif S==true then
if k.isExcuteInTimeLine~=true then
k.isExcuteInTimeLine=true
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
end
elseif g and g.isExec==false and g.isExcuteInTimeLine~=true then
e:CheckPlayStandAnimInTimeLine(t)
e.willNotUsualStateInTimeLine=false
else
return false
end
return true
end
function BattleTeam:DoHeroDieInTimeLineResurgence(e,t)
if e.ImmuneResurgence>EBuffTriggerlLevel.Zero then
return false
end
local N=e.HeroBattleInfo:GetBuff(60062)
local I=e.HeroBattleInfo:GetBuff(30104301)
local h=e.HeroBattleInfo:GetBuff(302104301)
local d=e.HeroBattleInfo:GetBuff(92191)
local r=e.HeroBattleInfo:GetBuff(3053)
local s=e.HeroBattleInfo:GetBuff(30221)
local k=e.HeroBattleInfo:GetBuff(30109903)
local u=e.HeroBattleInfo:GetBuff(30106115)
local _=e.HeroBattleInfo:GetBuff(30106609)
local z=e.HeroBattleInfo:GetBuff(30106419)
local x=e.HeroBattleInfo:GetBuff(30106712)
local T=e.HeroBattleInfo:GetBuff(302101219)
local i=e.HeroBattleInfo:GetBuff(302101503)
local A=e.HeroBattleInfo:GetBuff(302107711)
local a=e.HeroBattleInfo:GetBuff(302107820)
local M=false
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302107820)
if e.CheckCondition(a)then
M=true
end
end
local n=e.HeroBattleInfo:GetBuff(302107521)
local O=e.HeroBattleInfo:GetBuff(302108222)
local j=e.HeroBattleInfo:GetBuff(302108318)
local E=e.HeroBattleInfo:GetBuff(302108416)
local q=e.HeroBattleInfo:GetBuff(302108509)
local w=e.HeroBattleInfo:GetBuff(302108909)
local f=e.HeroBattleInfo:GetBuff(303101219)
local l=e.HeroBattleInfo:GetBuff(303101503)
local m=e.HeroBattleInfo:GetBuff(303104420)
local c=e.HeroBattleInfo:GetBuff(303110616)
local y=e.HeroBattleInfo:GetBuff(303110705)
local v=e.HeroBattleInfo:GetBuff(303110913)
local p=e.HeroBattleInfo:GetBuff(303111112)
local g=e.HeroBattleInfo:GetBuff(303111214)
local o=e.HeroBattleInfo:GetBuff(303111509)
local C=false
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303111509)
if e.CheckCondition(o)then
C=true
end
end
local b=e.HeroBattleInfo:GetBuff(303111317)
local S=e.HeroBattleInfo:GetBuff(303111714)
local L=e.HeroBattleInfo:GetBuff(303111805)
local H=e.HeroBattleInfo:GetBuff(303111912)
local U=e.HeroBattleInfo:GetBuff(303112016)
local D=e.HeroBattleInfo:GetBuff(303112107)
local R=e.HeroBattleInfo:GetBuff(308200202)
if N and N.isExec==false and N.isExcuteInTimeLine~=true then
N.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif I and I.isExec==false and I.isExcuteInTimeLine~=true then
I.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif h and h.isExec==false and h.isExcuteInTimeLine~=true then
h.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif r and r.isExec==false and r.isExcuteInTimeLine~=true then
r.isExcuteInTimeLine=true
e:CheckPlayFreezeAnimInTimeLine(t)
elseif s and s.isExec==false and s.isExcuteInTimeLine~=true then
s.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif k and k.isExec==false and k.isExcuteInTimeLine~=true then
k.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif u and u.isExec==false and u.isExcuteInTimeLine~=true then
u.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif _ and _.isExec==false and _.isExcuteInTimeLine~=true then
_.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif z and z.isExec==false and z.isExcuteInTimeLine~=true then
z.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif x and x.isExec==false and x.isExcuteInTimeLine~=true then
x.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif i and i.isExec==false and i.isExcuteInTimeLine~=true then
i.isExcuteInTimeLine=true
e:CheckPlayFreezeAnimInTimeLine(t)
if t==false then
i:PlayBuffPrefabEffect(EBuffEffectType.buffDoActionTrigger)
end
elseif T and T.isExec==false and T.isExcuteInTimeLine~=true then
T.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine(false)
elseif A and A.isExec==false and A.isExcuteInTimeLine~=true then
A.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif a and a.isExec==false and a.isExcuteInTimeLine~=true and M==true then
a.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif n and n.isExec==false and n.isExcuteInTimeLine~=true then
n.isExcuteInTimeLine=true
e:CheckPlayFreezeAnimInTimeLine(t)
if t==false then
n:PlayBuffPrefabEffect(EBuffEffectType.buffDoActionTrigger)
end
elseif O and O.isExec==false and O.isExcuteInTimeLine~=true then
O.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif j and j.isExec==false and j.isExcuteInTimeLine~=true then
j.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif E and E.isExec==false and E.isExcuteInTimeLine~=true then
E.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif q and q.isExec==false and q.isExcuteInTimeLine~=true then
q.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif w and w.isExec==false and w.isExcuteInTimeLine~=true then
w.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif f and f.isExec==false and f.isExcuteInTimeLine~=true then
f.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine(false)
elseif l and l.isExec==false and l.isExcuteInTimeLine~=true then
l.isExcuteInTimeLine=true
e:CheckPlayFreezeAnimInTimeLine(t)
elseif m and m.isExec==false and m.isExcuteInTimeLine~=true then
m.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif c and c.isExec==false and c.isExcuteInTimeLine~=true then
c.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif y and y.isExec==false and y.isExcuteInTimeLine~=true then
y.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif v and v.isExec==false and v.isExcuteInTimeLine~=true then
v.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif p and p.isExec==false and p.isExcuteInTimeLine~=true then
p.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif g and g.isExec==false and g.isExcuteInTimeLine~=true then
g.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif o and o.isExec==false and o.isExcuteInTimeLine~=true and C==true then
o.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif b and b.isExec==false and b.isExcuteInTimeLine~=true then
b.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif S and S.isExec==false and S.isExcuteInTimeLine~=true then
S.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif L and L.isExec==false and L.isExcuteInTimeLine~=true then
L.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif H and H.isExec==false and H.isExcuteInTimeLine~=true then
H.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif U and U.isExec==false and U.isExcuteInTimeLine~=true then
U.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif D and D.isExec==false and D.isExcuteInTimeLine~=true then
D.isExcuteInTimeLine=true
e:CheckPlayFreezeAnimInTimeLine(t)
elseif d and d.isExec==false and d.isExcuteInTimeLine~=true then
d.isExcuteInTimeLine=true
e:PlayDyingAnimInTimeLine()
elseif R and R.isExec==false and R.isExcuteInTimeLine~=true then
R.isExcuteInTimeLine=true
e:CheckPlayDeadAnimInTimeLine(t)
else
return false
end
return true
end
function BattleTeam:DoHeroDieInTimeLineResurgence11(t,o)
if t.ImmuneResurgence>EBuffTriggerlLevel.Eleven then
return false
end
local e=t.HeroBattleInfo:GetBuff(303111004)
local a=0
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303111004)
a=t.CheckConditionInTimeline(e)
end
if a>0 then
if e.isExcuteInTimeLine~=true then
e.isExcuteInTimeLine=true
if a==1 then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(303111004)
a.DoActionInTimeline(e)
t:PlayDyingAnimInTimeLine(o)
else
t:CheckPlayStandAnimInTimeLine(o)
t.willNotUsualStateInTimeLine=false
end
end
else
return false
end
return true
end
function BattleTeam:DoHeroDieInLogic(e)
e.willNotUsualStateInTimeLine=false
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.fatalDmg)
local t=e:GetHeroMustDie()
if t==false then
e:CheckExcuteWillHeroSpecialState(BuffTriggerTime.fatalDmg)
else
e.HeroBattleInfo.CurrHP=0
end
if e.HeroBattleInfo.CurrHP<=0 then
ModulesInit.ProcedureNormalBattle.SelectFireHero=nil
ModulesInit.ProcedureNormalBattle.HideFireEffect()
ModulesInit.ProcedureNormalBattle.AutoSelectFireHero()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t==false and e.WillNotUsual==true and e:IsLeaveType()==false and e:IsNothingToDoState()==false)then
e.WillNotUsual=false
if(e.NotUsualType==HeroState.Freeze)then
e:ChangeState(HeroState.Freeze)
elseif(e.NotUsualType==HeroState.DyingState)then
e:ChangeState(HeroState.DyingState)
end
else
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.idle)then
if(e.HeroBattleInfo.CurrHP==0 and e.CurrBattleTeam.TeamId==1)then
e.NotUsualType=HeroState.DyingState
e:ChangeState(HeroState.DyingState)
else
e:ChangeDeathState()
end
else
if e:IsImmortalState()==true then
if e.HeroBattleInfo.CurrHP<=0 then
e.HeroBattleInfo:SetHp(1)
end
e:PlayStandAnimInTimeLine()
return
end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.HeroDeadBefore)
e:HandleUndead()
e:CheckExcuteWillHeroSpecialState(BuffTriggerTime.HeroDeadBefore)
if e.HeroBattleInfo.CurrHP<=0 then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:ChangeDeathState()
end
end
end
end
end
function BattleTeam:BattleRoundBeginAddFuryWithSoul()
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:AddFuryWithSoul(SoulAddFuryType.roundRage)
if e:IsStakeFightOpenNewFury()then
e:AddFuryWithFakeFightParam(EFakeBattleParamType.test_defense_fury_constant)
e:AddFuryWithFakeFightParam(EFakeBattleParamType.test_defense_fury_losthp)
e:AddFuryWithSoulInStakeFight(SoulAddFuryType.startRage)
e:AddFuryWithSoulInStakeFight(SoulAddFuryType.defRage)
e:AddFuryWithSoulInStakeFight(SoulAddFuryType.deadRage)
e:AddFuryWithFakeFightParam(EFakeBattleParamType.test_fury_initial)
end
end
end
end
function BattleTeam:BattleRoundBeginCheckBuff()
local e=false
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t)then
local t=t:CheckBuff(BuffCheckTime.RoundBegin,BuffTriggerTime.eachRoundStart)or 0
e=math.max(e,t)
end
end
for a,t in ipairs(self.PetCtrls)do
if(t)then
local t=t:CheckBuff(BuffCheckTime.RoundBegin,BuffTriggerTime.eachRoundStart)or 0
e=math.max(e,t)
end
end
self:TriggerTeamBuff(BuffTriggerTime.eachRoundStart)
ModulesInit.ProcedureNormalBattle.CheckHeroDieWhenWaiting()
return e
end
function BattleTeam:BattleRoundEndCheckBuff()
local t=false
local e=a:GetNewTable(self.HeroCtrls)
for a,e in ipairs(e)do
if(e and e.HeroBattleInfo and e:CheckBuff(BuffCheckTime.RoundEnd,BuffTriggerTime.eachRoundEnd))then
t=true
end
end
local e=a:GetNewTable(self.PetCtrls)
for a,e in ipairs(e)do
if(e and e:CheckBuff(BuffCheckTime.RoundEnd,BuffTriggerTime.eachRoundEnd))then
t=true
end
end
ModulesInit.ProcedureNormalBattle.CheckHeroDieWhenWaiting()
return t
end
function BattleTeam:CheckSpecialBuffRound()
for t,e in ipairs(self.HeroCtrls)do
if e then
e:CheckSpecialBuffRound(BuffCheckTime.RoundEndLeftOrRight,BuffTriggerTime.eachRoundEnd)
end
end
self:CheckSpecialTeamBuffRound(BuffCheckTime.RoundEndLeftOrRight)
end
function BattleTeam:CheckSpecialTeamBuffRound(a)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:CheckSpecialBuffRound When isTimeLine!")
return
end
local e=self:GetCurTeamBuffSortArr()
for t=1,#e do
local e=e[t]
local t=e.buffId
if(e.round>0)then
local o=D:GetBuffCfg(t)
if(o.checkTime==a)then
e.round=e.round-1
e:OnRoundChange()
if(e.round==0)then
self:InnerRemoveCurTeamBuffWithId(t,BuffRemoveType.Expire)
end
end
end
end
end
function BattleTeam:AutoSelectFireHero()
for t,e in ipairs(self.HeroCtrls)do
if(e and e.HeroBattleInfo and e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
return e
end
end
return nil
end
function BattleTeam:IsAllDeath()
for t,e in ipairs(self.HeroCtrls)do
if(e and e.HeroBattleInfo and(e.HeroBattleInfo.CurrHP>0 or(e.HeroBattleInfo.CurrHP==0 and(e:IsNotUsualState()or e.WillNotUsual))))then
return false
end
end
return true
end
function BattleTeam:IsAllDeathOrTomb()
for t,e in ipairs(self.HeroCtrls)do
if e and e.HeroBattleInfo then
if e.HeroBattleInfo.CurrHP>0 and e:IsTombSpecialState()==false
or(e.HeroBattleInfo.CurrHP==0 and(e:IsNotUsualState()or e.WillNotUsual))
then
return false
end
end
end
return true
end
function BattleTeam:IsFullTombInAllPos()
local t=0
for a,e in ipairs(self.HeroCtrls)do
if e and e.HeroBattleInfo then
if e.HeroBattleInfo.CurrHP>0 and e:IsTombSpecialState()
then
t=t+1
end
end
end
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
return t==1
else
return t==6
end
end
function BattleTeam:IsAllDeathContainSupple()
if self:IsAllDeath()and self:GetSuppleHeroCount()<=0 then
return true
end
return false
end
function BattleTeam:CheckTeamBattleEndContainTomb()
local e=self:GetSuppleHeroCount()
if e<=0 then
if self:IsAllDeathOrTomb()then
return true
end
else
if self:IsFullTombInAllPos()then
return true
end
end
return false
end
function BattleTeam:GetTotalHP()
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t.HeroBattleInfo)then
e=e+t.HeroBattleInfo.CurrHP
end
end
if ModulesInit.ProcedureNormalBattle.BattleMode~=EBattleMode.formation1v1 then
e=e+self.TotalSuppleHP
end
return e
end
function BattleTeam:GetTotalArmor()
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t.HeroBattleInfo)then
e=e+t:GetArmor()
end
end
return e
end
function BattleTeam:GetFirstPlayerId()
for t,e in ipairs(self.HeroCtrls)do
return e.PlayerId
end
return 0
end
function BattleTeam:GetTotalMaxHP()
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t.HeroBattleInfo)then
e=e+t.HeroBattleInfo.MaxHP
end
end
if ModulesInit.ProcedureNormalBattle.BattleMode~=EBattleMode.formation1v1 then
if#self.mSupplementHeros>0 then
local t=self:CalculateHeroTotalMaxHp(self.mSupplementHeros)
e=e+t
end
local t=ModulesInit.ProcedureNormalBattle.GetTeamHerosByTeamId(self.TeamId)
if t and#t>0 then
local t=self:CalculateHeroTotalMaxHp(t)
e=math.max(e,t)
end
end
return e
end
function BattleTeam:GetTotalHPPercent()
local t=self:GetTotalHP()
local e=self:GetTotalMaxHP()
local a=0
if t>0 and e>0 then
a=t/e
end
return a
end
function BattleTeam:GetTotalMaxArmor()
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t.HeroBattleInfo)then
e=e+t.HeroBattleInfo.armor
end
end
return e
end
function BattleTeam:GetTotalAtk()
local e=0
for a,t in ipairs(self.HeroCtrls)do
e=e+t:GetFinalAtk()
end
return e
end
function BattleTeam:HasFirstRowHero()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if((e.HeroBattleInfo.CurrHP>0 or e:IsUsualState())and e.battleStationRow==1)then
return true
end
end
end
return false
end
function BattleTeam:HasLastRowHero()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if((e.HeroBattleInfo.CurrHP>0 or e:IsUsualState())and e.battleStationRow==2)then
return true
end
end
end
return false
end
function BattleTeam:CheckHurtValue(t)
self:StopProcessCoroutine()
self.coroutine_process=o.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:CheckHurtValue()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
end
end
self:RefreshTotalHP()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
self.coroutine_process=nil
if t then
t()
end
end
)
end
function BattleTeam:CheckHpHealth()
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:CheckHpHealth()
end
end
end
function BattleTeam:ResetHpHealthInTimeLine()
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:ResetHpHealthInTimeLine()
end
end
end
function BattleTeam:ResetAttrValuesInCurAttack()
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:ResetAttrValuesInCurAttack()
end
end
end
function BattleTeam:CheckBattleRoundBigAndSmallSkillStatus()
for t,e in ipairs(self.HeroCtrls)do
if(e)then
e:CheckBattleRoundBigAndSmallSkillStatus()
end
end
end
function BattleTeam:SetHeadIconTipScale(t)
for a,e in ipairs(self.HeroCtrls)do
if e then
if t==true and(e:GetCanBigAttack()or e:GetCanNormalAttack(true))then
e:SetHeadIconTipScale(true)
else
e:SetHeadIconTipScale(false)
end
end
end
end
function BattleTeam:RefreshTotalHP()
local e=self:GetTotalHP()
if(self.OnRefreshTotalHP)then
self.OnRefreshTotalHP(self.TotalMaxHP,self.PrevTotalHP,e)
end
self.PrevTotalHP=e
end
function BattleTeam:SaveHeroMaxHp()
self.TotalSuppleHP=self:CalculateHeroTotalHp(self.mSupplementHeros)
self.TotalMaxHP=self:GetTotalMaxHP()
end
function BattleTeam:CalculateHeroTotalMaxHp(t)
local e=0
for a=1,#t do
local t=self:CalculateHeroMaxHp(t[a])
e=e+t
end
return e
end
function BattleTeam:CalculateHeroMaxHp(t)
local e=0
local t=t.attribute
local a=#t
for a=1,a do
local t=t[a]
if(t.id==HeroAttrId.hp)then
e=t.value
break
end
end
return e
end
function BattleTeam:CalculateHeroTotalHp(t)
local e=0
for a=1,#t do
local t=self:CalculateHeroHp(t[a])
e=e+t
end
return e
end
function BattleTeam:CalculateHeroHp(e)
local t=0
local a=e.attribute
local o=#a
for e=1,o do
local e=a[e]
if(e.id==HeroAttrId.hp)then
t=e.value
break
end
end
if e then
if e.curHp and e.curHp>0 then
t=e.curHp
end
end
return t
end
function BattleTeam:RefreshTotalArmor()
local e=self:GetTotalArmor()
if(self.OnRefreshTotalArmor)then
self.OnRefreshTotalArmor(self.TotalMaxArmor,e)
end
end
function BattleTeam:GetDeathHeroCount()
local e=0
for a,t in ipairs(self.HeroCtrls)do
if(t.HeroBattleInfo)then
if(t.HeroBattleInfo.CurrHP<=0 and t:IsUsualState())then
e=e+1
end
end
end
return e
end
function BattleTeam:IsAllFreeze()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e.HeroBattleInfo.CurrHP>0 and e:IsUsualState())then
return false
end
end
end
return true
end
function BattleTeam:HasCanAttackHero()
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo and e.HeroBattleInfo.CurrHP>0 and e:IsUsualState()and e.HeroBattleInfo:HasStrongControlBuff()==false)then
return true
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
if e.HeroBattleInfo.CurrHP==0 then

elseif e:IsNotUsualState()then

elseif e.HeroBattleInfo:HasStrongControlBuff()then

end
end
end
end
return false
end
function BattleTeam:GetTeamCurrHPPer()
local a=0
local t=0
for o,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
t=t+e.HeroBattleInfo.MaxHP
a=a+e.HeroBattleInfo.CurrHP
end
end
return a/t*100
end
function BattleTeam:GetMaxProfessionCount(t)
local e=0
for o,a in ipairs(self.HeroCtrls)do
if(a.profession==t)then
e=e+1
end
end
return e
end
function BattleTeam:HpHealthToMax()
for t,e in ipairs(self.HeroCtrls)do
e:HpHealthToMax()
end
end
function BattleTeam:ClearAllGranBuff(t)
for a,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
e.HeroBattleInfo:ClearAllGranBuff(t)
end
end
end
function BattleTeam:DispelAllGranBuff(t)
for a,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
e.HeroBattleInfo:DispelAllGranBuff(t)
end
end
end
function BattleTeam:StartBackToBattleField()
local t=false
for a,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
if(e:IsNotUsualState()and(e.NotUsualType==HeroState.Leave))then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.backToBattleField)
if e.NotUsualType~=HeroState.Leave then
e.HeroBattleInfo:ClearAllControlBuff()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
e:ShowBackBattleField()
else
e:ChangeStateUnCheckState(HeroState.Idle)
end
t=true
end
end
end
end
return t
end
function BattleTeam:RemoveSupplementHero(t)
local e=#self.mSupplementHeros
for e=1,e do
local a=self.mSupplementHeros[e]
if(a.heroId==t)then
table.remove(self.mSupplementHeros,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
break
end
end
end
function BattleTeam:SupplementPosition(i,h,s,n)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
self.supplementData=self:GetSupplementData()
end
if(self.coroutine_SupplementPosition)then
o.stop(self.coroutine_SupplementPosition)
self.coroutine_SupplementPosition=nil
end
self.coroutine_SupplementPosition=o.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
local o=false
local t=self:GetHeroPosMap()
for a,e in ipairs(i)do
local t=t[e.position]
if ModulesInit.ProcedureNormalBattle.IsOpenPosition(e.position)
and t==nil
then
local a=0
local t=self:FindHeroInfoFromFightData(e.heroId)
if(t)then
a=t.playerId
end
local t
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
t=self:FindSupplementHero(e.position,a,i,h,s)
else
t=self:FindSupplementHeroFromFightPlayData(e.position)
end
if(t)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
o=true
self:RemoveSupplementHero(t.heroId)
e.heroId=t.heroId
local o={heroDid=t.heroDid,heroId=t.heroId}
local a=ModulesInit.ProcedureNormalBattle.IsOurTeam(self.TeamId)
ModulesInit.ProcedureNormalBattle.LoadPlayerHero(o,e.position-1,a,true)
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
FightDataReportMgr:AddSupplementData(e.position,t.heroId)
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if o==false then
if n then
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.WaitForSeconds(ConstBattleRunInBattleDuration))
end
end
ModulesInit.ProcedureNormalBattle.SupplementPositionComplete()
else
if ModulesInit.ProcedureNormalBattle.IsSkipBattle then
self:OnSupplementHeroEnterBattleComplete()
end
end
end)
end
function BattleTeam:OnSupplementHeroEnterBattleComplete()
local e=#self.HeroCtrls
for e=1,e do
local e=self.HeroCtrls[e]
if(e~=nil and e.mIsEnterBattle==false)then
return
end
end
ModulesInit.ProcedureNormalBattle.StartSupplementFightSuppress()
end
function BattleTeam:FindSupplementHeroFromFightPlayData(t)
if self.supplementData==nil then
local e=ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
return
end
for a,e in ipairs(self.supplementData)do
if(e.position==t)then
return self:FindHeroInfoFromFightData(e.heroId)
end
end
return nil
end
function BattleTeam:FindHeroInfoFromFightData(t)
local e=ModulesInit.ProcedureNormalBattle.GetTeamHerosByTeamId(self.TeamId)
for a,e in ipairs(e)do
if(e.heroId==t)then
return e
end
end
return nil
end
function BattleTeam:FindSupplementHero(e,o,i,t,a)
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
return self:FindSupplementHero1v1()
else
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.dragonWar then
return self:FindSupplementHeroDragon(e,o,t)
else
return self:FindSupplementHeroNormal(e,i,a)
end
end
end
function BattleTeam:FindSupplementHero1v1()
local e=self.mSupplementHeros
return e[1]
end
function BattleTeam:FindSupplementHeroNormal(a,t,e)
if e==nil then
return
end
local t
if e~=nil then
for o,e in pairs(e)do
if e.position==a then
t=e
break
end
end
end
if t then
for a,e in ipairs(self.mSupplementHeros)do
if(e.heroId==t.heroId)then
return e
end
end
end
local t={}
for a,e in ipairs(self.mSupplementHeros)do
if self:CheckHasHeroInMainFormaiton(e.positionInFormation)then
table.add(t,e)
end
end
if(#t==0)then
return
end
local function o(e)
return e<4
end
local e={}
for i,t in ipairs(t)do
if(o(t.positionInFormation)==o(a))then
table.add(e,t)
end
end
if(#e==0)then
for a,t in ipairs(t)do
table.add(e,t)
end
end
table.sort(e,function(t,e)
return t.positionInFormation<e.positionInFormation
end)
return e[1]
end
function BattleTeam:GetHeroPosInFormaiton(e,t)
for a,e in pairs(e)do
if e.heroId==t then
return e.position
end
end
return 0
end
function BattleTeam:CheckHasHeroInMainFormaiton(e)
local t=self:GetHeroPosMap()
local e=t[e]
if e==nil then
return false
end
return true
end
function BattleTeam:FindSupplementHeroDragon(n,a,t)
local e={}
for o,t in ipairs(self.mSupplementHeros)do
if(t.playerId==a)then
table.add(e,t)
end
end
if(#e==0)then
for a,t in ipairs(self.mSupplementHeros)do
table.add(e,t)
end
end
if#e==0 then
return
end
local o={}
for a=1,#t do
local e=t[a].heroId
if e~=0 and t[a].pos<=6 then
o[e]=true
end
end
local function i(e)
return o[e]==true
end
local a={}
for t=1,#e do
if i(e[t].heroId)==true then
table.insert(a,e[t])
end
end
if#a<=0 then
a=e
end
local function e(e)
local e=(e-1)%6+1
return e<4
end
local t={}
for o,a in ipairs(a)do
if(e(a.pos)==e(n))then
table.add(t,a)
end
end
if(#t==0)then
for a,e in ipairs(a)do
table.add(t,e)
end
end
local e={}
local function a(e)
return(e-1)%3
end
for o,t in ipairs(t)do
if(a(t.pos)==0)then
table.add(e,t)
end
end
if(#e==0)then
for o,t in ipairs(t)do
if(a(t.pos)==1)then
table.add(e,t)
end
end
end
if(#e==0)then
for o,t in ipairs(t)do
if(a(t.pos)==2)then
table.add(e,t)
end
end
end
local t={}
for a,e in ipairs(e)do
if(e.teamNO==1)then
table.add(t,e)
end
end
if(#t==0)then
for a,e in ipairs(e)do
if(e.teamNO==2)then
table.add(t,e)
end
end
end
if(#t==0)then
for a,e in ipairs(e)do
table.add(t,e)
end
end
return t[1]
end
function BattleTeam:OnHeroBigSkillAttack(e)
local e=e.heroId
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if(e)then
if(e.CurrBattleTeam.TeamId~=self.TeamId)then
if(self.enemyFirstBigSkill==false)then
self.enemyFirstBigSkill=true
for t,e in ipairs(self.HeroCtrls)do
if(e.HeroBattleInfo)then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyFirstBigSkill)
end
end
end
end
end
end
function BattleTeam:PrintHerosState()
for t,e in ipairs(self.HeroCtrls)do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function BattleTeam:SetAllPlayerReliveState()
for t,e in ipairs(self.HeroCtrls)do
e.WillNotUsual=true
e.NotUsualType=HeroState.DyingState
end
end
function BattleTeam:ReliveAllPlayers()
for e=1,#self.HeroCtrls do
self:RelivePlayer(e)
end
end
function BattleTeam:RelivePlayer(e)
local e=self.HeroCtrls[e]
if e then
local t=e.HeroBattleInfo.MaxHP
t=math.floor(t)
e:HpHealthWithResurgence(t)
e:ResetMaxFuryWithBuff()
e.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
e:ChangeStateUnCheckState(HeroState.Idle)
end
end
function BattleTeam:EnterBigSKillState(e)
local e=self.HeroCtrls[e]
if e then
e:ResetMaxFuryWithBuff()
e.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
e:ChangeStateUnCheckState(HeroState.Idle)
e:CheckBattleRoundBigAndSmallSkillStatus()
e:ShowHeroIconBigSkillState()
e:SetHeroPlayAttackLimit(EBattleAttackLimitType.BigSkill)
e:HideHeadMask()
end
end
function BattleTeam:BattleBigSKillEnter(e)
local e=self.HeroCtrls[e]
if e then
e:SetHeroPlayAttackLimit(EBattleAttackLimitType.BigSkill)
end
end
function BattleTeam:SetRoundCanTriggerSmallSkill(e)
for a,t in ipairs(self.HeroCtrls)do
t:SetRoundCanTriggerSmallSkill(e)
end
end
function BattleTeam:SetTriggerSmallSkillStatus(t)
for a,e in ipairs(self.HeroCtrls)do
e:SetTriggerSmallSkillStatus(t)
end
end
function BattleTeam:SetChaChaSureSmallSkill(e)
for a,t in ipairs(self.HeroCtrls)do
t:SetChaChaSureSmallSkill(e)
end
end
function BattleTeam:SetRoundHeroDieStatus(e)
self.HeroCtrls[e]:ChangeState(HeroState.DyingState)
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BATTLE_HERO_DYINGSTAGE"})
end
function BattleTeam:SetRoundHeroRelive(e)
self:RelivePlayer(e)
self.HeroCtrls[e].HeroHeadItem:HideHeadMask()
end
function BattleTeam:SupplementPositionWithHero(e,t)
local t={heroDid=e.heroDid,heroId=e.heroId}
ModulesInit.ProcedureNormalBattle.LoadPlayerHero(t,e.position-1,true,true)
FightDataReportMgr:AddSupplementData(e.position,e.heroId)
end
function BattleTeam:SetBigAttackWaiting(e)
self.IsBigAttackWaiting=e
if e==false then
ModulesInit.ProcedureNormalBattle.ResumeAttackTask()
end
end
function BattleTeam:GetBigAttackWaiting()
return self.IsBigAttackWaiting
end
function BattleTeam:SetSuppleMaxHp(e)
self.SuppleMaxHp=e
self:RefreshMaxHp()
end
function BattleTeam:RefreshMaxHp()
self.TotalMaxHP=self:GetTotalMaxHP()
self.TotalHP=self:GetTotalHP()
end
function BattleTeam:GetHeroCtrlByDid(t)
for a,e in ipairs(self.HeroCtrls)do
if e.heroDid==t then
return e
end
end
end
function BattleTeam:InitSupplementHerosData(o,t)
local function a(e)
for a,t in ipairs(o)do
if(e==t.heroId)then
return true
end
end
return false
end
for t,e in ipairs(t)do
if(not a(e.heroId))then
F(self.mSupplementHeros,e)
end
end
end
function BattleTeam:AddEmptyStatisticOnCurrWave(e,t)
if ModulesInit.ProcedureNormalBattle.FightPlayData==nil and#self.mSupplementHeros>0 then
for a=1,#self.mSupplementHeros do
FightDataReportMgr:AddEmptyStatisticOnCurrWave(self.mSupplementHeros[a],e,t)
end
end
end
function BattleTeam:GetSuppleHeroCount()
return#self.mSupplementHeros
end
function BattleTeam:SetCampionBuffId(e)
self.mCampionBuffId=e
end
function BattleTeam:GetCampionBuffId(e)
return self.mCampionBuffId
end
function BattleTeam:IsSkillAfterActionRunning(e)
for a,t in ipairs(self.HeroCtrls)do
if t:IsSkillAfterActionRunning(e)then
return true
end
end
return false
end
function BattleTeam:SetFirstAddRate(e)
self.mFirstAddRate=e
end
function BattleTeam:GetFirstAddRate()
return self.mFirstAddRate
end
function BattleTeam:SetOfficer(e)
self.mOfficer=e
end
function BattleTeam:GetOfficer()
return self.mOfficer
end
function BattleTeam:GetTotalFirstValueWithRate()
return math.floor(self.TotalFirstValue*(1+self.mFirstAddRate))
end
function BattleTeam:ClearAllHeroControlBuff()
local e=self:GetAllHeros()
for t,a in ipairs(e)do
local e=e[t]
if e and e.HeroBattleInfo then
e.HeroBattleInfo:RemoveControlBuff()
end
end
end
function BattleTeam:AllHeroRunInBattle()
local e=self:GetAllHeros()
for t,a in ipairs(e)do
local e=e[t]
e:HeroRunInBattle(false)
end
end
function BattleTeam:PlayNormalSkillAttackWithPosAndSmallSkill(e,t)
local e=self:GetHeroCtrlWithPos(e)
if e then
e:SetRoundCanTriggerSmallSkill(t)
List.PushBack(self.SmallSkillAttackQueue,e)
ModulesInit.ProcedureNormalBattle.EnterBattleRoundNormalSkill()
if(ModulesInit.ProcedureNormalBattle.CurrIsAttacking==false)then
ModulesInit.ProcedureNormalBattle.StartAttackTask()
end
end
end
function BattleTeam:PlayNormalSkillAttackWithPos(e)
self:PlayNormalSkillAttackWithPosAndSmallSkill(e,false)
end
function BattleTeam:PlaySmallSkillAttackWithPos(e)
self:PlayNormalSkillAttackWithPosAndSmallSkill(e,true)
end
function BattleTeam:PlayBigSkillAttackWithPos(e)
local e=self:GetHeroCtrlWithPos(e)
if e then
local t={
heroId=e.HeroId,
fireHeroId=nil,
actionType=1
}
self:SetBigAttackManualTask(t)
e:AddMaxFuryWithSkill()
ModulesInit.ProcedureNormalBattle.StartAttackTask()
end
end
function BattleTeam:GetTeamCurrSepsisHPTotalValue()
local e=0
for t=1,#self.HeroCtrls do
e=e+self.HeroCtrls[t].HeroBattleInfo.CurrSepsisHp
end
return e
end
function BattleTeam:CheckDoAction(a)
if a==nil then
return false
end
if a.skillDid==nil then
return true
end
local e=a.skillData
if e==nil then
return true
end
local t=e.buffId
if t==nil then
return true
end
local o=self:GetCurTeamBuff(t)
if o==nil then
return false
end
local i=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if(i==nil)then
GameInit.LogError("对应的Buff脚本不存在 buffId %s",t)
return false
end
if i.HandleOnDoAction==nil then
return true
end
local a,t=i.HandleOnDoAction(o,o.buffData,a)
if t then
e=t
end
return a,e
end
function BattleTeam:AddTeamBuff(d,e,n,r,o,u)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return false
end
if(e==nil)then
GameInit.LogError("对应的Buff不存在 buffId 异常")
return false
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local i=D:GetBuffCfg(e)
if(i==nil)then
GameInit.LogError("对应的Buff不存在 buffId %s",e)
return false
end
local h=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if(h==nil)then
GameInit.LogError("对应的Buff脚本不存在 buffId %s",e)
return false
end
if(o)then
if i.layerLimit>=0 then
o=math.min(o,i.layerLimit)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local t=self:GetTeamBuffFromGroup(e,d)
local s
if t then
s=a:CompareBuffPriority(h,i,t,t.round,t.buffData,n,r)
if s==EBuffPriorityResult.Same then
return false
end
end
local l=1000
if u then
l=u.battleStationIndex or l
end
local t=HeroBuffInfo:New(nil)
t.buffId=e
t.releaseHeroId=d
t.round=n
t.floors=(o==nil and 1 or o)
t.isGran=i.isGran
t.teamId=self.TeamId
t.battleStationIndex=l
t:AddBuffData(r)
self:AddTeamBuffToGroup(t)
local o=t
local t=self:GetCurTeamBuff(e)
if(t~=nil)then
if t.releaseHeroId==d then
if s==EBuffPriorityResult.Better then
self:InnerRemoveCurTeamBuffWithId(e,BuffRemoveType.Expire)
elseif s==EBuffPriorityResult.Worse then
self:InnerRemoveCurTeamBuffWithId(e,BuffRemoveType.Expire)
o=self:GetBestTeamBuffFromGroup(e)
else
return false
end
else
local t=a:CompareBuffPriority(h,i,t,t.round,t.buffData,n,r)
if t==EBuffPriorityResult.Better then
self:InnerRemoveCurTeamBuffWithId(e,BuffRemoveType.Expire)
elseif t==EBuffPriorityResult.Worse then
return false
else
return false
end
end
end
if o then
self:InnerSetCurTeamBuff(o)
return true
else
return false
end
end
function BattleTeam:InnerRemoveCurTeamBuffWithId(o,e)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return false
end
local t=self:GetCurTeamBuff(o)
if t==nil then
return false
end
local i=D:GetBuffCfg(o)
if(e==BuffRemoveType.Dispel
or e==BuffRemoveType.Dying)then
if(i.canDispel<=0)then
return false
elseif(i.canDispel==2)then
local e=t:GetFloors()
if e>1 then
t:ReduceFloors(1)
return true
end
end
elseif(e==BuffRemoveType.BeStolen)then
if(a:IsCanStealBuff(i))==false then
return false
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:ClearTeamBuff(t,e)
self.mTeamBuffDic[o]=nil
return true
end
function BattleTeam:InnerSetCurTeamBuff(e)
local t=e.buffId
e:OnAdd()
self.mTeamBuffDic[t]=e
if e:GetCanTrigger(BuffTriggerTime.now)then
e:DoAction(BuffTriggerTime.now)
end
end
function BattleTeam:GetCurTeamBuff(e)
return self.mTeamBuffDic[e]
end
function BattleTeam:AddTeamBuffToGroup(t)
local e=t.buffId
if self.mTeamBuffGroupDic[e]==nil then
self.mTeamBuffGroupDic[e]={}
end
self.mTeamBuffGroupDic[e][t.releaseHeroId]=t
end
function BattleTeam:GetBestTeamBuffFromGroup(t)
local o=D:GetBuffCfg(t)
if(o==nil)then
GameInit.LogError("对应的Buff不存在 buffId %s",t)
return nil
end
local i=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if(i==nil)then
GameInit.LogError("对应的Buff脚本不存在 buffId %s",t)
return nil
end
local e=nil
local t=self.mTeamBuffGroupDic[t]
if t then
local t=self:GetGroupBuffSortArr(t)
for n=1,#t do
local t=t[n]
if e==nil then
e=t
else
local a=a:CompareBuffPriority(i,o,e,e.round,e.buffData,t.round,t.buffData)
if a==EBuffPriorityResult.Better then
e=t
end
end
end
end
return e
end
function BattleTeam:GetTeamBuffFromGroup(e,t)
if self.mTeamBuffGroupDic[e]then
return self.mTeamBuffGroupDic[e][t]
end
end
function BattleTeam:ClearTeamBuff(e,t)
e:OnRemoveSelf(t)
e:Dispose()
return true
end
function BattleTeam:DisposeAllTeamBuff()
local e=self:GetCurTeamBuffSortArr()
for t=1,#e do
local e=e[t]
self:ClearTeamBuff(e,BuffRemoveType.Expire)
end
self.mTeamBuffDic={}
self.mTeamBuffGroupDic={}
end
function BattleTeam:GetCurTeamBuffSortArr()
return self:GetGroupBuffSortArr(self.mTeamBuffDic)
end
function BattleTeam:GetGroupBuffSortArr(e)
local e=table.getValueArr(e)
table.sort(e,function(e,t)
return e.buffId<t.buffId
end)
return e
end
function BattleTeam:TriggerTeamBuff(a,i,o,n)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetCurTeamBuffSortArr()
for t=1,#e do
local e=e[t]
local t=e.buffId
if self:CheckTeamBuffExist(t)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if(e.isExec==false and t.GetCanTrigger(a))then
local t={
buffTriggerTime=a
}
local e=e:DoBuffAction(i,o,n,t)
end
end
end
end
function BattleTeam:CheckTeamBuffExist(e)
if e~=nil and e~=0 and self.mTeamBuffDic[e]~=nil then
return true
end
return false
end
function BattleTeam:AddTeamStatFury(t)
if ModulesInit.ProcedureNormalBattle.isTimeLine==true then
return
end
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local a=self:GetTeamStatFuryAdd(e)
self.mTeamFuryAddDic[e]=a+t
end
function BattleTeam:ReduceTeamStatFury(a)
if ModulesInit.ProcedureNormalBattle.isTimeLine==true then
return
end
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local t=self:GetTeamStatFuryReduce(e)
self.mTeamFuryReduceDic[e]=t+a
end
function BattleTeam:GetTeamStatFuryAdd(e)
local t=0
if self.mTeamFuryAddDic[e]then
t=self.mTeamFuryAddDic[e]
end
return t
end
function BattleTeam:GetTeamTotalStatFuryAdd()
local e=0
for a,t in pairs(self.mTeamFuryAddDic)do
e=e+t
end
return e
end
function BattleTeam:GetTeamStatFuryReduce(t)
local e=0
if self.mTeamFuryReduceDic[t]then
e=self.mTeamFuryReduceDic[t]
end
return e
end
function BattleTeam:AddTeamStatOverdrowFury(a)
if ModulesInit.ProcedureNormalBattle.isTimeLine==true then
return
end
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local t=self:GetTeamStatOverdrowFuryAdd(e)
self.mTeamOverdrowFuryAddDic[e]=t+a
end
function BattleTeam:ReduceTeamStatOverdrowFury(t)
if ModulesInit.ProcedureNormalBattle.isTimeLine==true then
return
end
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local a=self:GetTeamStatOverdrowFuryReduce(e)
self.mTeamOverdrowFuryReduceDic[e]=a+t
end
function BattleTeam:GetTeamStatOverdrowFuryAdd(e)
local t=0
if self.mTeamOverdrowFuryAddDic[e]then
t=self.mTeamOverdrowFuryAddDic[e]
end
return t
end
function BattleTeam:GetTeamStatOverdrowFuryReduce(t)
local e=0
if self.mTeamOverdrowFuryReduceDic[t]then
e=self.mTeamOverdrowFuryReduceDic[t]
end
return e
end
function BattleTeam:GetTeamStatFuryChangeInCurBigRound()
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local o=self:GetTeamStatFuryAdd(e)
local t=self:GetTeamStatFuryReduce(e)
local a=self:GetTeamStatOverdrowFuryAdd(e)
local e=self:GetTeamStatOverdrowFuryReduce(e)
local e=o+t+a+e
return e
end
function BattleTeam:TeamFightAttack(t,e)
self.attackTask=t
self.mTeamFightAttackCallback=e
self:TeamFightBeginAttack()
end
function BattleTeam:TeamFightBeginAttack()
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(0)
ModulesInit.ProcedureNormalBattle.SetCurrAttackTeamByTeamId(self.TeamId)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=true
ModulesInit.ProcedureNormalBattle.HideFireEffect()
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime=0
self:TeamFightAttackCoroutine()
end
function BattleTeam:TeamFightAttackCoroutine()
local s=true
local o=0
local n=nil
local t=ETriggerSkillAtkType.TeamAttack
if self.attackTask then
local e=self.attackTask.skillDid
n=self.attackTask.skillData
local i=nil
if e then
o=e
s=false
i=a:GetSkillActData(e)
end
if self.attackTask.triggerSkillAtkType then
t=self.attackTask.triggerSkillAtkType
elseif i then
t=i.atkType
end
self.attackTask=nil
end
ModulesInit.ProcedureNormalBattle.ResetHpHealthInTimeLine()
local e=a:GetSkillActData(o)
if(e==nil)then

FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 TeamId %s TeamSkillId %s",self.TeamId,o))
self:OnTeamFightAttackComplete()
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
if a:IsDependAtkType(t)==false then
ModulesInit.ProcedureNormalBattle.AddSkillFireCount()
end
ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=false
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=ModulesInit.BattleSkillMgr.GetSkillScript(e.scriptId)
local o=o.DoAction(self,e,n)
local o=e
local a=a:GetSkillPrefabId(o,nil,0)
if(a==0)then
GameInit.LogError("队伍攻击 TeamFightAttackCoroutine  技能Id 对应预设不存在 %d",o.id)
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:TeamFightAttackCoroutine_AfterAndCheckHurtValue(nil,t,e.type)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=true
ModulesInit.ProcedureNormalBattle.BackupAllHeroBeforeTimeLine()
ModulesInit.BattleSkillEffectManager.ResetStateOnStart()
function TeamFightAttack()
GameEntry.Pool:GameObjectSpawn(
a,
nil,
function(o,i,i)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=o:GetComponent(typeof(CS.YouYou.TimelineEffect))
if ModulesInit.BattleSkillEffectManager.CurrTimelineEffect==nil then
GameInit.LogErrorAndUpdate("battle TeamFightAttack CurrTimelineEffect == nil , skillPrefabId = "..tostring(a))
end
BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)
C:PreloadMp4(a,function()
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(false)
ModulesInit.ProcedureNormalBattle.CurrTimelineEffectAttackPointCount=ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.AttackPointCount
OpenOrCloseBloom(true)
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()
if GameTools:CheckRestartGameState()then
return
end
ModulesInit.BattleSkillEffectManager:StopCurVideo()
OpenOrCloseBloom(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=false
ModulesInit.ProcedureNormalBattle.RestoreAllHeroAfterTimeLine()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime>Time.time)then
local a=ModulesInit.TimeActionMgr.CreateTimeAction()
ModulesInit.ProcedureNormalBattle.AddTimer(a)
a:Init(
0,
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime-Time.time,
1,
nil,
nil,
function()
ModulesInit.ProcedureNormalBattle.RemoveTimer(a)
self:TeamFightAttackCoroutine_After(o,t,e.type)
end
):Run()
else
self:TeamFightAttackCoroutine_After(o,t,e.type)
end
end
end
end)
end
)
end
if GameInit.IsClient then
C:PlaySkillPrefabAndRemoveAsyncPreload(a,TeamFightAttack)
end
end
end
function BattleTeam:TeamFightAttackCoroutine_After(e,a,t)
if ModulesInit.StoryManager.isAllowPlaySkillAudio then
if ModulesInit.ProcedureNormalBattle.IsPlayHeroDyingAudio==false then
GameEntry.Audio:PausedAllAudio(true)
end
end
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Reset)
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(true)
ModulesInit.ProcedureNormalBattle.ShowFireEffect(false)
ModulesInit.ProcedureNormalBattle.HeroResetPos()
GameEntry.Pool:GameObjectDespawn(e)
ModulesInit.BattleSkillEffectManager.DespawnAllTrans()
ModulesInit.BattleSkillEffectManager.CameraControlReset()
ModulesInit.BattleSkillEffectManager.KillTweener()
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:TeamFightAttackCoroutine_AfterAndCheckHurtValue(e,a,t)
end
function BattleTeam:TeamFightAttackCoroutine_AfterAndCheckHurtValue(e,a,t)
ModulesInit.ProcedureNormalBattle.CheckHurtValue(function()
self:TeamFightAttackCoroutine_AfterAndCheckHeroDie(e,a,t)
end)
end
function BattleTeam:TeamFightAttackCoroutine_AfterAndCheckHeroDie(a,t,e)
ModulesInit.ProcedureNormalBattle.CheckHeroDie(function()
self:TeamFightAttackCoroutine_AfterAndEnd(a,t,e)
end)
end
function BattleTeam:TeamFightAttackCoroutine_AfterAndEnd(e,e,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=false
self:OnTeamFightAttackComplete()
else
local t=ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie and 0.5 or 0
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
ModulesInit.ProcedureNormalBattle.AddTimer(e)
e:Init(
0,
t,
1,
nil,
nil,
function()
ModulesInit.ProcedureNormalBattle.RemoveTimer(e)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=false
self:OnTeamFightAttackComplete()
end
):Run()
end
end
end
function BattleTeam:OnTeamFightAttackComplete()
if self.mTeamFightAttackCallback then
self.mTeamFightAttackCallback()
end
end
function BattleTeam:GetCanTeamAttackHero()
local e=self.HeroCtrls[1]
return e
end
function BattleTeam:GetOpponentCanTeamAttackHero()
if self.OpponentTeam then
return self.OpponentTeam:GetCanTeamAttackHero()
end
return nil
end
function BattleTeam:AddBuffTeamStatCount(t,a,e)
e=e or t
if self.mBuffTeamStatCountMap[t]==nil then
self.mBuffTeamStatCountMap[t]={}
end
local t=self.mBuffTeamStatCountMap[t]
if t[e]then
t[e]=t[e]+a
else
t[e]=a
end
end
function BattleTeam:GetBuffTeamStatCount(t,e)
e=e or t
if self.mBuffTeamStatCountMap[t]and self.mBuffTeamStatCountMap[t][e]then
return self.mBuffTeamStatCountMap[t][e]
end
return 0
end
function BattleTeam:GetAllBuffTeamStatCount(e)
return self.mBuffTeamStatCountMap[e]or{}
end
function BattleTeam:ResetBuffTeamStatCount(t,e)
e=e or t
if self.mBuffTeamStatCountMap[t]then
self.mBuffTeamStatCountMap[t][e]=0
end
end
function BattleTeam:ResetAllBuffTeamStatCount(e)
if self.mBuffTeamStatCountMap[e]then
self.mBuffTeamStatCountMap[e]={}
end
end
function BattleTeam:StopProcessCoroutine()
if(self.coroutine_process)then
o.stop(self.coroutine_process)
self.coroutine_process=nil
end
end
function BattleTeam:NeedCheckTargetLevel()
return self.mIsNeedCheckTargetLevel
end
function BattleTeam:RefreshNeedTargetLevel()
self.mIsNeedCheckTargetLevel=false
for e=1,#self.HeroCtrls do
if self.HeroCtrls[e].TargetLevel>0 then
self.mIsNeedCheckTargetLevel=true
break
end
end
end

