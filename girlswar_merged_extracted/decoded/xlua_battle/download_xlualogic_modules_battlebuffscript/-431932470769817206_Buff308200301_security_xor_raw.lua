local e=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,a,o,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local n=e[1]
local r=e[2]
local d={}
local h=e[4]
local i=0
local o=a.HeroBattleInfo:GetBuff(n)
if o then
i=o:GetFloors()
end
a:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,r,d,e[3],h)
local o=0
local n=a.HeroBattleInfo:GetBuff(n)
if n then
o=n:GetFloors()
end
if o>i then
if(e[12]==0 and i<e[5]and o>=e[5])then
e[12]=1
s.AddShield(t,e)
elseif(e[13]==0 and i<e[6]and o>=e[6])then
e[13]=1
s.AddShield(t,e)
end
end
if e[10]>0 then
local i=0
local o=308200302
local o=a.HeroBattleInfo:GetBuff(o)
if o then
i=o:GetFloors()
end
local o=HeroBuffValueInfo:New()
o.buffId=t.buffId
o.attrId=e[10]
o.value=e[11]*i
a.HeroBattleInfo:AddTempBuffValue(o)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.petFightAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddShield(t,e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#a do
local o=a[o]
local a=e[7]
local i=e[8]
local e={e[9]}
o:AddBuff(t.CurrHeroCtrl,a,i,e)
end
end
return s

