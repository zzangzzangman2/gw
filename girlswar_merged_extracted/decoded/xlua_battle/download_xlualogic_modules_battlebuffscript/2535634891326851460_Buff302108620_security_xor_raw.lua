local a={}
local l=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t[2]
local a=t[4]
if e.CurrHeroCtrl:IsRealLastRowHero()then
o=math.floor(t[2]*t[5]*MillionCoe)
a=math.floor(t[4]*t[5]*MillionCoe)
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],o)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],a)
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionSmallSkill(t)
local e=t:GetBuffData()
if e[28]==1 then
e[28]=0
local e=e[25]
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e)
end
end
function a.DoActionBigSkill(t,s)
local e=t:GetBuffData()
local n={}
local a=e[7]
local d=e[8]
local h={}
for t=9,15 do
table.insert(h,e[t])
end
local i=e[16]
local r=e[17]
local o={}
for t=18,24 do
table.insert(o,e[t])
end
for e=1,#s do
local e=s[e]
local s=e.HeroBattleInfo:GetBuff(i)
if s then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
e:AddBuff(t.CurrHeroCtrl,i,r,o,1)
else
local s=e.HeroBattleInfo:GetBuff(a)
if s then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
e:AddBuff(t.CurrHeroCtrl,i,r,o,1)
else
table.insert(n,e)
end
end
end
local o=RandomTableWithSeed(n,e[6])
for e=1,#o do
o[e]:AddBuff(t.CurrHeroCtrl,a,d,h)
end
if t.CurrHeroCtrl:IsUseSkillByRoundAndSkillType(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound,EBattleSkillType.SkillBig)==false then
e[28]=1
if(e[26]>=RandomMgr:GetBattleRandom())then
return true,e[27]
end
end
return false
end
return l

