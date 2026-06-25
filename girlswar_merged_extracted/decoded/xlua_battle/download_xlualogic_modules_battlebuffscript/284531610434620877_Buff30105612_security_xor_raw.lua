local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,a,i,h)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if h.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=e.CurrHeroCtrl.HeroId
if o==a.HeroId then
local i=i.hurtValue
local a=t[1]
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound==e.CurrHeroCtrl.appearBattleBigRound then
a=t[2]
end
local h=t[3]
local o=t[4]
local a=math.ceil(i*a*MillionCoe/o)
local i=t[5]
local t={
damage=a,
round=o
}
table.insert(i,t)
local a=nil
local s=n.HeroBattleInfo:GetBuff(h)
if s then
a=s:GetBuffData()
else
a={[1]={}}
end
local s=a[1]
table.insert(s,table.deepCopy(t))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

local a=0
local t=""
for e=1,#i do
local e=i[e]
a=a+e.damage
if t==""then
t=e.damage..":"..e.round
else
t=t..","..e.damage..":"..e.round
end
end

end
n:AddBuff(e.CurrHeroCtrl,h,o,a)
end
elseif h.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local e=t[5]
for t=#e,1,-1 do
e[t].round=e[t].round-1
if e[t].round<=0 then
table.remove(e,t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetTotalBuffDamage(e)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=e:GetBuffData()
local t=0
local a=a[5]
for e=1,#a do
local e=a[e].damage*a[e].round
t=t+e
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return t
end
return r

