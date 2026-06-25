local e=require("Modules/Battle/HeroState/BaseState")
local a=require("Modules/Battle/BattleUtil")
local t={}
function t:New(t)
self.__index=self
local e=e:New(HeroState.Death)
e.HeroCtrl=t
e.enterTime=0
e.footPointPos=nil
e.heroIsClose=false
e.IsPlayDeathEffect=false
e.scale=1
e.heroDid=0
setmetatable(e,self)
return e
end
function t:OnEnter()
self.footPointPos=self.HeroCtrl:GetFootPointPos()
self.heroIsClose=false
self.IsPlayDeathEffect=false
self.heroDid=self.HeroCtrl.heroDid
ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=true
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self.scale=self.HeroCtrl:GetDeathEffectScale()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.enterTime=Time.time
end
ModulesInit.ProcedureNormalBattle.SelectFireHero=nil
ModulesInit.ProcedureNormalBattle.HideFireEffect()
ModulesInit.ProcedureNormalBattle.AutoSelectFireHero()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self.HeroCtrl:GetLastAttackHeroId()
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
self.HeroCtrl.HeroBattleInfo:TriggerBuff(BuffTriggerTime.HeroDead,e,self.HeroCtrl)
if self.HeroCtrl.IsMonster then
EventSystem.SendEvent(CommonEventId.BattleMonsterDeath,self.HeroCtrl.HeroId)
end
EventSystem.SendEvent(CommonEventId.OnBattleHeroDeath,self.HeroCtrl.HeroId)
self.heroIsClose=true
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
CS.YouYou.NormalBattleCtrl.Instance:RemoveHeroFromList(self.HeroCtrl.IsOurHero,self.HeroCtrl.battleStationIndex)
end
self.HeroCtrl:OnClose()
end
function t:OnUpdate()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(not self.IsPlayDeathEffect and self.footPointPos~=nil and Time.time>self.enterTime+0.6)then
self.IsPlayDeathEffect=true
local e=a:GetHeroDeathEffect(self.heroDid)
if e>0 then
GameEntry.Effect:ShowEffectPro(e,EffectKeepType.AutoRelease,self.footPointPos.x,self.footPointPos.y,self.footPointPos.z,self.scale,self.scale,self.scale)
end
end
end
end
function t:OnLeave()
end
return t

