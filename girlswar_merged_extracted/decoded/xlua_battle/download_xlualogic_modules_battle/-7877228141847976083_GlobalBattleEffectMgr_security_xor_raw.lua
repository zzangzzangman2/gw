local t={
BattleEffectDic=nil,
}
local e=t
function t.Init()
e.BattleEffectDic={}
end
function t.Dispose()
for a,t in pairs(e.BattleEffectDic)do
if(t)then
GameEntry.Effect:RemoveEffect(t.effectId)
end
end
e.BattleEffectDic={}
end
function t.ShowEffectAutoRelease(e,t,a,o,s,h,r,n,i)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
GameEntry.Effect:ShowBuffEffect(
e,
EffectKeepType.AutoRelease,
s,
t,
a,
o,
nil,
function(e,o,e)
if type(i)=="boolean"then
local e,a,t
e,a,t=LuaUtils.GetLocalScale(o,e,a,t)
if(e>0 and i==true)or(e<0 and i==false)then
e=-e
end
LuaUtils.SetLocalScale(o,e,a,t)
end
if(n)then
n()
end
if r~=false then
ModulesInit.BattleSkillEffectManager.FadeInSpeedLine(o.gameObject,h)
end
end
)
end
function t.ShowEffect(a,r,l,s,i,h,d,n,o)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local t=e.BattleEffectDic[a]
if(t)then
t.referenceCount=t.referenceCount+1
else
t={prefabId=a,
referenceCount=1,
trans=nil,
effectId=0
}
e.BattleEffectDic[a]=t
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
ModulesInit.ProcedureNormalBattle.AddTimer(e)
e:Init(
0,
i,
1,
nil,
nil,
function()
ModulesInit.ProcedureNormalBattle.RemoveTimer(e)
GameEntry.Effect:ShowBuffEffect(
a,
0,
0,
r,
l,
s,
nil,
function(s,a,e)
if type(o)=="boolean"then
local e,t,i
e,t,i=LuaUtils.GetLocalScale(a,e,t,i)
if(e>0 and o==true)or(e<0 and o==false)then
e=-e
end
LuaUtils.SetLocalScale(a,e,t,i)
end
t.trans=a
t.effectId=s
if(n)then
n(t)
end
if d~=false then
ModulesInit.BattleSkillEffectManager.FadeInSpeedLine(a.gameObject,h)
end
end
)
end
):Run()
end
end
function t.HideEffect(o,a,i)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local t=e.BattleEffectDic[o]
if(t)then
if a<=0 then
GameEntry.Effect:RemoveEffect(t.effectId)
e.BattleEffectDic[o]=nil
if i~=false then
ModulesInit.BattleSkillEffectManager.FadeOutSpeedLine(t.trans.gameObject,a)
end
else
t.referenceCount=t.referenceCount-1
if(t.referenceCount==0)then
if i~=false then
ModulesInit.BattleSkillEffectManager.FadeOutSpeedLine(t.trans.gameObject,a)
end
local i=ModulesInit.TimeActionMgr.CreateTimeAction()
ModulesInit.ProcedureNormalBattle.AddTimer(i)
i:Init(
a,
1,
1,
nil,
nil,
function()
ModulesInit.ProcedureNormalBattle.RemoveTimer(i)
GameEntry.Effect:RemoveEffect(t.effectId)
e.BattleEffectDic[o]=nil
end
):Run()
end
end
end
end
function t.SetEffectMaterialPropertyFloat(t,a,o)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=e.BattleEffectDic[t]
if(e and e.trans)then
LuaUtils.SetMaterialPropertyFloat(e.trans,a,o)
end
end
function t.ShowAllEffect(t)
for a,e in pairs(e.BattleEffectDic)do
if(e and e.trans)then
LuaUtils.SetActive(e.trans,t)
end
end
end
return t 
