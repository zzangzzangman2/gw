local e=require("Modules/Battle/BattleUtil")
local n=require('DataNode/DataTable/Create/dragon/DTDragonStageDBModel')
local i=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local o=require('DataNode/DataTable/Create/monster/DTMonsterDBModel')
UI_NormalBattle_TeamView={
}
function UI_NormalBattle_TeamView:New()
local e={
isLeftUI=true,
team=nil,
imgPlayerHeadIcon=nil,
imgPlayerHP_Red=nil,
imgPlayerHP=nil,
txtNickName=nil,
txtFirstAttack=nil,
fillAmountTween=nil,
}
setmetatable(e,self)
self.__index=self
return e
end
function UI_NormalBattle_TeamView:OnClose()
self:StopFillAmountTween()
end
function UI_NormalBattle_TeamView:Load(t,e,o,a)
self.isLeftUI=a
self.team=t
self.teamInfo=o
self.imgPlayerHeadIcon=e:Find("im_mask/imgPlayerHeadIcon"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.imgPlayerHP_Red=e:Find("imgPlayerHPBG/imgPlayerHP_Red"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.imgPlayerHP=e:Find("imgPlayerHPBG/imgPlayerHP"):GetComponent(typeof(CS.YouYou.YouYouImage))
local t=e:Find("imgPlayerHPBG/imgPlayerShield")
self.imgPlayerShield=nil
if t then
self.imgPlayerShield=t:GetComponent(typeof(CS.YouYou.YouYouImage))
end
local a=e:Find("imgPlayerHPBG/text_player_shield_num")
self.text_player_shield_num=nil
if t then
self.text_player_shield_num=a:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
end
self.trans_shield_frame=e:Find("imgPlayerHPBG/imgPlayerShield/trans_shield_frame")
self.trans_shield_point=e:Find("imgPlayerHPBG/imgPlayerShield/trans_shield_frame/trans_shield_point")
if e:Find("im_toukuang")then
self.imgPlayerFrame=e:Find("im_toukuang"):GetComponent(typeof(CS.YouYou.YouYouImage))
end
self:ChangePlayerHPColor(false)
self.txtNickName=e:Find("txtNickName"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.txtLevel=e:Find("txtLevel"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.txtFirstAttack=e:Find("txtFirstAttack"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.txtFirstAttack.gameObject:YouYouSetActive(false)
if e:Find("bg_guanzhi")then
self.bg_guanzhi=e:Find("bg_guanzhi"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.img_yazhi=e:Find("img_yazhi"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.text_yahei_num=e:Find("img_yazhi/text_yahei_num"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.text_guan_num=e:Find("bg_guanzhi/text_guan_num"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetActive(self.bg_guanzhi.transform,false)
LuaUtils.SetActive(self.img_yazhi.transform,false)
end
self.team.OnRefreshFirstAttack=function(a,t,e)
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.dragonWar
or ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview then
self.txtFirstAttack.gameObject:YouYouSetActive(false)
else
if GameInit.IsClient and ModulesInit.GuideMgr.isGuide then
self.txtFirstAttack.gameObject:YouYouSetActive(false)
else
self.txtFirstAttack.gameObject:YouYouSetActive(true)
self.txtFirstAttack.text=GameTools.GetLocalize('tips.common_50')..a
end
end
if self.bg_guanzhi then
if t and t>0 then
LuaUtils.SetActive(self.img_yazhi.transform,true)
LuaUtils.SetTextMeshText(self.text_yahei_num,math.floor(t*100).."%")
end
if e and e>0 then
LuaUtils.SetActive(self.bg_guanzhi.transform,true)
GameTools:SetImageSprite(self.bg_guanzhi,UIUtil.GetOfficerCapPath(e))
LuaUtils.SetTextMeshText(self.text_guan_num,ModulesInit.OfficerMgr:getOfficeLevelShow(e))
end
end
end
self.imgPlayerHP_Red.fillAmount=1
self.imgPlayerHP.fillAmount=1
self.team.OnRefreshTotalHP=function(t,a,e)
local e=e/t
local t=a/t
self.imgPlayerHP.fillAmount=e
self.imgPlayerHP_Red.fillAmount=t
if(e<=0.3)then
self:ChangePlayerHPColor(true)
else
self:ChangePlayerHPColor(false)
end
self:StopFillAmountTween()
self.fillAmountTween=self.imgPlayerHP_Red:DOFillAmount(e,math.min(0.8,1-(t-e))):SetEase(CS.DG.Tweening.Ease.Linear)
end
if self.imgPlayerShield and self.text_player_shield_num then
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.waterMelon then
LuaUtils.SetActive(self.imgPlayerShield.transform,true)
LuaUtils.SetActive(self.text_player_shield_num.transform,true)
self.imgPlayerShield.fillAmount=1
local e=self.imgPlayerShield.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"shield_effect",0,0)
local function a(e,t)

if e and t and e>0 and t>0 then
LuaUtils.SetActive(self.trans_shield_frame.transform,true)
if LuaUtils.GetActive(self.imgPlayerShield.transform)==false then
LuaUtils.SetActive(self.imgPlayerShield.transform,true)
local e=self.imgPlayerShield.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"shield_effect",0,0)
end
local t=t/e
local e=3
local e=(e+t*(100-e))/100
self.imgPlayerShield.fillAmount=e
local t=math.ceil(t*100)
LuaUtils.SetTextMeshText(self.text_player_shield_num,GameTools.GetLocalize("skyisland_suo_tips5",LanguageCategory.LangCommon,tostring(t).."%"))
if self.trans_shield_frame and self.trans_shield_point then
local t=self.trans_shield_frame.transform.rect.width
LuaUtils.SetLocalPos(self.trans_shield_point,t*e,0,0)
LuaUtils.SetActive(self.trans_shield_point.transform,e<0.94)
end
else
self.imgPlayerShield.fillAmount=0
LuaUtils.SetTextMeshText(self.text_player_shield_num,"")
LuaUtils.SetActive(self.trans_shield_frame.transform,false)
end
end
self.team.OnRefreshTotalArmor=a
a(self.team:GetTotalMaxArmor(),self.team:GetTotalArmor())
else
LuaUtils.SetActive(self.imgPlayerShield.transform,false)
LuaUtils.SetActive(self.text_player_shield_num.transform,false)
LuaUtils.SetActive(self.trans_shield_frame.transform,false)
end
end
local function t(e,t)
local e=t/e
self.imgPlayerHP_Red.fillAmount=e
self.imgPlayerHP.fillAmount=e
self:StopFillAmountTween()
end
self.team.OnResetTotalHP=t
t(self.team:GetTotalMaxHP(),self.team:GetTotalHP())
self:SetPlayerTitle()
end
function UI_NormalBattle_TeamView:StopFillAmountTween()
if self.fillAmountTween~=nil then
self.fillAmountTween:Kill()
self.fillAmountTween=nil
end
end
function UI_NormalBattle_TeamView:ChangePlayerHPColor(e)
if(IsNil(self.imgPlayerHP))then
return
end
if(e)then
GameTools:SetImageSprite(self.imgPlayerHP,"UIBattle/ba_xuecao_bg5",false)
else
local e=self.isLeftUI
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
e=(e==false)
end
if e then
GameTools:SetImageSprite(self.imgPlayerHP,"UIBattle/ba_xuecao_bg3",false)
else
GameTools:SetImageSprite(self.imgPlayerHP,"UIBattle/ba_xuecao_bg2",false)
end
end
end
function UI_NormalBattle_TeamView:SetPlayerTitle()
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.dragonWar then
local e=ModulesInit.KillDragonsManager.CurFightInfo.resultShow.eliteId
local e=n.GetEntity(e)
local e=o.GetEntity(e.bossId)
local t=i.GetEntity(e.modelID)
UIUtil.SetPlayerBattleHead(self.imgPlayerHeadIcon,nil,t.head)
LuaUtils.SetTextMeshText(self.txtNickName,GameTools.GetLocalize(e.monName,LanguageCategory.LangBattle))
if(e.monLevel>0)then
LuaUtils.SetTextMeshText(self.txtLevel,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,e.monLevel))
LuaUtils.SetActive(self.txtLevel.transform,true)
else
LuaUtils.SetActive(self.txtLevel.transform,false)
end
return
end
if self.teamInfo then
UIUtil.SetPlayerBattleHead(self.imgPlayerHeadIcon,self.teamInfo.headId,self.teamInfo.headPath)
LuaUtils.SetTextMeshText(self.txtNickName,self.teamInfo.name)
if(self.teamInfo.level>0)then
LuaUtils.SetTextMeshText(self.txtLevel,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,self.teamInfo.level))
LuaUtils.SetActive(self.txtLevel.transform,true)
else
LuaUtils.SetActive(self.txtLevel.transform,false)
end
if self.imgPlayerFrame then
if self.teamInfo.headFrame then
GameTools:SetImageSprite(self.imgPlayerFrame,self.teamInfo.headFrame,false)
else
GameTools:SetImageSprite(self.imgPlayerFrame,"UICommonOther/T_touxiangkuang",false)
end
end
end
end 
