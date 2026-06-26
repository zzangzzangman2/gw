UI_NormalBattle_TeamViewForKD={
}
function UI_NormalBattle_TeamViewForKD:New()
local e={
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
function UI_NormalBattle_TeamViewForKD:OnClose()
self:StopFillAmountTween()
end
function UI_NormalBattle_TeamViewForKD:ChangePlayerHPColor(e)
if(IsNil(self.imgPlayerHP))then
return
end
if(e)then
GameTools:SetImageSprite(self.imgPlayerHP,"UIBattle/ba_xuecao_bg5",false)
else
GameTools:SetImageSprite(self.imgPlayerHP,"UIBattle/ba_xuecao_bg3",false)
end
end
function UI_NormalBattle_TeamViewForKD:Load(e,a)
self.team=e
self.imgPlayerHP_Red=a:Find("imgPlayerHPBG/imgPlayerHP_Red"):GetComponent(typeof(CS.YouYou.YouYouImage))
self.imgPlayerHP=a:Find("imgPlayerHPBG/imgPlayerHP"):GetComponent(typeof(CS.YouYou.YouYouImage))
self:ChangePlayerHPColor(false)
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
local function t(e,t)
local e=t/e
self.imgPlayerHP_Red.fillAmount=e
self.imgPlayerHP.fillAmount=e
self:StopFillAmountTween()
end
self.team.OnResetTotalHP=t
t(self.team:GetTotalMaxHP(),self.team:GetTotalHP())
local function o(e,t,a)
if t then
LuaUtils.SetActive(e,true)
UIUtil.SetPlayerBattleHead(e:Find("im_mask/imgPlayerHeadIcon"):GetComponent(typeof(CS.YouYou.YouYouImage)),t.head,nil)
if a then
LuaUtils.SetTextMeshText(e:Find('txtNickName'):GetComponent(typeof(CS.TMPro.TextMeshProUGUI)),t.name)
else
LuaUtils.SetTextMeshText(e:Find('txtNickName'):GetComponent(typeof(CS.TMPro.TextMeshProUGUI)),string.getNameMaxWithLength(t.name,8))
end
LuaUtils.SetLabelTextWrap(e:Find('txtNickName/txtLevel'):GetComponent(typeof(CS.TMPro.TextMeshProUGUI)),t.level)
else
LuaUtils.SetActive(e,false)
end
end
local e=ModulesInit.KillDragonsManager.CurFightInfo.resultShow.roomMember
o(a:Find('1p'),e[1],true)
o(a:Find('2p'),e[2])
o(a:Find('3p'),e[3])
end
function UI_NormalBattle_TeamViewForKD:StopFillAmountTween()
if self.fillAmountTween~=nil then
self.fillAmountTween:Kill()
self.fillAmountTween=nil
end
end

