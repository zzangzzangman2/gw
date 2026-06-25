local i=require("Modules/Battle/BattleUtil")
local t=Class("BattleDeadHero",{})
function t:Create(a,o)
local e=t:New()
e:Init(a,o)
return e
end
function t:Init(t,e)
self.removeHeroId=t
self.heroId=e.HeroId or 0
self.heroDid=e.heroDid or 0
self.skin=e.skin
self.CurrMaterialProperty=e.CurrMaterialProperty
self.CurrMeshRenderer=e.CurrMeshRenderer
self.propertyTintColor=e.propertyTintColor
self.lifeDuration=e.lifeDuration or 1
self.footPointPos=e.footPointPos
self.scale=e.scale or 1
self.playDeadAnim=e.playDeadAnim or false
self.petSkin=e.petSkin
self.CurrPetMaterialProperty=e.CurrPetMaterialProperty
self.CurrPetMeshRenderer=e.CurrPetMeshRenderer
end
function t:OnOpen()
self.mDelaySequence=nil
self:StartDelayRemove()
end
function t:OnClose()
self:StopDelaySequence()
self:UnLoadSkin()
self.heroId=0
self.heroDid=0
self.skin=nil
self.CurrMaterialProperty=nil
self.CurrMeshRenderer=nil
self.propertyTintColor=nil
self.lifeDuration=0
self.footPointPos=nil
self.scale=1
self.playDeadAnim=false
self.petSkin=nil
self.CurrPetMaterialProperty=nil
self.CurrPetMeshRenderer=nil
end
function t:StartDelayRemove()
local t=math.min(0.2,self.lifeDuration)
self:StopDelaySequence()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(t)
e:AppendCallback(function()
if self.footPointPos~=nil then
local e=i:GetHeroDeathEffect(self.heroDid)
if e>0 then
GameEntry.Effect:ShowEffectPro(e,EffectKeepType.AutoRelease,self.footPointPos.x,self.footPointPos.y,self.footPointPos.z,self.scale,self.scale,self.scale)
end
end
end)
local t=math.max(0,self.lifeDuration-t)
e:AppendInterval(t)
e:AppendCallback(function()
self.mDelaySequence=nil
ModulesInit.ProcedureNormalBattle.RemoveDeadHero(self.removeHeroId)
end)
self.mDelaySequence=e
end
function t:StopDelaySequence()
if self.mDelaySequence~=nil then
self.mDelaySequence:Kill()
self.mDelaySequence=nil
end
end
function t:Refresh()
end
function t:UnLoadSkin()
if(not IsNil(self.skin))then
self:ChangeAlhpaHero(1)
LuaUtils.SetActive(self.skin,true)
GameEntry.Pool:GameObjectDespawn(self.skin)
self.skin=nil
end
if(not IsNil(self.petSkin))then
self:ChangeAlhpaPet(1)
LuaUtils.SetActive(self.petSkin,true)
GameEntry.Pool:GameObjectDespawn(self.petSkin)
self.petSkin=nil
end
end
function t:ChangeAlhpaHero(t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor()
e.a=t
if(self.CurrMaterialProperty~=nil and self.CurrMeshRenderer~=nil)then
self.CurrMaterialProperty:SetColor(self.propertyTintColor,e)
self.CurrMeshRenderer:SetPropertyBlock(self.CurrMaterialProperty)
end
end
function t:ChangeAlhpaPet(t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor()
e.a=t
if(self.CurrPetMaterialProperty~=nil and self.CurrPetMeshRenderer~=nil)then
self.CurrPetMaterialProperty:SetColor(self.propertyTintColor,e)
self.CurrPetMeshRenderer:SetPropertyBlock(self.CurrPetMaterialProperty)
end
end
return t 
