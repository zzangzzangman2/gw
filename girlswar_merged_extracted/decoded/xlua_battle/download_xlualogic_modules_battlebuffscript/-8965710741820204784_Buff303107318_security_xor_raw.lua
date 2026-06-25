local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,n,s,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local n=e[1]
local i=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,a)
local i=e[5]
local a=e[6]
local n={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,n)
local i=e[9]
local a=e[10]
local n={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,n)
local n=e[13]
local a=e[14]
local i={e[15],e[16]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,a,i)
o.AddBuffCeremony(t,e[17])
elseif a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd then
local a=s.triggerSkillAtkType
if i:CheckCanTriggerAttackTask(a)then
o.AddBuffCeremony(t,e[18])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
o.CheckAddBuffTaishan(t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffCeremony(t,e)
local e=t:GetBuffData()
local i=e[19]
local o=e[20]
local a={e[21],e[22]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local a=t.CurrHeroCtrl:GetAllTeamPet()
for o=1,#a do
local a=a[o]
local o=e[23]
local i=e[24]
local e={e[25],e[26]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
end
function a.CheckAddBuffTaishan(e)
local t=e:GetBuffData()
local a=t[28]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o==nil then
local o=303107321
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
local o=o:GetFloors()
if o>=t[27]then
local n=t[29]
local o={}
for a=30,37 do
table.insert(o,t[a])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,n,o)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
local t,e=i:GetPosOffset(e,EBattleCampionPosType.OurTeamCenter)
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleABQMTaishanEffect,t,e,50,3,0,false,function()
end)
end
end
end
end
end
return o

