local e={}
local d=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddControl(t,d,o)
local e=t:GetBuffData()
local n=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local r=0
local s=0
local i=nil
local h=0
for t=1,#a do
local e=a[t].HeroBattleInfo:GetBuff(n)
if e then
r=r+1
local e=e:GetBuffData()
local e=e[1]
if i==nil then
i=a[t]
s=e
elseif e<s then
i=a[t]
s=e
end
if e>h then
h=e
end
end
end
local a=nil
local s=o.HeroBattleInfo:GetBuff(n)
if r>=e[3]then
if s then
a=o
else
if i then
a=i
end
end
end
local s=e[2]
local i={h+1}
local i=o:CheckAddBuff(d,t.CurrHeroCtrl,n,s,i)
if i then
if a and a.HeroId~=o.HeroId then
a.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
end
local i=ModulesInit.ProcedureNormalBattle.GetSkillFireCount()
local n=e[4]
local s=e[5]
local e={e[6],i}
o:AddBuffAfterRemove(t.CurrHeroCtrl,n,s,e)
local e=302107409
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.OnSuccessAddWind(o,a)
end
local a=302107412
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddcumulativeNumber(e,1)
end
end
return i
end
return d

