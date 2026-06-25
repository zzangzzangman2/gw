local u=require("Common/cs_coroutine")
local p=0.03
local q=1.5
local j=1
local x=0.6
local e=0.7
local e=0.6
local t={
None=0,
ShowHero=1,
ShowTalkContentBg=2,
ShowTalkContent=3,
WaitTalkContent=4,
}
local b={skinTransform=nil,heroDid=0,parentTrans=spine_root_1.transform}
local e={skinTransform=nil,heroDid=0,parentTrans=spine_root_2.transform}
local g={}
local k=true
local r=nil
local c=0
local e=nil
local n=0
local m=0
local i=t.None
local o=nil
local h=nil
local w=nil
local y=false
local a=b
local v=false
local l=false
local d=nil
local s=nil
local f=nil
function OnInit(e,e)
btn_next.onClick:AddListener(function()
ChangeNextState()
StartShowPreviewSkip()
end)
btn_battle_preview_skip.onClick:AddListener(
function()
ModulesInit.BattlePreviewMgr:SkipAllPreview()
end
)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnEventBlurComplete,OnEventBlurComplete)
t=t or{}
g=t.talkContents or{}
k=t.isCloseTalkView
r=t.callback
a=b
c=0
e=nil
y=false
v=false
l=false
n=ModulesInit.BattlePreviewMgr.ESceneCutType.None
CheckShowPreviewSkip()
UIUtil.SetCanvasGroupAlpha(p_root.transform,1)
UIUtil.SetCanvasGroupAlpha(root_talk,0)
LuaUtils.SetActive(spine_horn.transform,false)
LuaUtils.SetActive(im_load.transform,false)
LuaUtils.SetActive(im_load_bg.transform,false)
LuaUtils.SetActive(DialogContainer.transform,false)
LuaUtils.SetActive(root_talk.transform,false)
SetTalkTextStr("")
ClearAllSpine()
LuaUtils.SetActive(blurCanvas.transform,false)
f=LuaUtils.StartUIBlur(function()
EventSystem.SendEvent(CommonEventId.OnEventBlurComplete,{uiFormId=UIFormId.UI_BattlePreviewTalk})
end)
EventSystem.SendEvent(CommonEventId.Skill_HideHero_Begin,{DynamicTarget=CS.MyCommonEnum.DynamicTarget.OurAll,FadeIn=0.1,FadeOut=0.1})
EventSystem.SendEvent(CommonEventId.Skill_HideHero_Begin,{DynamicTarget=CS.MyCommonEnum.DynamicTarget.EnemyAll,FadeIn=0.1,FadeOut=0.1})
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventBlurComplete,OnEventBlurComplete)
ClearAllSpine()
StopAllFadeTweener()
CloseMyCoroutine()
StopDelaySequenceShowPreviewSkip()
LuaUtils.SetActive(blurCanvas.transform,false)
if f then
LuaUtils.DisposeBlur(f)
end
EventSystem.SendEvent(CommonEventId.Skill_HideHero_End,{DynamicTarget=CS.MyCommonEnum.DynamicTarget.OurAll,FadeIn=0.1,FadeOut=0.1})
EventSystem.SendEvent(CommonEventId.Skill_HideHero_End,{DynamicTarget=CS.MyCommonEnum.DynamicTarget.EnemyAll,FadeIn=0.1,FadeOut=0.1})
end
function ClearAllSpine()
UnLoadSpine(a)
UnLoadAllChildSpine(spine_root_1.transform)
UnLoadAllChildSpine(spine_root_2.transform)
end
function OnBeforeDestroy()
end
function OnFormBack(e)
end
function OnEventBlurComplete(e)
if e==nil or e.uiFormId~=UIFormId.UI_BattlePreviewTalk then
return
end
LuaUtils.SetBlurToImage(blurImage)
StartTalk()
end
function PlayViewInAnim(a,t,o)
StopAllFadeTweener()
if a==ModulesInit.BattlePreviewMgr.ESceneCutType.Blur then
LuaUtils.SetActive(blurCanvas.transform,true)
LuaUtils.SetActive(im_load.transform,false)
LuaUtils.SetActive(im_load_bg.transform,false)
if t then
t()
end
elseif a==ModulesInit.BattlePreviewMgr.ESceneCutType.White_Change then
LuaUtils.SetActive(blurCanvas.transform,false)
LuaUtils.SetActive(im_load.transform,true)
SetImageColorByType(im_load,a)
local e=CS.DG.Tweening.DOTween.Sequence()
local a=im_load.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
a.alpha=0
e:Append(a:DOFade(1,1.5))
e:AppendCallback(function()
if o then o()end
end)
e:Append(a:DOFade(0,1))
e:AppendCallback(function()
LuaUtils.SetActive(im_load.transform,false)
SetTalkTextStr("")
end)
e:AppendInterval(1)
e:AppendCallback(
function()
s=nil
if t then
t()
end
end
)
s=e
else
LuaUtils.SetActive(blurCanvas.transform,false)
LuaUtils.SetActive(im_load.transform,true)
SetImageColorByType(im_load,a)
if e.talkBg~=""then
LuaUtils.SetActive(talk_bg.transform,true)
LuaUtils.SetImageSprite(talk_bg,e.talkBg)
else
LuaUtils.SetActive(talk_bg.transform,false)
end
h=UIUtil.DoCanvasGroupFade(im_load.transform,0,1,1,function()
LuaUtils.SetActive(im_load.transform,false)
LuaUtils.SetActive(talk_bg.transform,false)
LuaUtils.SetActive(im_load_bg.transform,true)
SetImageColorByType(im_load_bg,a)
SetTalkTextStr("")
h=nil
end)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(2)
e:AppendCallback(
function()
s=nil
if t then
t()
end
end
)
s=e
end
end
function SetImageColorByType(t,e)
if e==ModulesInit.BattlePreviewMgr.ESceneCutType.Black then
LuaUtils.SetImageColor(t,0,0,0,1)
elseif e==ModulesInit.BattlePreviewMgr.ESceneCutType.White then
LuaUtils.SetImageColor(t,1,1,1,1)
end
end
function PlayViewOutAnim()
if v==true then
return
end
v=true
StopAllFadeTweener()
LuaUtils.SetActive(spine_horn.transform,false)
h=UIUtil.DoCanvasGroupFade(p_root.transform,1,0,0.2,function()
h=nil
StopAllFadeTweener()
CloseSelfView()
if r then
r()
end
end)
end
function StartTalk()
l=false
PlayNextTalk()
end
function PlayNextTalk()
if l==true then
return
end
CloseMyCoroutine()
StopAllFadeTweener()
c=c+1
e=g[c]
if e then
m=n
if e.sceneCut==ModulesInit.BattlePreviewMgr.ESceneCutType.None then
if m==ModulesInit.BattlePreviewMgr.ESceneCutType.None then
n=ModulesInit.BattlePreviewMgr.ESceneCutType.Blur
else
n=m
end
else
n=e.sceneCut
end
GameTools:sendRecordStep(e.id)
if n~=m then
LuaUtils.SetActive(talk_bg.transform,false)
PlayViewInAnim(n,function()
StartShowTalkData()
end,
function()
if n==ModulesInit.BattlePreviewMgr.ESceneCutType.White_Change then
if e.talkBg~=""then
LuaUtils.SetActive(talk_bg.transform,true)
LuaUtils.SetImageSprite(talk_bg,e.talkBg)
else
LuaUtils.SetActive(talk_bg.transform,false)
end
if e.audioId~=0 then
GameTools:SwitchBGMFadeOutLua(e.audioId)
end
end
end)
else
StartShowTalkData()
end
else
OnTalkComplete()
end
end
function OnTalkComplete()
ChangeState(t.None)
l=true
if k then
PlayViewOutAnim()
else
if r then
r()
end
end
end
function ChangeState(e)
i=e
if i==t.ShowHero then
ShowHero()
elseif i==t.ShowTalkContentBg then
ShowTalkContentBg()
elseif i==t.ShowTalkContent then
ShowTalkContent()
elseif i==t.WaitTalkContent then
WaitTalkContent()
end
end
function ChangeNextState()
if i==t.ShowHero then
elseif i==t.ShowTalkContentBg then
elseif i==t.ShowTalkContent then
ChangeState(t.WaitTalkContent)
elseif i==t.WaitTalkContent then
PlayNextTalk()
end
end
function StartShowTalkData()
ChangeState(t.ShowHero)
end
function ShowHero()
StopAllFadeTweener()
if e.heroDid>0 then
if a.skinTransform then
if a.heroDid~=e.heroDid then
LuaUtils.SetActive(a.skinTransform,false)
SetTalkTextStr("")
CloseMyCoroutine()
o=u.start(function()
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
o=nil
RefreshSpine(a,e.heroDid)
ShowNextHero()
end)
else
UIUtil.SetSpineOpacity(a.skinTransform,1)
ChangeState(t.ShowTalkContentBg)
end
else
SetTalkTextStr("")
RefreshSpine(a,e.heroDid)
ShowNextHero()
end
else
if a.skinTransform then
UnLoadSpine(a)
end
SetTalkTextStr("")
ChangeState(t.ShowTalkContentBg)
end
end
function ShowNextHero()
StopAllFadeTweener()
local e=HeroMgr:GetHeroCfgData(e.heroDid)
LuaUtils.SetTextMeshText(text_hero_name,GameTools.GetLocalize(e.heroName,LanguageCategory.LangBattle))
LuaUtils.SetActive(a.skinTransform,true)
w=UIUtil.DoSpineFadeAnim(a.skinTransform,x,j,0.1,function()
w=nil
ChangeState(t.ShowTalkContentBg)
end)
end
function ShowTalkContentBg()
StopAllFadeTweener()
LuaUtils.SetActive(root_talk.transform,false)
LuaUtils.SetActive(DialogContainer.transform,false)
local e
if n==ModulesInit.BattlePreviewMgr.ESceneCutType.Blur then
e=root_talk
else
e=DialogContainer
LuaUtils.SetActive(txtContentBlack.transform,false)
LuaUtils.SetActive(txtContentWhite.transform,true)
end
LuaUtils.SetActive(e.transform,true)
if y==false then
y=true
h=UIUtil.DoCanvasGroupFade(e,0.5,1,0.3,function()
h=nil
ChangeState(t.ShowTalkContent)
end)
else
UIUtil.SetCanvasGroupAlpha(e,1)
ChangeState(t.ShowTalkContent)
end
end
function ShowTalkContent()
CloseMyCoroutine()
if e.audioId>0 then
GameTools:PlayAudioLua(e.audioId)
LuaUtils.SetActive(spine_horn.transform,true)
PlayHornTalkAnim()
else
LuaUtils.SetActive(spine_horn.transform,false)
end
local a=GameTools.GetLocalize(e.talkContent,LanguageCategory.LangCommon)
local n,a=string.str2List(a)
local a=a*p
local s=math.max(0,e.actionDuration-a)
local a=0
o=u.start(function()
local i=""
for t=1,#n do
i=i..n[t]
SetTalkTextStr(i)
coroutine.yield(CS.UnityEngine.WaitForSeconds(p))
a=a+p
if a>=e.actionDuration then
PlayHornIdleAnim()
end
end
coroutine.yield(CS.UnityEngine.WaitForSeconds(s))
PlayHornIdleAnim()
o=nil
ChangeState(t.WaitTalkContent)
end)
end
function SetTalkTextStr(e)
LuaUtils.SetLabelText(text_talk,e)
LuaUtils.SetLabelText(txtContentBlack,e)
LuaUtils.SetLabelText(txtContentWhite,e)
end
function PlayHornIdleAnim()
spine_horn:PlayAnimation(0,"B",true)
end
function PlayHornTalkAnim()
spine_horn:PlayAnimation(0,"A",true)
end
function WaitTalkContent()
GameEntry.Audio:StopAllAudio()
CloseMyCoroutine()
SetTalkTextStr(GameTools.GetLocalize(e.talkContent,LanguageCategory.LangCommon))
o=u.start(function()
coroutine.yield(CS.UnityEngine.WaitForSeconds(q))
o=nil
PlayNextTalk()
end)
end
function UnLoadSpine(e)
if(not IsNil(e.skinTransform))then
GameEntry.Pool:GameObjectDespawn(e.skinTransform)
e.skinTransform=nil
e.heroDid=0
end
end
function UnLoadAllChildSpine(e)
for t=1,LuaUtils.GetChildrenCount(e)do
local e=UIUtil.GetChild(e,t-1)
UIUtil.SpinePoolDespawn(e)
end
end
function RefreshSpine(t,o)
UnLoadSpine(t)
UIUtil.GetTeamSpinePool(o,t.parentTrans,"teamPara",function(a)
t.heroDid=o
t.skinTransform=a
local o=t.skinTransform:GetComponent(typeof(CS.YouYou.UISpineCtr))
o:PlayAnimation(0,e.spineAnim,true)
local o=1
if e.isFlip==1 then
o=-1
end
local i,e,n=LuaUtils.GetLocalScale(t.skinTransform)
LuaUtils.SetLocalScale(t.skinTransform,i*o,e,n)
for e=1,LuaUtils.GetChildrenCount(t.parentTrans)do
local e=UIUtil.GetChild(t.parentTrans,e-1)
if e~=a then
UIUtil.SpinePoolDespawn(e)
end
end
end,false)
end
function StopAllFadeTweener()
StopFadeTweener(h)
StopFadeTweener(w)
StopDelaySequence()
end
function StopFadeTweener(e)
if e~=nil then
e:Kill()
e=nil
end
end
function CloseMyCoroutine()
if o then
u.stop(o)
o=nil
end
end
function CloseSelfView()
GameTools.CloseUIForm(self.UIFormId)
end
function StopDelaySequenceShowPreviewSkip()
if d~=nil then
d:Kill()
d=nil
end
end
function CheckShowPreviewSkip()
LuaUtils.SetActive(btn_battle_preview_skip.transform,false)
if ModulesInit.BattlePreviewMgr.skipShowStartTime>0 then
local e=ModulesInit.BattlePreviewMgr.skipShowStartTime+ModulesInit.BattlePreviewMgr.skipShowInterval-Time.realtimeSinceStartup
if e>0 then
local e=math.min(ModulesInit.BattlePreviewMgr.skipShowInterval,e)
ShowPreviewSkip(e)
end
end
end
function StartShowPreviewSkip()
ModulesInit.BattlePreviewMgr.skipShowStartTime=Time.realtimeSinceStartup
ShowPreviewSkip(ModulesInit.BattlePreviewMgr.skipShowInterval)
end
function ShowPreviewSkip(t)
LuaUtils.SetActive(btn_battle_preview_skip.transform,true)
StopDelaySequenceShowPreviewSkip()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(t)
e:AppendCallback(function()
LuaUtils.SetActive(btn_battle_preview_skip.transform,false)
end)
d=e
end
function StopDelaySequence()
if s~=nil then
s:Kill()
s=nil
end
end 
