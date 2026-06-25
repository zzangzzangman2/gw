local e=require("Modules/Battle/BattleUtil")
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,o,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.triggerSkillAtkType~=ETriggerSkillAtkType.Normal then
return
end
local n=e[9]
local l=e[10]
local r={}
if(e[1]>=RandomMgr:GetBattleRandom())then
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local a={}
local o={}
for t=1,#i do
local t=i[t]
if t.HeroBattleInfo:GetBuff(n)==nil then
if t.profession==e[3]then
table.insert(a,t)
else
table.insert(o,t)
end
end
end
if#a<e[2]and#o>0 then
local e=RandomTableWithSeed(o,e[2]-#a)
for t=1,#e do
table.insert(a,e[t])
end
end
local a=RandomTableWithSeed(a,e[2])
for o=1,#a do
local a=a[o]
if a.HeroBattleInfo then
local o=e[4]
local h=e[5]
local d={e[6],e[7]}
local s=e[8]
local i=a.HeroBattleInfo:GetBuff(o)
local e=0
if(i)then
e=i:GetFloors()
end
if e+1>=s then
a.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
a:AddBuff(t.CurrHeroCtrl,n,l,r)
else
a:AddBuff(t.CurrHeroCtrl,o,h,d,1)
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

