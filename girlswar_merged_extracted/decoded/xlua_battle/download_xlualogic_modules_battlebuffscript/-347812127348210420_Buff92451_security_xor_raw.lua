local o={92452,92453,92454}
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,o,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e:AddFloors(a[1])
local o=e:GetFloors()
if o*a[2]>=RandomMgr:GetBattleRandom()then
local o=a[3]
for o=1,o do
t.CheckAddBuffCurse(e,e.CurrHeroCtrl,a)
end
local e={
isOper=true,
remove=true,
}
return e
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckAddBuffCurse(a,o,e)
local n,i=t.GetBuffCount(a,e)
t.AddBuffCurse(a,o,e,i)
if n==4 then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local o=RandomTableWithSeed(o,e[13])
for i=1,#o do
local o=o[i]
t.CheckAddBuffCurseOther(a,o,e,e[14])
end
end
end
function e.CheckAddBuffCurseOther(e,i,a)
local n,o=t.GetBuffCount(e,a)
t.AddBuffCurse(e,i,a,o)
end
function e.GetBuffCount(e,a)
local e=0
local t=RandomMgr:GetBattleRandomWithRange(1,4)
if t==4 then
e=a[12]
else
e=1
end
return t,e
end
function e.AddBuffCurse(i,a,e,n)
local h={}
local s={}
for e=1,#o do
local t=a.HeroBattleInfo:GetBuff(o[e])
if t then
table.insert(h,o[e])
else
table.insert(s,o[e])
end
end
local t={}
if#s>0 then
t=RandomTableWithSeed(s,n)
end
if#t<n then
local e=n-#t
local e=RandomTableWithSeed(h,e)
table.appendList(t,e)
end
local o=false
local h=e[4]
local s=e[6]
local n=e[10]
for r=1,#t do
local t=t[r]
if t==h then
local e=e[5]
local t={}
local e=a:AddBuff(i.CurrHeroCtrl,h,e,t)
if e then
a.HeroBattleInfo:PlayBattleAllBuffEffect()
o=true
end
elseif t==s then
local t=e[7]
local e={e[8],e[9]}
local e=a:AddBuff(i.CurrHeroCtrl,s,t,e)
if e then
o=true
end
elseif t==n then
local t=e[11]
local e={}
local e=a:AddBuff(i.CurrHeroCtrl,n,t,e)
if e then
o=true
end
end
end
if o then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=i.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle2511TreasureCurseEffect,e.x,e.y,50,3,0,false,function()
end)
end
end
end
return t

