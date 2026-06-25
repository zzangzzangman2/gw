local s=require("Common/UWAGPMMgr")
local i={
CameraControl=1,
CameraZoom=2,
}
local t={
speedLineFilterShader={
"Mobile/Particles/Additive2",
"Mobile/Particles/Alpha Blended2"
},
CurrTimelineEffect=nil,
transDic={},
tweenerTable={},
hurtToDeath=false,
skillTweenerMap={}
}
local e=t
function t.Init()
end
function t.AddEventListener()
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetHurtToDeath,e.OnSetHurtToDeath)
EventSystem.AddListener(CommonEventId.Skill_PlaySpineAnim_Begin,e.OnSkill_PlaySpineAnim_Begin)
EventSystem.AddListener(CommonEventId.Skill_PlaySpineAnim_End,e.OnSkill_PlaySpineAnim_End)
EventSystem.AddListener(CommonEventId.Skill_CameraShake_Begin,e.OnSkill_CameraShake_Begin)
EventSystem.AddListener(CommonEventId.Skill_CameraShake_End,e.OnSkill_CameraShake_End)
EventSystem.AddListener(CommonEventId.Skill_CameraControl_Begin,e.OnCameraControl_Begin)
EventSystem.AddListener(CommonEventId.Skill_CameraControl_End,e.OnCameraControl_End)
EventSystem.AddListener(CommonEventId.Skill_CameraZoom_Begin,e.OnSkill_CameraZoom_Begin)
EventSystem.AddListener(CommonEventId.Skill_CameraZoom_End,e.OnSkill_CameraZoom_End)
EventSystem.AddListener(CommonEventId.Skill_MoveHero_Begin,e.OnMoveHero_Begin)
EventSystem.AddListener(CommonEventId.Skill_MoveHero_End,e.OnMoveHero_End)
EventSystem.AddListener(CommonEventId.Skill_BeAttackChangeColor_Begin,e.OnBeAttackChangeColor_Begin)
EventSystem.AddListener(CommonEventId.Skill_BeAttackChangeColor_End,e.OnBeAttackChangeColor_End)
EventSystem.AddListener(CommonEventId.Skill_ChangeHeroColor_Begin,e.OnSkill_ChangeHeroColor_Begin)
EventSystem.AddListener(CommonEventId.Skill_ChangeHeroColor_End,e.OnSkill_ChangeHeroColor_End)
EventSystem.AddListener(CommonEventId.Skill_HideHero_Begin,e.OnSkill_HideHero_Begin)
EventSystem.AddListener(CommonEventId.Skill_HideHero_End,e.OnSkill_HideHero_End)
EventSystem.AddListener(CommonEventId.Skill_HideHeroWeapon_Begin,e.OnSkill_HideHeroWeapon_Begin)
EventSystem.AddListener(CommonEventId.Skill_HideHeroWeapon_End,e.OnSkill_HideHeroWeapon_End)
EventSystem.AddListener(CommonEventId.Skill_HideHeroHearBar_Begin,e.OnSkill_HideHeroHearBar_Begin)
EventSystem.AddListener(CommonEventId.Skill_HideHeroHearBar_End,e.OnSkill_HideHeroHearBar_End)
EventSystem.AddListener(CommonEventId.Skill_ChangeBGColor_Begin,e.OnSkill_ChangeBGColor_Begin)
EventSystem.AddListener(CommonEventId.Skill_ChangeBGColor_End,e.OnSkill_ChangeBGColor_End)
EventSystem.AddListener(CommonEventId.Skill_BeAttackPoint_Begin,e.OnSkill_BeAttackPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_BeAttackPoint_End,e.OnSkill_BeAttackPoint_End)
EventSystem.AddListener(CommonEventId.Skill_ResourceLoad_Begin,e.OnSkill_ResourceLoad_Begin)
EventSystem.AddListener(CommonEventId.Skill_ResourceLoad_End,e.OnSkill_ResourceLoad_End)
EventSystem.AddListener(CommonEventId.Skill_MoveResources_Begin,e.OnSkill_MoveResources_Begin)
EventSystem.AddListener(CommonEventId.Skill_MoveResources_End,e.OnSkill_MoveResources_End)
EventSystem.AddListener(CommonEventId.Skill_SimulateAtkHit_Begin,e.OnSkill_SimulateAtkHit_Begin)
EventSystem.AddListener(CommonEventId.Skill_SimulateAtkHit_End,e.OnSkill_SimulateAtkHit_End)
EventSystem.AddListener(CommonEventId.Skill_BulletAttack_Begin,e.OnSkill_BulletAttack_Begin)
EventSystem.AddListener(CommonEventId.Skill_BulletAttack_End,e.OnSkill_BulletAttack_End)
EventSystem.AddListener(CommonEventId.Skill_GotoPoint_Begin,e.OnSkill_GotoPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_GotoPoint_End,e.OnSkill_GotoPoint_End)
EventSystem.AddListener(CommonEventId.Skill_CheckPoint_Begin,e.OnSkill_CheckPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_CheckPoint_End,e.OnSkill_CheckPoint_End)
EventSystem.AddListener(CommonEventId.Skill_CameraBlur_Begin,e.OnCameraBlur_Begin)
EventSystem.AddListener(CommonEventId.Skill_CameraBlur_End,e.OnCameraBlur_End)
EventSystem.AddListener(CommonEventId.Skill_DamagePoint_Begin,e.OnSkill_DamagePoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_SkillBuff_Begin,e.OnSkill_SkillBuff_Begin)
EventSystem.AddListener(CommonEventId.Skill_RemedyPoint_Begin,e.OnSkill_RemedyPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_FuryPoint_Begin,e.OnSkill_FuryPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_SpeedLine_Begin,e.OnSkill_SpeedLine_Begin)
EventSystem.AddListener(CommonEventId.Skill_SpeedLine_End,e.OnSkill_SpeedLine_End)
EventSystem.AddListener(CommonEventId.Skill_CheckDeathPoint_Begin,e.OnSkill_CheckDeathPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_HpHealthCheckPoint_Begin,e.OnSkill_HpHealthCheckPoint_Begin)
EventSystem.AddListener(CommonEventId.OnStoryBegin,e.OnStoryBegin)
EventSystem.AddListener(CommonEventId.Skill_BloodPoint_Begin,e.OnSkill_BloodPoint_Begin)
EventSystem.AddListener(CommonEventId.Skill_ThornPoint_Begin,e.OnSkill_ThornPoint_Begin)
end
function t.RemoveEventListener()
EventSystem.RemoveListener(CommonEventId.ProcedureNormalBattle_SetHurtToDeath,e.OnSetHurtToDeath)
EventSystem.RemoveListener(CommonEventId.Skill_PlaySpineAnim_Begin,e.OnSkill_PlaySpineAnim_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_PlaySpineAnim_End,e.OnSkill_PlaySpineAnim_End)
EventSystem.RemoveListener(CommonEventId.Skill_CameraShake_Begin,e.OnSkill_CameraShake_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_CameraShake_End,e.OnSkill_CameraShake_End)
EventSystem.RemoveListener(CommonEventId.Skill_CameraControl_Begin,e.OnCameraControl_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_CameraControl_End,e.OnCameraControl_End)
EventSystem.RemoveListener(CommonEventId.Skill_CameraZoom_Begin,e.OnSkill_CameraZoom_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_CameraZoom_End,e.OnSkill_CameraZoom_End)
EventSystem.RemoveListener(CommonEventId.Skill_MoveHero_Begin,e.OnMoveHero_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_MoveHero_End,e.OnMoveHero_End)
EventSystem.RemoveListener(CommonEventId.Skill_BeAttackChangeColor_Begin,e.OnBeAttackChangeColor_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_BeAttackChangeColor_End,e.OnBeAttackChangeColor_End)
EventSystem.RemoveListener(CommonEventId.Skill_ChangeHeroColor_Begin,e.OnSkill_ChangeHeroColor_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_ChangeHeroColor_End,e.OnSkill_ChangeHeroColor_End)
EventSystem.RemoveListener(CommonEventId.Skill_HideHero_Begin,e.OnSkill_HideHero_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_HideHero_End,e.OnSkill_HideHero_End)
EventSystem.RemoveListener(CommonEventId.Skill_HideHeroWeapon_Begin,e.OnSkill_HideHeroWeapon_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_HideHeroWeapon_End,e.OnSkill_HideHeroWeapon_End)
EventSystem.RemoveListener(CommonEventId.Skill_HideHeroHearBar_Begin,e.OnSkill_HideHeroHearBar_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_HideHeroHearBar_End,e.OnSkill_HideHeroHearBar_End)
EventSystem.RemoveListener(CommonEventId.Skill_ChangeBGColor_Begin,e.OnSkill_ChangeBGColor_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_ChangeBGColor_End,e.OnSkill_ChangeBGColor_End)
EventSystem.RemoveListener(CommonEventId.Skill_BeAttackPoint_Begin,e.OnSkill_BeAttackPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_BeAttackPoint_End,e.OnSkill_BeAttackPoint_End)
EventSystem.RemoveListener(CommonEventId.Skill_ResourceLoad_Begin,e.OnSkill_ResourceLoad_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_ResourceLoad_End,e.OnSkill_ResourceLoad_End)
EventSystem.RemoveListener(CommonEventId.Skill_MoveResources_Begin,e.OnSkill_MoveResources_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_MoveResources_End,e.OnSkill_MoveResources_End)
EventSystem.RemoveListener(CommonEventId.Skill_SimulateAtkHit_Begin,e.OnSkill_SimulateAtkHit_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_SimulateAtkHit_End,e.OnSkill_SimulateAtkHit_End)
EventSystem.RemoveListener(CommonEventId.Skill_BulletAttack_Begin,e.OnSkill_BulletAttack_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_BulletAttack_End,e.OnSkill_BulletAttack_End)
EventSystem.RemoveListener(CommonEventId.Skill_GotoPoint_Begin,e.OnSkill_GotoPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_GotoPoint_End,e.OnSkill_GotoPoint_End)
EventSystem.RemoveListener(CommonEventId.Skill_CheckPoint_Begin,e.OnSkill_CheckPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_CheckPoint_End,e.OnSkill_CheckPoint_End)
EventSystem.RemoveListener(CommonEventId.Skill_CameraBlur_Begin,e.OnCameraBlur_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_CameraBlur_End,e.OnCameraBlur_End)
EventSystem.RemoveListener(CommonEventId.Skill_DamagePoint_Begin,e.OnSkill_DamagePoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_SkillBuff_Begin,e.OnSkill_SkillBuff_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_RemedyPoint_Begin,e.OnSkill_RemedyPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_FuryPoint_Begin,e.OnSkill_FuryPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_SpeedLine_Begin,e.OnSkill_SpeedLine_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_SpeedLine_End,e.OnSkill_SpeedLine_End)
EventSystem.RemoveListener(CommonEventId.Skill_CheckDeathPoint_Begin,e.OnSkill_CheckDeathPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_HpHealthCheckPoint_Begin,e.OnSkill_HpHealthCheckPoint_Begin)
EventSystem.RemoveListener(CommonEventId.OnStoryBegin,e.OnStoryBegin)
EventSystem.RemoveListener(CommonEventId.Skill_BloodPoint_Begin,e.OnSkill_BloodPoint_Begin)
EventSystem.RemoveListener(CommonEventId.Skill_ThornPoint_Begin,e.OnSkill_ThornPoint_Begin)
end
function t.GetCurrAttackHero()
return ModulesInit.ProcedureNormalBattle.HeroDic[ModulesInit.ProcedureNormalBattle.CurrAttackHeroId]
end
function t.GetCurrBeAttackHero(e)
local t={}
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable(e)
if(e)then
for a=1,#e do
t[#t+1]=ModulesInit.ProcedureNormalBattle.HeroDic[e[a]]
end
end
return t
end
function t.IsBeAttackHero(a,e)
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable(e)
if(e==nil)then
return false
end
for t=1,#e do
if(a==e[t])then
return true
end
end
return false
end
function t.GetHeroCtrl(a,t)
local t
if(a==CS.MyCommonEnum.DynamicTarget.OurOne)then
t=e.GetCurrAttackHero()
elseif(a==CS.MyCommonEnum.DynamicTarget.EnemyOne)then
t=e.GetCurrBeAttackHero()[1]
elseif(a==CS.MyCommonEnum.DynamicTarget.OneToEnemyOne)then
t=e.GetCurrAttackHero()
end
return t
end
function t.GetHeroCtrlTable(o,a)
local t={}
if(ModulesInit.ProcedureNormalBattle.OurTeam==nil or ModulesInit.ProcedureNormalBattle.EnemyTeam==nil)then
return t
end
if(o==CS.MyCommonEnum.DynamicTarget.OurOne)then
local e=ModulesInit.ProcedureNormalBattle.HeroDic[ModulesInit.ProcedureNormalBattle.CurrAttackHeroId]
t[#t+1]=e
elseif(o==CS.MyCommonEnum.DynamicTarget.OurAll)then
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack)then
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[e]
end
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls[e]
end
else
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls[e]
end
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls[e]
end
end
elseif(o==CS.MyCommonEnum.DynamicTarget.OurOther)then
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack)then
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls do
local e=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls do
local e=ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
else
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls do
local e=ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls do
local e=ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
end
elseif(o==CS.MyCommonEnum.DynamicTarget.EnemyOne)then
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable(a)
if(e~=nil)then
for a=1,#e do
t[#t+1]=ModulesInit.ProcedureNormalBattle.HeroDic[e[a]]
end
end
elseif(o==CS.MyCommonEnum.DynamicTarget.EnemyAll)then
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack)then
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls[e]
end
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls[e]
end
else
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[e]
end
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls do
t[#t+1]=ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls[e]
end
end
elseif(o==CS.MyCommonEnum.DynamicTarget.EnemyOther)then
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack)then
for o=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls do
local o=ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
for o=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls do
local o=ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
else
for o=1,#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls do
local o=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
for o=1,#ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls do
local o=ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
end
elseif(o==CS.MyCommonEnum.DynamicTarget.AllOthers)then
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack)then
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls do
local e=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
for e=1,#ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls do
local e=ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
for o=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls do
local o=ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
for o=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls do
local o=ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
else
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls do
local e=ModulesInit.ProcedureNormalBattle.EnemyTeam.HeroCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
for e=1,#ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls do
local e=ModulesInit.ProcedureNormalBattle.EnemyTeam.PetCtrls[e]
if(e.HeroId~=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId)then
t[#t+1]=e
end
end
for o=1,#ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls do
local o=ModulesInit.ProcedureNormalBattle.OurTeam.HeroCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
for o=1,#ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls do
local o=ModulesInit.ProcedureNormalBattle.OurTeam.PetCtrls[o]
if(not e.IsBeAttackHero(o.HeroId,a))then
t[#t+1]=o
end
end
end
elseif(o==CS.MyCommonEnum.DynamicTarget.OneToEnemyOne)then
local e=ModulesInit.ProcedureNormalBattle.HeroDic[ModulesInit.ProcedureNormalBattle.CurrAttackHeroId]
t[#t+1]=e
end
return t
end
function t.GetHeroCtrlTableWithTargetType(t,o)
local a={}
local e=e.GetHeroCtrlTable(t,o)
if(t==CS.MyCommonEnum.DynamicTarget.OurOne)then
for t=1,#e do
local e={
heroCtrl=e[t],
targetType=EBattleHeroTargetType.HERO
}
table.insert(a,e)
end
elseif t==CS.MyCommonEnum.DynamicTarget.OurAll
or t==CS.MyCommonEnum.DynamicTarget.EnemyOne
or t==CS.MyCommonEnum.DynamicTarget.EnemyAll
or t==CS.MyCommonEnum.DynamicTarget.EnemyOther
then
for t=1,#e do
local e={
heroCtrl=e[t],
targetType=EBattleHeroTargetType.All
}
table.insert(a,e)
end
elseif t==CS.MyCommonEnum.DynamicTarget.OurOther
or t==CS.MyCommonEnum.DynamicTarget.AllOthers then
for t=1,#e do
local e={
heroCtrl=e[t],
targetType=EBattleHeroTargetType.All
}
table.insert(a,e)
end
elseif(t==CS.MyCommonEnum.DynamicTarget.OneToEnemyOne)then
for t=1,#e do
local e={
heroCtrl=e[t],
targetType=EBattleHeroTargetType.PET
}
table.insert(a,e)
end
end
return a
end
function t.GetTargetWithHeroCtrl(e,a)
if(e==nil)then
return nil
end
local t
if(a~=nil)then
if(a==CS.MyCommonEnum.DynamicPointType.Head)then
t=e:GetReferHeadPointPos()
elseif(a==CS.MyCommonEnum.DynamicPointType.Middle)then
t=e:GetReferMiddlePointPos()
elseif(a==CS.MyCommonEnum.DynamicPointType.Foot)then
t=e:GetReferFootPointPos()
end
else
t=e:GetReferMiddlePointPos()
end
return t
end
function t.GetTarget(h,o,a,n,i,s)
local t
if(h)then
if(o==CS.MyCommonEnum.DynamicTarget.DynamicCenter)then
local e=Vector3(0,0,0)
local t=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable(i)
for a=1,#t do
local t=ModulesInit.ProcedureNormalBattle.HeroDic[t[a]]
if(t)then
e=e+t.transform.position
end
end
if(e)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=e/#t
end
return ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position
else
if(s and o==CS.MyCommonEnum.DynamicTarget.None)then
t=e.GetTargetWithHeroCtrl(s,n)
else
local a=e.GetHeroCtrl(o,i)
t=e.GetTargetWithHeroCtrl(a,n)
end
end
else
if(ModulesInit.ProcedureNormalBattle.BattleCenterTransform==nil
or ModulesInit.ProcedureNormalBattle.OurCenterTransform==nil
or ModulesInit.ProcedureNormalBattle.EnemyCenterTransform==nil
or ModulesInit.ProcedureNormalBattle.DynamicCenterHelper==nil
)then
return nil
end
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack)then
if(a==CS.MyCommonEnum.StaticTarget.BattleCenter)then
t=ModulesInit.ProcedureNormalBattle.BattleCenterTransform.position
elseif(a==CS.MyCommonEnum.StaticTarget.OurCenter)then
t=ModulesInit.ProcedureNormalBattle.OurCenterTransform.position
elseif(a==CS.MyCommonEnum.StaticTarget.EnemyCenter)then
t=ModulesInit.ProcedureNormalBattle.EnemyCenterTransform.position
elseif(a==CS.MyCommonEnum.StaticTarget.EnemyRowCenter)then
local a=e.GetCurrBeAttackHero()
if(#a>1)then
local e=a[1]
if(e)then
if(e.battleStationRow==1)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.EnemyTeamSetting.FirstRowCenter
elseif(e.battleStationRow==2)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.EnemyTeamSetting.SecondRowCenter
end
t=ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position
end
else
local e=a[1]
if(e)then
t=e.transform.position
end
end
elseif(a==CS.MyCommonEnum.StaticTarget.EnemyColumnCenter)then
local a=e.GetCurrBeAttackHero()
if(#a>1)then
local e=a[1]
if(e)then
if(e.battleStationColumn==1)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.EnemyTeamSetting.FirstColumnCenter
elseif(e.battleStationColumn==2)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.EnemyTeamSetting.SecondColumnCenter
elseif(e.battleStationColumn==3)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.EnemyTeamSetting.ThreeColumnCenter
end
t=ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position
end
else
local e=a[1]
if(e)then
t=e.transform.position
end
end
end
else
if(a==CS.MyCommonEnum.StaticTarget.BattleCenter)then
t=ModulesInit.ProcedureNormalBattle.BattleCenterTransform.position
elseif(a==CS.MyCommonEnum.StaticTarget.OurCenter)then
t=ModulesInit.ProcedureNormalBattle.EnemyCenterTransform.position
elseif(a==CS.MyCommonEnum.StaticTarget.EnemyCenter)then
t=ModulesInit.ProcedureNormalBattle.OurCenterTransform.position
elseif(a==CS.MyCommonEnum.StaticTarget.EnemyRowCenter)then
local e=e.GetCurrBeAttackHero()
if(#e>1)then
local e=e[1]
if(e)then
if(e.battleStationRow==1)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.OurTeamSetting.FirstRowCenter
elseif(e.battleStationRow==2)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.OurTeamSetting.SecondRowCenter
end
t=ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position
end
else
local e=e[1]
if(e)then
t=e.transform.position
end
end
elseif(a==CS.MyCommonEnum.StaticTarget.EnemyColumnCenter)then
local a=e.GetCurrBeAttackHero()
if(#a>1)then
local e=a[1]
if(e)then
if(e.battleStationColumn==1)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.OurTeamSetting.FirstColumnCenter
elseif(e.battleStationColumn==2)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.OurTeamSetting.SecondColumnCenter
elseif(e.battleStationColumn==3)then
ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position=ModulesInit.ProcedureNormalBattle.OurTeamSetting.ThreeColumnCenter
end
t=ModulesInit.ProcedureNormalBattle.DynamicCenterHelper.position
end
else
local e=a[1]
if(e)then
t=e.transform.position
end
end
end
end
end
return t
end
function t.OnSkill_PlaySpineAnim_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetHeroCtrlTableWithTargetType(t.Target,t.Category)
for a=1,#e do
local a=e[a]
local e=a.heroCtrl
local a=a.targetType
if(t.SpineAnimName~="")then
e:PlaySpineAnim(t.SpineAnimName,t.Loop,t.AutoChangeIdle,a)
else
e:PlaySpineAnims(t.SpineAnimNames,t.AutoChangeIdle,false,false,false,a)
end
e=nil
end
end
function t.OnSkill_PlaySpineAnim_End(e)
end
local a
function t.OnSkill_CameraShake_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(t.ShakeType==CS.MyCommonEnum.SkillCameraShakeType.DoTween)then
local t=GameEntry.CameraCtrl.MainCamera.transform:DOShakePosition(
t.Duration,
t.ShakeStrength*ModulesInit.ProcedureNormalBattle.OnePixelRatio,
t.Vibrato,
t.Randomness,
false,
t.FadeOut
)
e.AddTweener(t)
end
a=GameEntry.CameraCtrl.transform.position
ModulesInit.ProcedureNormalBattle.CameraIsShake=true
end
function t.OnSkill_CameraShake_End(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
a=nil
ModulesInit.ProcedureNormalBattle.CameraIsShake=false
LuaUtils.SetLocalPos(GameEntry.CameraCtrl.MainCamera.transform,0,0,0)
ModulesInit.ProcedureNormalBattle.RefreshHeroHud()
end
function t.CameraCtrlMoveTo(a,r,t,h,n,s)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(a==nil)then
return
end
local o
if(h)then
o=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(a+Vector3(t.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.y,0))
else
o=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(a)+Vector3(t.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.y*CurrScreenHeightRatio,0)
end
local t=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(o)
t.z=GameEntry.CameraCtrl.transform.position.z
e.KillSkillTweener(i.CameraControl)
if(r)then
CameraMgr:SetCameraPosition(CameraMgr.ESceneType.NormalBattle,t)
EventSystem.SendEvent(CommonEventId.OnCameraCtrlMoveing,true)
else
if(s)then
GameEntry.CameraCtrl.transform:DOKill()
local t=GameEntry.CameraCtrl.transform:DOMove(t,n):SetEase(s):OnUpdate(
function()
EventSystem.SendEvent(CommonEventId.OnCameraCtrlMoveing,true)
end
)
e.SetSkillTweener(i.CameraControl,t)
else
GameEntry.CameraCtrl.transform:DOKill()
local t=GameEntry.CameraCtrl.transform:DOMove(t,n):OnUpdate(
function()
EventSystem.SendEvent(CommonEventId.OnCameraCtrlMoveing,true)
end
)
e.SetSkillTweener(i.CameraControl,t)
end
end
end
function t.CameraZoom(o,a,n,t,s)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.KillSkillTweener(i.CameraZoom)
if(o)then
CameraMgr:SetCameraOrthographicSize(CameraMgr.ESceneType.NormalBattle,t)
local e=t*0.2
LuaUtils.SetLocalScale(GameEntry.CameraCtrl.SpeedLineContainer,e,e,e)
else
local o=t
local t=n
local t=CS.DG.Tweening.DOTween.To(
function()
return t
end,
function(e)
t=e
end,
o,
a
):OnUpdate(
function()
CameraMgr:SetCameraOrthographicSize(CameraMgr.ESceneType.NormalBattle,t)
local e=t*0.2
LuaUtils.SetLocalScale(GameEntry.CameraCtrl.SpeedLineContainer,e,e,e)
end
):SetEase(s)
e.SetSkillTweener(i.CameraZoom,t)
end
end
function t.OnCameraControl_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(t.CameraControlReset)then
e.CameraCtrlMoveTo(ModulesInit.ProcedureNormalBattle.CameraCtrlOldPos,t.Immediately,Vector2.zero,t.WorldSpaceOffset,t.Duration,t.MoveCurve)
else
local a=e.GetTarget(t.UseDynamicTarget,t.DynamicTarget,t.StaticTarget,t.DynamicPointType,t.Category)
e.CameraCtrlMoveTo(a,t.Immediately,t.Offset,t.WorldSpaceOffset,t.Duration,t.MoveCurve)
a=nil
end
end
function t.CameraControlReset()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.CameraCtrlMoveTo(ModulesInit.ProcedureNormalBattle.CameraCtrlOldPos,false,Vector2.zero,Vector2.zero,0.2,nil)
end
function t.OnCameraControl_End(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
EventSystem.SendEvent(CommonEventId.OnCameraCtrlMoveing,false)
ModulesInit.ProcedureNormalBattle.RefreshHeroHud()
end
function t.OnSkill_CameraZoom_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(t.CameraZoomReset)then
e.CameraZoom(
t.Immediately,
t.Duration,
ModulesInit.ProcedureNormalBattle.CameraCtrlCurrOrthographicSize,
ModulesInit.ProcedureNormalBattle.CameraCtrlOriginalOrthographicSize,
t.ZoomCurve
)
ModulesInit.ProcedureNormalBattle.CameraCtrlCurrOrthographicSize=ModulesInit.ProcedureNormalBattle.CameraCtrlOriginalOrthographicSize
else
local a=t.ZoomValue*0.01*5*OGAdjustSizeRate+ModulesInit.ProcedureNormalBattle.CameraCtrlOriginalOrthographicSize
a=math.max(0.1,a)
a=math.min(15,a)
e.CameraZoom(t.Immediately,t.Duration,ModulesInit.ProcedureNormalBattle.CameraCtrlCurrOrthographicSize,a,t.ZoomCurve)
ModulesInit.ProcedureNormalBattle.CameraCtrlCurrOrthographicSize=a
a=nil
end
end
function t.OnSkill_CameraZoom_End(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
ModulesInit.ProcedureNormalBattle.RefreshHeroHud()
end
function t.OnMoveHero_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local a=e.GetHeroCtrlTableWithTargetType(t.MoveHero,t.Category)
for o=1,#a do
local a=a[o]
local o=a.heroCtrl
local a=a.targetType
e.OnMoveOneHero_Begin(t,o)
end
end
function t.OnMoveOneHero_Begin(t,a)
local o=nil
if(a)then
if t.MoveHero==CS.MyCommonEnum.DynamicTarget.OneToEnemyOne then
local e=a:GetPetRoot()
if(e)then
o=e
end
elseif t.MoveHero==CS.MyCommonEnum.DynamicTarget.OurOne then
local e=a:GetHeroRoot()
o=e
elseif(t.MoveHero==CS.MyCommonEnum.DynamicTarget.EnemyOne
or t.MoveHero==CS.MyCommonEnum.DynamicTarget.None)then
o=a
if(a:IsSuperArmor()or a.CurrIsBlocking)then
return
end
if(a.HeroBattleInfo:HasControlFlyBuff())then
return
end
end
end
if(a and o)then
local i
if(t.MoveBack==false)then
local e=e.GetTarget(t.UseDynamicTarget,t.DynamicTarget,t.StaticTarget,t.DynamicPointType,t.Category,a)
if(e~=nil)then
i=e+Vector3(0,0,-0.01)
end
else
i=a.OriginalPos
end
if(i==nil)then
return
end
local n
if(t.WorldSpaceOffset)then
n=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(i+Vector3(t.Offset.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y,0))
else
n=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(i)+Vector3(t.Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y*CurrScreenHeightRatio,0)
end
i=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(n)
if(t.Teleport)then
o.transform.position=i
else
if(not IsNil(o)and not IsNil(o.transform))then
o.transform:DOKill()
local t=o.transform:DOMove(i,t.Duration):SetEase(t.MoveCurve)
e.AddTweener(t)
end
end
i=nil
n=nil
a=nil
o=nil
end
end
function t.OnMoveHero_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetHeroCtrlTableWithTargetType(t.MoveHero,t.Category)
for t=1,#e do
local e=e[t]
local t=e.heroCtrl
local e=e.targetType
if(t)then
t:RefreshHeroHud()
end
end
end
function t.OnBeAttackChangeColor_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetHeroCtrlTable(t.DynamicTarget,t.Category)
for t=1,#e do
local e=e[t]
if(e~=nil)then
e:SetFlipRoot(true)
end
end
end
function t.OnBeAttackChangeColor_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetHeroCtrlTable(t.DynamicTarget,t.Category)
for t=1,#e do
local e=e[t]
if(e~=nil)then
e:SetFlipRoot(false)
end
end
end
function t.OnSkill_ChangeHeroColor_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local a=e.GetHeroCtrlTable(t.DynamicTarget,t.Category)
for o=1,#a do
local o=a[o]
if(o~=nil)then
if(t.FadeIn==0)then
o:ChangeColor(t.TintColor)
else
local a=Color.white
local i=t.TintColor
local t=CS.DG.Tweening.DOTween.To(
function()
return a
end,
function(e)
a=e
end,
i,
t.FadeIn
):OnUpdate(
function()
o:ChangeColor(a)
end
)
e.AddTweener(t)
end
end
end
end
function t.OnSkill_ChangeHeroColor_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local a=e.GetHeroCtrlTable(t.DynamicTarget,t.Category)
for o=1,#a do
local o=a[o]
if(o~=nil)then
if(t.FadeOut==0)then
o:ChangeColor(ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor())
else
local a=t.TintColor
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor()
local t=CS.DG.Tweening.DOTween.To(
function()
return a
end,
function(e)
a=e
end,
i,
t.FadeOut
):OnUpdate(
function()
o:ChangeColor(a)
end
)
e.AddTweener(t)
end
end
end
end
function t.OnSkill_HideHero_Begin(o)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local t=e.GetHeroCtrlTableWithTargetType(o.DynamicTarget,o.Category)
for a=1,#t do
local a=t[a]
local t=a.heroCtrl
local a=a.targetType
if(t~=nil)then
t:ShowOrHideBuffEffect(false,true)
t.isHideHero=true
if(o.FadeIn==0)then
t:ChangeColor(Color(1,1,1,0),a)
t:ChangeShadowAlpha(0,a)
t:SetSpineInvisible(true,a)
t:ChangeHeadBarAlpha(0,a)
else
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor()
local n=Color(1,1,1,0)
local i=CS.DG.Tweening.DOTween.To(
function()
return i
end,
function(e)
i=e
end,
n,
o.FadeIn
):OnUpdate(
function()
t:ChangeColor(i,a)
end
):OnComplete(
function()
t:SetSpineInvisible(true,a)
end
)
e.AddTweener(i)
local i=1
local n=0
local t=CS.DG.Tweening.DOTween.To(
function()
return i
end,
function(e)
i=e
end,
n,
o.FadeIn
):OnUpdate(
function()
t:ChangeShadowAlpha(i,a)
t:ChangeHeadBarAlpha(i,a)
end
)
e.AddTweener(t)
end
end
end
end
function t.OnSkill_HideHero_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local a=e.GetHeroCtrlTableWithTargetType(t.DynamicTarget,t.Category)
local o=e.GetimeTimeLeftDuration()
local i=math.min(o,t.FadeOut)
for t=1,#a do
local a=a[t]
local t=a.heroCtrl
local a=a.targetType
if(t~=nil)then
t.isHideHero=false
t:ShowOrHideBuffEffect(true,true)
t:SetSpineInvisible(false,a)
if(i==0)then
t:ChangeColor(ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor(),a)
t:ChangeShadowAlpha(1,a)
t:ChangeHeadBarAlpha(1,a)
t:ChangeHeadBarAlphaUnlock(a)
else
local o=Color(1,1,1,0)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor()
local o=CS.DG.Tweening.DOTween.To(
function()
return o
end,
function(e)
o=e
end,
n,
i
):OnUpdate(
function()
t:ChangeColor(o,a)
end
)
e.AddTweener(o)
local o=0
local n=1
local t=CS.DG.Tweening.DOTween.To(
function()
return o
end,
function(e)
o=e
end,
n,
i
):OnUpdate(
function()
t:ChangeShadowAlpha(o,a)
t:ChangeHeadBarAlpha(o,a)
end
):OnComplete(
function()
t:ChangeHeadBarAlphaUnlock(a)
end
)
e.AddTweener(t)
end
end
end
end
function t.OnSkill_HideHeroWeapon_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetHeroCtrlTableWithTargetType(t.DynamicTarget,t.Category)
for a=1,#e do
local a=e[a]
local e=a.heroCtrl
local a=a.targetType
if(e~=nil)then
if(t.IsShow)then
e:SetHeroWeaponShow(t.WeaponFollow,true,a)
else
e:SetHeroWeaponShow(t.WeaponFollow,false,a)
end
end
end
end
function t.OnSkill_HideHeroWeapon_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetHeroCtrlTableWithTargetType(t.DynamicTarget,t.Category)
for a=1,#e do
local a=e[a]
local e=a.heroCtrl
local a=a.targetType
if(e~=nil)then
if(t.IsShow)then
e:SetHeroWeaponShow(t.WeaponFollow,false,a)
else
e:SetHeroWeaponShow(t.WeaponFollow,true,a)
end
end
end
end
function t.OnSkill_HideHeroHearBar_Begin(a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local t=e.GetHeroCtrlTable(a.DynamicTarget,a.Category)
for o=1,#t do
local t=t[o]
if(t~=nil)then
if(a.FadeIn==0)then
if(t.CurrHeadBarView and t.CurrHeadBarView:Lock(6))then
t.CurrHeadBarView:ChangeAlpha(0)
end
else
local o=1
local i=0
local t=CS.DG.Tweening.DOTween.To(
function()
return o
end,
function(e)
o=e
end,
i,
a.FadeIn
):OnUpdate(
function()
if(t.CurrHeadBarView and t.CurrHeadBarView:Lock(6))then
t.CurrHeadBarView:ChangeAlpha(o)
end
end
)
e.AddTweener(t)
end
end
end
end
function t.OnSkill_HideHeroHearBar_End(a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local t=e.GetHeroCtrlTable(a.DynamicTarget,a.Category)
for o=1,#t do
local t=t[o]
if(t~=nil)then
if(a.FadeOut==0)then
if(t.CurrHeadBarView and t.CurrHeadBarView:Lock(6))then
t.CurrHeadBarView:ChangeAlpha(1)
t.CurrHeadBarView:UnLock()
end
else
local o=0
local i=1
local t=CS.DG.Tweening.DOTween.To(
function()
return o
end,
function(e)
o=e
end,
i,
a.FadeOut
):OnUpdate(
function()
if(t.CurrHeadBarView and t.CurrHeadBarView:Lock(6))then
t.CurrHeadBarView:ChangeAlpha(o)
end
end
):OnComplete(
function()
if(t.CurrHeadBarView and t.CurrHeadBarView:Lock(6))then
t.CurrHeadBarView:UnLock()
end
end
)
e.AddTweener(t)
end
end
end
end
local o
function t.OnSkill_ChangeBGColor_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
GameEntry.Event.CommonEvent:Dispatch(CommonEventId.BattleMap_ToDynamicHideEffect,true)
o=t.TargetColor
if(t.TweenTimeIn==0)then
GameEntry.CameraCtrl:CameraMaskChangeColor(t.TargetColor)
else
GameEntry.CameraCtrl:CameraMaskChangeColor(CS.UnityEngine.Color(0,0,0,0.001))
local a=CS.UnityEngine.Color(0,0,0,0.001)
local o=t.TargetColor
local t=CS.DG.Tweening.DOTween.To(
function()
return a
end,
function(e)
a=e
end,
o,
t.TweenTimeIn
):OnUpdate(
function()
GameEntry.CameraCtrl:CameraMaskChangeColor(a)
end
)
e.AddTweener(t)
end
end
function t.OnSkill_ChangeBGColor_End(a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
GameEntry.Event.CommonEvent:Dispatch(CommonEventId.BattleMap_ToDynamicHideEffect,false)
if(a.TweenTimeOut==0)then
local e=CS.UnityEngine.Color(0,0,0,0.001)
GameEntry.CameraCtrl:CameraMaskChangeColor(e)
else
local t=o
local o=CS.UnityEngine.Color(0,0,0,0.001)
local t=CS.DG.Tweening.DOTween.To(
function()
return t
end,
function(e)
t=e
end,
o,
a.TweenTimeOut
):OnUpdate(
function()
GameEntry.CameraCtrl:CameraMaskChangeColor(t)
end
)
e.AddTweener(t)
end
end
function t.ChangeBGColorFadeIn(t,o,a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
GameEntry.CameraCtrl:CameraMaskChangeColor(t)
local t=t
local t=CS.DG.Tweening.DOTween.To(
function()
return t
end,
function(e)
t=e
end,
o,
a
):OnUpdate(
function()
GameEntry.CameraCtrl:CameraMaskChangeColor(t)
end
)
e.AddTweener(t)
end
function t.OnSkill_BeAttackPoint_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for a=0,t.BeAttackPoints.Length-1 do
local t=t.BeAttackPoints[a]
e.OnSkill_BeAttackPoint_Do(t)
end
end
function t.OnSkill_BeAttackPoint_Do(o)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(o.PrefabPath=="")then
return
end
if(o.UseDynamicTarget)then
local t=e.GetHeroCtrlTable(o.DynamicTarget,o.Category)
for a=1,#t do
local n=t[a]
local t={}
t.args=o
t.heroCtrl=n
if(o.PrefabPath=="")then
break
end
GameTools:PoolGameObjectSpawnWithPath(
o.PrefabPath,
t,
function(o,t,a)
e.AddTrans(o)
local t=a.args
local i=a.heroCtrl
a=nil
local a
if(t.BoneName~="")then
a=i:GetBonePos(t.BoneName)
if(a==nil)then
e.RemoveTransOrDespawn(o)
return
end
else
local t=e.GetTargetWithHeroCtrl(i,t.DynamicPointType)
if(t==nil)then
e.RemoveTransOrDespawn(o)
return
end
a=t
end
local e
if(t.WorldSpaceOffset)then
e=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(a+Vector3(t.Offset.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y,0))
else
e=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(a)+Vector3(t.Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y*CurrScreenHeightRatio,0)
end
a=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(e)
a.z=a.z+t.OffsetZ
o.position=a
o.localRotation=Quaternion.Euler(t.Rotation)
local e=t.Scale
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false and t.NotFlip==false)then
e.x=e.x*-1
end
e.x=e.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX
o.localScale=e
t:AddTrans(o)
end
)
n=nil
end
else
GameTools:PoolGameObjectSpawnWithPath(
o.PrefabPath,
o,
function(a,o,t)
e.AddTrans(a)
local t=t
local o=e.GetTarget(false,nil,t.StaticTarget)
if(o==nil)then
e.RemoveTransOrDespawn(a)
return
end
local e=o
local o=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(e)
o=o+Vector3(t.Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y*CurrScreenHeightRatio,0)
e=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(o)
e.z=e.z+t.OffsetZ
a.position=e
a.localRotation=Quaternion.Euler(t.Rotation)
local e=t.Scale
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false and t.NotFlip==false)then
e.x=e.x*-1
end
e.x=e.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX
a.localScale=e
t:AddTrans(a)
end
)
end
end
function t.OnSkill_BeAttackPoint_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for a=0,t.BeAttackPoints.Length-1 do
local t=t.BeAttackPoints[a]
while(t:HasTrans())do
local t=t:GetTrans()
e.RemoveTransOrDespawn(t)
end
t=nil
end
end
function t.OnSkill_MoveResources_Begin(i)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(i.PrefabPath=="")then
return
end
GameEntry.Pool:GameObjectSpawnWithPath(
i.PrefabPath,
i,
function(a,o,t)
e.AddTrans(a)
local t=t
local o=e.GetTarget(t.UseDynamicTarget,t.DynamicTarget,t.StaticTarget,t.DynamicPointType,t.Category)
if(o==nil)then
e.RemoveTransOrDespawn(a)
return
end
local o=o
local n
if(t.WorldSpaceOffset)then
n=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o+Vector3(t.Offset.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y,0))
else
n=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o)+Vector3(t.Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y*CurrScreenHeightRatio,0)
end
o=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(n)
o.z=o.z+t.OffsetZ
a.position=o
a.localRotation=Quaternion.Euler(t.Rotation)
local o=t.Scale
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false and t.NotFlip==false)then
o.x=o.x*-1
end
o.x=o.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX
a.localScale=o
t.CurrTrans=a
local t=a:GetComponent(typeof(CS.YouYou.LuaUnit))
if t then
t:Open()
end
e.MoveResource_Begin(a,i)
end
)
end
function t.OnSkill_MoveResources_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(not IsNil(t.CurrTrans))then
if e.ContainTrans(t.CurrTrans)then
e.RemoveTransOrDespawn(t.CurrTrans)
t.CurrTrans=nil
end
end
end
function t.MoveResource_Begin(o,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(o)then
local a
local i=e.GetTarget(t.Move_UseDynamicTarget,t.Move_DynamicTarget,t.Move_StaticTarget,t.Move_DynamicPointType,t.Category)
if(i~=nil)then
a=i+Vector3(0,0,-0.01)
end
if(a==nil)then
return
end
local i
if(t.Move_WorldSpaceOffset)then
i=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(a+Vector3(t.Move_Offset.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Move_Offset.y,0))
else
i=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(a)+Vector3(t.Move_Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Move_Offset.y*CurrScreenHeightRatio,0)
end
a=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(i)
if(t.Move_Teleport)then
o.transform.position=a
else
if(not IsNil(o)and not IsNil(o.transform))then
o.transform:DOKill()
local t=o.transform:DOMove(a,t.Move_Duration):SetEase(t.Move_MoveCurve)
e.AddTweener(t)
end
end
a=nil
i=nil
o=nil
end
end
function t.OnSkill_ResourceLoad_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(t.PrefabPath=="")then
return
end
s:PushSample(s.ESampleType.BattleSkillEffectManager_OnSkill_ResourceLoad_Begin)
ErrInfoCollectMgr:AddInfo("battle","OnSkill_ResourceLoad_Begin",tostring(t.PrefabPath))
GameTools:PoolGameObjectSpawnWithPath(
t.PrefabPath,
t,
function(a,o,t)
e.AddTrans(a)
local t=t
local o=e.GetTarget(t.UseDynamicTarget,t.DynamicTarget,t.StaticTarget,t.DynamicPointType,t.Category)
if(o==nil)then
e.RemoveTransOrDespawn(a)
return
end
local e=o
local o
if(t.WorldSpaceOffset)then
o=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(e+Vector3(t.Offset.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y,0))
else
o=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(e)+Vector3(t.Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y*CurrScreenHeightRatio,0)
end
e=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(o)
e.z=e.z+t.OffsetZ
a.position=e
a.localRotation=Quaternion.Euler(t.Rotation)
local e=t.Scale
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false and t.NotFlip==false)then
e.x=e.x*-1
end
e.x=e.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX
a.localScale=e
t.CurrTrans=a
local e=a:GetComponent(typeof(CS.YouYou.LuaUnit))
if e then
e:Open()
end
end
)
s:PopSample(s.ESampleType.BattleSkillEffectManager_OnSkill_ResourceLoad_Begin)
end
function t.OnSkill_ResourceLoad_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(not IsNil(t.CurrTrans))then
if e.ContainTrans(t.CurrTrans)then
e.RemoveTransOrDespawn(t.CurrTrans)
t.CurrTrans=nil
end
end
end
function t.OnSkill_SimulateAtkHit_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for a=0,t.BeAttackPoints.Length-1 do
local t=t.BeAttackPoints[a]
e.OnSkill_BeAttackPoint_Do(t)
t=nil
end
end
function t.OnSkill_SimulateAtkHit_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for a=0,t.BeAttackPoints.Length-1 do
local t=t.BeAttackPoints[a]
while(t:HasTrans())do
local t=t:GetTrans()
e.RemoveTransOrDespawn(t)
end
t=nil
end
end
function t.OnSkill_BulletAttack_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local a=e.GetCurrAttackHero()
if(a==nil)then
return
end
local o=e.GetTarget(t.UseDynamicTarget,t.DynamicTarget,t.StaticTarget,t.DynamicPointType,t.Category)
if(o==nil)then
return
end
local s=e.GetCurrBeAttackHero()[1]
local o
if(t.BulletBornPointType==CS.MyCommonEnum.DynamicPointType.Head)then
o=a:GetHeadPointPos()
elseif(t.BulletBornPointType==CS.MyCommonEnum.DynamicPointType.Middle)then
o=a:GetMiddlePointPos()
elseif(t.BulletBornPointType==CS.MyCommonEnum.DynamicPointType.Foot)then
o=a.transform.position
end
if(o==nil)then
return
end
local i=o
local a=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(i)
a=a+Vector3(t.BulletBornPosOffset.x*CurrScreenWidthRatio*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.BulletBornPosOffset.y*CurrScreenHeightRatio,0)
i=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(a)
local o=o
a=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o)
a=a+Vector3(t.BulletArrivePosOffset.x*CurrScreenWidthRatio*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.BulletArrivePosOffset.y*CurrScreenHeightRatio,0)
o=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(a)
local n=t.Duration
local a={}
a.beginPos=i
a.targetPos=o
a.duration=n
if(t.BulletBornEffectPrefabPath~="")then
GameTools:PoolGameObjectSpawnWithPath(
t.BulletBornEffectPrefabPath,
t,
function(t,o,a)
e.AddTrans(t)
local e=a
local a=e.UserData
t.position=a.beginPos
e.CurrBulletBornEffectTrans=t
end
)
end
t.UserData=a
GameTools:PoolGameObjectSpawnWithPath(
t.BulletPrefabPath,
t,
function(a,o,t)
e.AddTrans(a)
local t=t
local o=t.UserData
t.CurrBulletTrans=a
a.position=o.beginPos
a.localScale=Vector3.one*t.BulletScale
if(t.UseCurvePath)then
local r=math.floor(1/t.CurveSetp)
local h={}
local d=o.targetPos-o.beginPos
local n=0
local l=math.random(t.CurveYFactor.x,t.CurveYFactor.y)
local i
for e=0,r do
i=o.beginPos+d*e/r
i=Vector3(i.x,i.y+t.CurvePath:Evaluate(n)*l,i.z)
h[#h+1]=i
n=n+t.CurveSetp
end
if(t.CurrTweener~=nil)then
t.CurrTweener:Kill()
end
t.CurrTweener=a:DOPath(h,o.duration,CS.DG.Tweening.PathType.CatmullRom):SetLookAt(0):SetEase(t.SpeedCurve):OnComplete(
function()
if(not IsNil(t.CurrBulletTrans))then
e.RemoveTransOrDespawn(t.CurrBulletTrans)
t.CurrBulletTrans=nil
end
end
):OnStart(
function()
local e=a:GetComponentInChildren(typeof(CS.AutoLookAt))
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false)then
e:SetAngles(false)
else
e:SetAngles(true)
end
end
)
r=nil
h=nil
d=nil
n=nil
l=nil
i=nil
if(t.BulletArriveEffectPrefabPath~="")then
GameTools:PoolGameObjectSpawnWithPath(
t.BulletArriveEffectPrefabPath,
t,
function(t,o,a)
e.AddTrans(t)
local e=a
local a=e.UserData
t.position=a.targetPos
t.localRotation=Quaternion.Euler(e.BulletArriveEffectRotation)
t.localScale=Vector3.one*e.BulletArriveEffectScale
e.CurrBulletArriveEffectTrans=t
end
)
end
if(s~=nil and t.BeAttackHeroAnimName~="")then
s:PlaySpineAnim(t.BeAttackHeroAnimName,false)
end
else
a:LookAt(o.targetPos)
local i=a:GetComponentInChildren(typeof(CS.AutoLookAt))
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false)then
i:SetAngles(false)
else
i:SetAngles(true)
end
if(t.CurrTweener~=nil)then
t.CurrTweener:Kill()
end
a:DOKill()
t.CurrTweener=a:DOMove(o.targetPos,o.duration):SetEase(t.SpeedCurve):OnComplete(
function()
if(not IsNil(t.CurrBulletTrans))then
e.RemoveTransOrDespawn(t.CurrBulletTrans)
t.CurrBulletTrans=nil
end
if(t.BulletArriveEffectPrefabPath~="")then
GameTools:PoolGameObjectSpawnWithPath(
t.BulletArriveEffectPrefabPath,
t,
function(t,o,a)
e.AddTrans(t)
local e=a
local a=e.UserData
t.position=a.targetPos
t.localRotation=Quaternion.Euler(e.BulletArriveEffectRotation)
t.localScale=Vector3.one*e.BulletArriveEffectScale
e.CurrBulletArriveEffectTrans=t
end
)
end
if(s~=nil and t.BeAttackHeroAnimName~="")then
s:PlaySpineAnim(t.BeAttackHeroAnimName,false)
end
end
)
end
end
)
end
function t.OnSkill_BulletAttack_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(not IsNil(t.CurrBulletBornEffectTrans))then
e.RemoveTransOrDespawn(t.CurrBulletBornEffectTrans)
t.CurrBulletBornEffectTrans=nil
end
if(not IsNil(t.CurrBulletArriveEffectTrans))then
e.RemoveTransOrDespawn(t.CurrBulletArriveEffectTrans)
t.CurrBulletArriveEffectTrans=nil
end
end
function t.OnSkill_GotoPoint_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetCurrAttackHero()
if(e==nil)then
return
end
if(t.LoopTimes>0)then
if(t.CurrTimes==t.LoopTimes)then
return
end
t.CurrTimes=t.CurrTimes+1
end
if(e.CurrTimelineEffect~=nil)then
e.CurrTimelineEffect:GoToPoint(t.GotoPointId)
end
end
function t.OnSkill_GotoPoint_End(e)
end
function t.OnSkill_CheckPoint_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=e.GetCurrAttackHero()
if(e==nil)then
return
end
end
function t.OnSkill_CheckPoint_End(e)
end
local i
local a
local h=false
local n=0
local s=true
function t.RadialBlurEnter(i,t,a,o,h,r,d)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local t=t
if(s)then
s=false
if(d)then
local t=CS.DG.Tweening.DOTween.To(
function()
return t
end,
function(e)
t=e
end,
0,
h
):OnUpdate(
function()
n=t
GameEntry.CameraCtrl:RadialBlurSetting(Vector4(i*0.01*0.5,t*0.01*0.2,a,o))
end
):OnStart(
function()
GameEntry.CameraCtrl:RadialBlurSetActive(true)
end
)
e.AddTweener(t)
else
n=t
GameEntry.CameraCtrl:RadialBlurSetActive(true)
GameEntry.CameraCtrl:RadialBlurSetting(Vector4(i*0.01*0.5,t*0.01*0.2,a,o))
end
end
if(r)then
GameEntry.CameraCtrl:RadialBlurSetting(Vector4(i*0.01*0.5,n*0.01*0.2,a,o))
end
end
function t.RadialBlurEnterWithWorldPos(o,a,i,d,h,r,n,s)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(o==nil)then
return
end
local t
if(i)then
t=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o+Vector3(a.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),a.y,0))
else
t=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o)+Vector3(a.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),a.y*CurrScreenHeightRatio,0)
end
local a=(GameEntry.CameraCtrl.HalfScreenWidth-t.x)/GameEntry.CameraCtrl.HalfScreenWidth*0.5
local o=(GameEntry.CameraCtrl.HalfScreenHeight-t.y)/GameEntry.CameraCtrl.HalfScreenHeight*0.5
e.RadialBlurEnter(d,h,a,o,r,n,s)
t=nil
a=nil
o=nil
end
function t.OnCameraBlur_Begin(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(not e.CanPlayBattleEffect())then
return
end
a=t
h=true
i=e.GetTarget(t.UseDynamicTarget,t.DynamicTarget,t.StaticTarget,nil,t.Category)
e.RadialBlurEnterWithWorldPos(i,t.Offset,t.WorldSpaceOffset,t.Radius,t.BlurValue,t.Duration,t.FollowTarget,t.IsAttenuation)
end
function t.OnCameraBlur_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.StopCameraBlur()
end
function t.StopCameraBlur()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
h=false
a=nil
s=true
GameEntry.CameraCtrl:RadialBlurSetActive(false)
end
function t.CheckCameraBlurFollow()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(h==true and a~=nil and a.FollowTarget==true)then
e.RadialBlurEnterWithWorldPos(
i,
a.Offset,
a.WorldSpaceOffset,
a.Radius,
a.BlurValue,
a.Duration,
a.FollowTarget,
a.IsAttenuation
)
end
end
function t.OnSkill_DamagePoint_Begin(a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable(0)
local t=#e
for t=1,t do
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e[t]]
if(e~=nil)then
e:RealHurtWithTestEditor()
end
end
else
EventSystem.SendEvent(CommonEventId.OnPlayDamagePoint,a.Category)
end
end
function t.OnSkill_SkillBuff_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if ModulesInit.ProcedureNormalBattle.IsBattleTest then
if(ModulesInit.ProcedureNormalBattle.battleSettingInEditor and ModulesInit.ProcedureNormalBattle.battleSettingInEditor.ShowBuffInfo==true)then
ModulesInit.ProcedureNormalBattle.AddBuffToEnemysInEditor()
end
end
for a,t in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
t.HeroBattleInfo:PlayBattleEffectWithBuffId(e.BuffId)
end
end
function t.OnSkill_RemedyPoint_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for t,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.HpHealth)
end
end
function t.OnSkill_FuryPoint_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(e.Add)then
for t,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
if ModulesInit.ProcedureNormalBattle.IsBattleTest then
e.HeroBattleInfo:ExcuteBattleEffectWithTypeWhithoutCheck(BattleEffectType.AddFury)
else
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
else
for t,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
if ModulesInit.ProcedureNormalBattle.IsBattleTest then
e.HeroBattleInfo:ExcuteBattleEffectWithTypeWhithoutCheck(BattleEffectType.ReduceFury)
else
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.ReduceFury)
end
end
end
end
function t.OnSkill_BloodPoint_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
end
function t.OnSkill_ThornPoint_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for t,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
e:PlayThorn()
e:PlayBlood()
end
end
function t.OnSkill_HpHealthCheckPoint_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
for t,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
if ModulesInit.ProcedureNormalBattle.IsBattleTest then
local t=math.random()>0.5 and true or false
e:SynHpHealthInTimeLine(math.random(100,100000),t)
end
e:PlayHpHealth()
end
end
function t.OnSkill_SpeedLine_Begin(i)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(i.PrefabPath=="")then
return
end
GameEntry.Event.CommonEvent:Dispatch(CommonEventId.BattleMap_ToDynamicHideEffect,true)
EventSystem.SendEvent(CommonEventId.OnShowSpeedLine,true)
GameTools:PoolGameObjectSpawnWithPath(
i.PrefabPath,
i,
function(a,o,t)
e.AddTrans(a)
local t=t
LuaUtils.SetParent(a,GameEntry.CameraCtrl.SpeedLineContainer)
LuaUtils.SetLocalPos(a,0,0,0)
local o=a.position
local n
if(t.WorldSpaceOffset)then
n=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o+Vector3(t.Offset.x*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y,0))
else
n=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(o)+Vector3(t.Offset.x*CurrScreenWidthRatio*ModulesInit.ProcedureNormalBattle.mirrorScaleX*(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack and 1 or-1),t.Offset.y*CurrScreenHeightRatio,0)
end
o=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(n)
o.z=o.z+t.OffsetZ
a.position=o
a.localRotation=Quaternion.Euler(t.Rotation)
local o=t.Scale
if(ModulesInit.ProcedureNormalBattle.IsOurTeamAttack==false and t.NotFlip==false)then
o.x=o.x*-1
end
a.localScale=o
t.CurrTrans=a
if i.FadeIn~=0 then
e.FadeInSpeedLine(a.gameObject,i.FadeIn)
end
end
)
end
function t.OnSkill_SpeedLine_End(t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(not IsNil(t.CurrTrans))then
GameEntry.Event.CommonEvent:Dispatch(CommonEventId.BattleMap_ToDynamicHideEffect,false)
EventSystem.SendEvent(CommonEventId.OnShowSpeedLine,false)
if t.FadeOut~=0 then
e.FadeOutSpeedLine(t.CurrTrans.gameObject,t.FadeOut)
local a=LuaUtils.GetInstanceID(t.CurrTrans)
if e.transDic[a]~=nil then
LuaUtils.YieldGameObjectPoolDespawn(t.FadeOut+1,t.CurrTrans)
end
e.RemoveTransOrDespawn(t.CurrTrans,true)
else
e.RemoveTransOrDespawn(t.CurrTrans)
end
end
end
function t.FadeInSpeedLine(a,o)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=LuaUtils.GetParticleRendersInChildren(a)
if(e)then
for e,t in pairs(e)do
local e=t.material.color
t.material.color=Color(e.r,e.g,e.b,0)
LuaUtils.MaterialDoTweenToAlpha(t.material,1,o)
end
end
local e=LuaUtils.GetSpriteRendersInChildren(a)
if(e)then
for t,e in pairs(e)do
local t=e.color
e.color=Color(t.r,t.g,t.b,0)
LuaUtils.SpriteRendererDoTweenToAlpha(e,1,o)
end
end
end
function t.FadeOutSpeedLine(o,a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
local e=LuaUtils.GetParticleRendersInChildren(o)
if(e)then
for e,t in pairs(e)do
local e=t.material.color
t.material.color=Color(e.r,e.g,e.b,1)
LuaUtils.MaterialDoTweenToAlpha(t.material,0,a)
end
end
local e=LuaUtils.GetSpriteRendersInChildren(o)
if(e)then
for e,t in pairs(e)do
local e=t.color
t.color=Color(e.r,e.g,e.b,1)
LuaUtils.SpriteRendererDoTweenToAlpha(t,0,a)
end
end
end
function t.OnSetHurtToDeath(e)
ModulesInit.ProcedureNormalBattle.RemoveAllHeroBuffEffectInEditor()
ModulesInit.ProcedureNormalBattle.battleSettingInEditor=e
end
function t.OnSkill_CheckDeathPoint_Begin(e)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
if(ModulesInit.ProcedureNormalBattle.battleSettingInEditor and ModulesInit.ProcedureNormalBattle.battleSettingInEditor.HurtToDeath==true)then
ModulesInit.ProcedureNormalBattle.HurtToDeath()
end
else
ModulesInit.ProcedureNormalBattle.CheckHeroDie(function()
end)
end
end
function t.OnUpdate()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.CheckCameraBlurFollow()
end
function t.AddTrans(t)
e.transDic[LuaUtils.GetInstanceID(t)]=t
end
function t.RemoveTransOrDespawn(t,a)
if a==nil then a=false end
if not IsNil(t)then
if e.transDic[LuaUtils.GetInstanceID(t)]~=nil then
e.transDic[LuaUtils.GetInstanceID(t)]=nil
if not a then
GameEntry.Pool:GameObjectDespawn(t)
end
end
end
end
function t.ContainTrans(t)
local a=false
if not IsNil(t)then
local t=LuaUtils.GetInstanceID(t)
if e.transDic[t]~=nil then
a=true
end
end
return a
end
function t.ContainTrans(a)
local t=false
if not IsNil(a)then
local a=LuaUtils.GetInstanceID(a)
if e.transDic[a]~=nil then
t=true
end
end
return t
end
function t.AddTweener(t)
table.add(e.tweenerTable,t)
end
function t.KillTweener()
for a,t in ipairs(e.tweenerTable)do
if(t)then
t:Kill()
end
end
e.tweenerTable={}
for a,t in pairs(e.skillTweenerMap)do
if(t)then
t:Kill()
end
end
e.skillTweenerMap={}
end
function t.SetSkillTweener(t,a)
e.skillTweenerMap[t]=a
end
function t.KillSkillTweener(t)
if(e.skillTweenerMap[t])then
e.skillTweenerMap[t]:Kill()
e.skillTweenerMap[t]=nil
end
end
function t.OnStoryBegin()
e.StopCameraBlur()
end
function t.CanPlayBattleEffect()
if(ModulesInit.StoryManager.IsPlayStorying)then
return false
end
return true
end
function t.DespawnAllTrans()
for a,t in pairs(e.transDic)do
if(t~=nil)then
if(not IsNil(GameEntry.Pool))then
GameEntry.Pool:GameObjectDespawn(t)
end
end
end
e.transDic={}
end
function t.StopCurVideo()
GameEntry.Video:Stop()
end
function t.ResetStateOnStart()
e.KillTweener()
e.DespawnAllTrans()
ModulesInit.ProcedureNormalBattle.CameraCtrlReset()
if(not IsNil(GameEntry.CameraCtrl))then
local e=CS.UnityEngine.Color(0,0,0,0.001)
GameEntry.CameraCtrl:CameraMaskChangeColor(e)
GameEntry.CameraCtrl:RadialBlurSetActive(false)
end
end
function t.Dispose()
if(not IsNil(e.CurrTimelineEffect))then
e.CurrTimelineEffect:Stop()
end
e.KillTweener()
e.DespawnAllTrans()
ModulesInit.ProcedureNormalBattle.CameraCtrlReset()
GameTools:SetTimeScale(SetTimeScaleType.Battle,1)
if(not IsNil(GameEntry.CameraCtrl))then
local e=CS.UnityEngine.Color(0,0,0,0.001)
GameEntry.CameraCtrl:CameraMaskChangeColor(e)
GameEntry.CameraCtrl:RadialBlurSetActive(false)
end
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Reset)
if(not IsNil(GameEntry.Video))then
e.StopCurVideo()
end
ModulesInit.GlobalBattleEffectMgr.Dispose()
end
function t.GeTimeTimeCurTime()
if e.CurrTimelineEffect and e.CurrTimelineEffect.CurrPlayableDirector then
return e.CurrTimelineEffect.CurrPlayableDirector.time or 0
end
return 0
end
function t.GetimeTimeDuration()
if e.CurrTimelineEffect and e.CurrTimelineEffect.CurrPlayableDirector then
return e.CurrTimelineEffect.CurrPlayableDirector.duration or 0
end
return 0
end
function t.GetimeTimeLeftDuration()
if e.CurrTimelineEffect and e.CurrTimelineEffect.CurrPlayableDirector
and type(e.CurrTimelineEffect.CurrPlayableDirector.duration)=="number"
and type(e.CurrTimelineEffect.CurrPlayableDirector.time)=="number"then
local e=e.CurrTimelineEffect.CurrPlayableDirector.duration-e.CurrTimelineEffect.CurrPlayableDirector.time
return math.max(0,e)
end
return 0
end
return t

