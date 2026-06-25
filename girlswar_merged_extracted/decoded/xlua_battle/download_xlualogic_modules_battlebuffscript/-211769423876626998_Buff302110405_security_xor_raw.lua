local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
n.GetWineFumeBuff(t,e,e[5],e[6])
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
n.GetWineFumeBuff(t,e,e[12],e[13])
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetWineKnifeSkillHurtRate(e)
local e=e:GetBuffData()
return e[15]
end
function a.GetWineFumeBuffData(e)
local e=e:GetBuffData()
return{e[9],e[10]}
end
function a.GetWineFumeBuff(t,e,l,a,n)
local o=302110404
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
return
end
local o=302110415
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
return
end
local o=a
if n~=false then
if e[17]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[17]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[16]=0
end
local t=e[14]
o=math.min(t-e[16],a)
if o<=0 then
return nil
end
end
local a=e[7]
local d=e[8]
local r={e[9],e[10]}
local h=e[11]
local s=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local i=0
if s then
i=s:GetFloors()
if i>=h then
return
end
end
local o=t.CurrHeroCtrl:CheckAddBuff(l,t.CurrHeroCtrl,a,d,r,o,h)
if n~=false then
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local a=0
if t then
a=t:GetFloors()
local t=a-i
if t>0 then
e[16]=e[16]+t
end
end
end
end
return n

