local h=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=e.CurrHeroCtrl
if a.buffTriggerTime==BuffTriggerTime.now then
s.SetPreviewRemainsState(e,true)
elseif a.buffTriggerTime==BuffTriggerTime.HeroDeadBefore then
local a=false
if a==false then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local i=303111205
local o=303111201
for n=1,#e do
local e=e[n]
local n=e.HeroBattleInfo:GetBuff(o)
if n then
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local s=o:GetFloors()
local o=t[2]
if s>=o then
local n=n:GetFloors()
if n*t[1]>=RandomMgr:GetBattleRandom()then
h:ReduceHeroBuffFloor(e,i,o)
a=true
break
end
end
end
end
end
end
if a==false then
if t[14]==1 then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(303111202)
if o then
local i=303111216
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#e do
local e=e[o]
local e=e.HeroBattleInfo:GetBuff(i)
if e then
local e=e:GetBuffData()
if e[20]<=0 then
e[20]=e[20]+1
t[14]=0
a=true
break
end
end
end
end
end
end
if a then
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.UnDead
e.isExec=true
o.HeroBattleInfo:ClearAllBuff()
o:SetWillHeroSpecialState(HeroSpecialState.Mute)
local n=t[3]
local i=t[4]
local e={}
for a=5,#t do
table.insert(e,t[a])
end
o:AddBuff(o,n,i,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.HeroDeadBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckSetPreviewRemainsState(e,e)
end
function a.SetPreviewRemainsState(e,t)
if t then
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.Mute,e.buffId)
else
e.CurrHeroCtrl:SetPreviewHeroSpecialState(HeroSpecialState.None)
end
end
return s

