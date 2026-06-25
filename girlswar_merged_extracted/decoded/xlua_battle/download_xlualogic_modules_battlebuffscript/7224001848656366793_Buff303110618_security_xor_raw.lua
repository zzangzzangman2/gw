local n=require("Modules/Battle/Formula")
local e={}
local h=e
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
function e.DoActionBigSkill(t,a)
local e=t:GetBuffData()
local s=e[1]
local o=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,s,o,i)
local s=e[5]
local i=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,s,i,o)
a.HeroBattleInfo:DispelAllGranBuff(true)
local i=0
local o=a.HeroBattleInfo:GetBuff(303110607)
if o then
i=o:GetFloors()
end
local o=n:GetEXSkillINjureResData(a)
local o=math.floor(o*(e[12]+i*e[15]))
local n=n:GetInjureResData(a)
local i=math.floor(n.defFinalInjureResRate*(e[14]+i*e[15]))
if o>0 or i>0 then
local n=e[9]
local s=e[10]
local e={e[11],-o,e[13],-i}
a:AddBuffAfterRemove(t.CurrHeroCtrl,n,s,e)
end
if o>0 or i>0 then
local a=e[16]
local n=e[10]
local e={e[11],o,e[13],i}
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,a,n,e)
end
end
return h

