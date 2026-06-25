local n=require("Modules/Battle/BattleUtil")
local s=require("Modules/Battle/Formula")
local i={}
local d=i
function i.GetCanAdd(e,e)
return true
end
function i.DoAction(a,e,o,o,t,o)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=t.triggerSkillAtkType
if n:IsDependAtkType(t)==false then
local d=e[1]
local o=e[2]
local r=e[3]
local i={e[4],e[5],e[6]}
local t=n:GetEnemysWithBuff(a.CurrHeroCtrl,o,1)
local t=t[1]
if t==nil then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.enemyAll)
if#e>0 then
t=n:FindMostBigAtk(e)
end
end
if t then
local h=e[10]
local n=t.HeroBattleInfo:GetBuff(h)
if n==nil then
local n=t.HeroBattleInfo:GetBuff(o)
if s:CalculateCtrlSuccess(o,d,a.CurrHeroCtrl,t)then
local s=0
if n then
s=n:GetFloors()
local e=n:GetBuffData()
if i[2]<e[2]then
i[2]=e[2]
end
if i[3]<e[3]then
i[3]=e[3]
end
t.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Convertion)
end
local e=t:AddBuff(a.CurrHeroCtrl,o,r,i,s+1)
end
local i=t.HeroBattleInfo:GetBuff(o)
if i then
local i=i:GetFloors()
if i>=e[7]then
t.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Convertion)
local o=e[8]
local i=e[9]
local n={e[10],e[11],e[12],e[13],e[14],e[15]}
t:AddBuff(a.CurrHeroCtrl,o,i,n)
local o=e[11]
local e=0
t:AddBuff(a.CurrHeroCtrl,h,o,e)
end
end
end
end
end
return nil
end
function i.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
end
function i.SetLogicData(e,e)
end
return d

