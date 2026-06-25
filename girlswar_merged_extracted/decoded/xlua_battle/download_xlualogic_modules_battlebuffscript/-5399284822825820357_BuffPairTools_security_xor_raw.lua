local a={}
local l=a
function a.AddBuffPair(e,a,o,t,n)
if e==nil then
return
end
local i=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(n)
if i==nil then
return
end
local s=e.HeroBattleInfo:GetBuff(a.buffId)
local h=0
if s then
local e=s:GetAtkBuffPairMgrData()
if e then
h=e.defHeroId
end
end
i:AddBuff(e,t.buffId,t.buffRound,t.buffValue)
local r=i.HeroBattleInfo:GetBuff(t.buffId)
if r==nil then
return
end
local d={
atkMgrHeroId=e.HeroId,
atkBuffPairMgrId=a.buffId
}
r:SetDefBuffPairData(d)
e:AddBuff(e,o.buffId,o.buffRound,o.buffValue)
local r=e.HeroBattleInfo:GetBuff(o.buffId)
if r==nil then
i.HeroBattleInfo:RemoveBuffWithId(t.buffId,BuffRemoveType.Expire)
return
end
local d={
atkMgrHeroId=e.HeroId,
atkBuffPairMgrId=a.buffId
}
r:SetAtkBuffPairData(d)
if s==nil then
e:AddBuff(e,a.buffId,a.buffRound,a.buffValue)
end
local a=e.HeroBattleInfo:GetBuff(a.buffId)
if a==nil then
i.HeroBattleInfo:RemoveBuffWithId(t.buffId,BuffRemoveType.Expire)
e.HeroBattleInfo:RemoveBuffWithId(o.buffId,BuffRemoveType.Expire)
return
end
local e={
defHeroId=n,
defBuffPairId=t.buffId,
atkHeroId=e.HeroId,
atkBuffPairId=o.buffId,
}
a:SetAtkBuffPairMgrData(e)
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(h)
if h~=n and e then
e.HeroBattleInfo:RemoveBuffWithId(t.buffId,BuffRemoveType.Expire)
end
end
function a.OnChainRemove(e,t)
if e==nil or e.HeroBattleInfo==nil then
return
end
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local e=e:GetAtkBuffPairMgrData()
if e==nil then
return
end
local t=e.defHeroId
local a=e.defBuffPairId
local i=e.atkHeroId
local o=e.atkBuffPairId
e.defHeroId=0
e.defBuffPairId=0
e.atkHeroId=0
e.atkBuffPairId=0
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(i)
if e then
e.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if e then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
function a.HandleDefChainRemove(n,o)
local e=o:GetDefBuffPairData()
if e then
local t=e.atkMgrHeroId
local i=e.atkBuffPairMgrId
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
local e=t.HeroBattleInfo:GetBuff(i)
if e then
local e=e:GetAtkBuffPairMgrData()
if e
and e.defHeroId==n.HeroId
and e.defBuffPairId==o.buffId
then
e.defHeroId=0
e.defBuffPairId=0
a.OnChainRemove(t,i)
end
end
end
end
end
function a.HandleAtkChainRemove(n,o)
local e=o:GetAtkBuffPairData()
if e then
local t=e.atkMgrHeroId
local i=e.atkBuffPairMgrId
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
local e=t.HeroBattleInfo:GetBuff(i)
if e then
local e=e:GetAtkBuffPairMgrData()
if e
and e.atkHeroId==n.HeroId
and e.atkBuffPairId==o.buffId
then
e.atkHeroId=0
e.atkBuffPairId=0
a.OnChainRemove(t,i)
end
end
end
end
end
function a.GetDefaultHpChainData()
local e={
assumedamagePercent=0,
reduceDamagePercent=0,
minHpPercent=0,
defAddfury=0,
defHeroId=0,
defBuffId=0,
holderBuffId=0,
notTriggerHurtType=nil,
}
return e
end
return l

