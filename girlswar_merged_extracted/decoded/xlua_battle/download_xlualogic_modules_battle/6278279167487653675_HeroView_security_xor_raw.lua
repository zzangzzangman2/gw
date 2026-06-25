local e
function OnInit(t)
e=HeroCtrl:Create()
e.transform=transform
end
function OnOpen(t)
e:InitViewWith(IsOurHero,BaseHeroID,HeroID,shadow,CurrMaterialProperty,IdleData,IsSupplementHero)
e.shadowRenderer=shadowRenderer
e.IsMonster=IsMonster
e.battleStationIndex=battleStationIndex
e.IsSupplementHero=IsSupplementHero
e:OnOpen()
if(IsOurHero)then
if e:IsPet()then
ModulesInit.ProcedureNormalBattle.OurTeam:AddPetCtrl(e)
else
ModulesInit.ProcedureNormalBattle.OurTeam:AddHeroCtrl(e)
end
else
if e:IsPet()then
ModulesInit.ProcedureNormalBattle.EnemyTeam:AddPetCtrl(e)
else
ModulesInit.ProcedureNormalBattle.EnemyTeam:AddHeroCtrl(e)
end
end
end
function OnClose(t)
e:OnClose()
end
function OnBeforeDestroy()
e:OnBeforeDestroy()
end
function OnUpdate()
e:OnUpdate()
end
function OnDoAction(t,a)
e:OnDoAction(t,a)
end 
