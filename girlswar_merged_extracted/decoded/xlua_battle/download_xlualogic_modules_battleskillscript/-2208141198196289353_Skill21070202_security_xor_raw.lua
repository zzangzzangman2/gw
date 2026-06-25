local s=require("Modules/Battle/BattleUtil")
local r=require('Modules/BattleBuffScript/BuffPairTools')
local e={}
local d=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(i==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local d=e[1]
local l=e[3]
local m=e[4]
local u=e[5]
local c=e[6]
local o=e[7]
local a={e[8],e[9]}
local h=e[10]
t:AddBuffWithMaxFloor(t,c,o,a,1,h)
local h=e[11]
local a=e[12]
local o={e[13],e[14]}
local c=e[15]
t:AddBuffWithMaxFloor(t,h,a,o,1,c)
local h=302107012
local a=nil
local o=t.HeroBattleInfo:GetBuff(h)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
a=e.GetSkyChild(o)
end
if a then
local o=a.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*e[16]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,n.skilltype,o,a)
a:AddFuryWithSkill(e[17])
end
local o=t.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*e[18]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,n.skilltype,o)
t:AddFuryWithSkill(e[19])
if a then
if a.HeroId~=t.HeroId then
local s=t.HeroId
local n={}
n.buffId=e[20]
n.buffRound=e[21]
n.buffValue={}
local o={}
o.buffId=e[22]
o.buffRound=e[23]
o.buffValue={}
local i={}
i.buffId=e[24]
i.buffRound=e[25]
local t=r.GetDefaultHpChainData()
t.assumedamagePercent=e[26]
t.reduceDamagePercent=e[27]
t.minHpPercent=e[29]
t.defAddfury=e[28]
t.defHeroId=s
t.defBuffId=o.buffId
i.buffValue={t}
r.AddBuffPair(a,n,i,o,s)
else
if t:IsUseSkillByRoundAndSkillType(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound,EBattleSkillType.SkillBig)==false then
local a=e[30]
local e=e[31]
local o=0
t:AddBuff(t,a,e,o)
end
end
end
local e=#i
for e=1,e do
local e=i[e]
e:CheckAddBuff(l,t,m,u,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,d)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

