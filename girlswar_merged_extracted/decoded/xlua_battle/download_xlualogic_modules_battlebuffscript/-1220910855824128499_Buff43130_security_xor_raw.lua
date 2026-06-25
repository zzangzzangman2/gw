local s=require("Modules/Battle/BattleUtil")
local d=require("Modules/Battle/Formula")
local n={}
local r=n
function n.GetCanAdd(e,e)
return true
end
function n.DoAction(t,e,i,i,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e[1]
local o=e[2]
local e={e[3],e[4],e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43136)
if a==nil then
local a=o.triggerSkillAtkType
if s:IsDependAtkType(a)==false then
local r=e[7]
local o=e[8]
local h=e[9]
local i={e[10],e[11],e[12]}
local a=s:GetEnemysWithBuff(t.CurrHeroCtrl,o,1)
local a=a[1]
if a==nil then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
if#e>0 then
a=s:FindMostBigAtk(e)
end
end
if a then
local s=e[16]
local n=a.HeroBattleInfo:GetBuff(s)
if n==nil then
local n=a.HeroBattleInfo:GetBuff(o)
if d:CalculateCtrlSuccess(o,r,t.CurrHeroCtrl,a)then
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
a.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Convertion)
end
local e=a:AddBuff(t.CurrHeroCtrl,o,h,i,s+1)
end
local i=a.HeroBattleInfo:GetBuff(o)
if i then
local i=i:GetFloors()
if i>=e[13]then
a.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Convertion)
local i=e[14]
local o=e[15]
local n={e[16],e[17],e[18],e[19],e[20],e[21]}
a:AddBuff(t.CurrHeroCtrl,i,o,n)
local o=e[17]
local e=0
a:AddBuff(t.CurrHeroCtrl,s,o,e)
end
end
end
end
end
end
end
return nil
end
function n.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
end
function n.SetLogicData(e,e)
end
return r

