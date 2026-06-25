local a={}
local l=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,i,o,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.triggerSkillAtkType==ETriggerSkillAtkType.AsistAttachAttack then
return nil
end
local i=0
if t.CurrHeroCtrl:IsOnAttack()then
i=e[1]
else
i=e[2]
end
if i>0 then
local h=e[3]
local l=e[4]
local s=e[9]
local o=e[6]
local o={
treasureHeroId=s,
buff_pro=o,
floors=i
}
local function d(e,t)
for a=1,#e do
local e=e[a]
if e.treasureHeroId==t then
return e
end
end
return nil
end
local r=e[5]
local n=a.HeroBattleInfo:GetBuff(h)
if n then
local t=n:GetBuffData()
local n=t[4]
local e=d(n,s)
if e then
e.floors=e.floors+i
else
e=o
table.insert(n,e)
end
if e.floors>=r then
t[5]=1
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
else
local i=0
if o.floors>=r then
i=1
end
local e={e[5],e[7],e[8],{o},i}
a:AddBuff(t.CurrHeroCtrl,h,l,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CompareBuffWeight(o,a,o,t,o,e)
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a.releaseHeroId)
if a==nil then
return true
end
if e[6]~=t[6]then
return e[6]>t[6]
end
if e[10]~=t[10]then
return e[10]>t[10]
end
return e[11]<t[11]
end
return l

