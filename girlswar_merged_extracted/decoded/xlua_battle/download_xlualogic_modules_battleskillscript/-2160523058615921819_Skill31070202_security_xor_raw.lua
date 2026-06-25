local h=require("Modules/Battle/BattleUtil")
local r=require('Modules/BattleBuffScript/BuffPairTools')
local e={}
local l=e
function e.DoAction(t,n,a,e)
local e=t:JudgeSkillPreView(n)
local o=nil
if a then
if a.defHeroIds then
for e=1,#a.defHeroIds do
local e=a.defHeroIds[e]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
break
end
end
end
end
if o==nil then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
end
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local m=e[1]
local d=e[3]
local l=e[4]
local u=e[5]
local i=303107025
local a=t.HeroBattleInfo:GetBuff(i)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
d=e.DoBeansActionSmallSkill(a)
end
local s=e[6]
local i=e[7]
local a={e[8],e[9]}
local c=e[10]
t:AddBuffWithMaxFloor(t,s,i,a,1,c)
local a=e[11]
local i=e[12]
local c={e[13],e[14]}
local s=e[15]
t:AddBuffWithMaxFloor(t,a,i,c,1,s)
local i=303107012
local a=nil
local s=t.HeroBattleInfo:GetBuff(i)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
a=e.GetSkyChild(s)
end
if a then
local o=a.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*e[16]*MillionCoe)
h:HpHealthWithSmallSkillAndParam(t,n.skilltype,o,a)
a:AddFuryWithSkill(e[17])
end
local i=t.HeroBattleInfo:GetMaxHP()
local i=math.floor(i*e[18]*MillionCoe)
h:HpHealthWithSmallSkillAndParam(t,n.skilltype,i)
t:AddFuryWithSkill(e[19])
if a then
if a.HeroId~=t.HeroId then
local s=t.HeroId
local i={}
i.buffId=e[20]
i.buffRound=e[21]
i.buffValue={}
local o={}
o.buffId=e[22]
o.buffRound=e[23]
o.buffValue={}
local n={}
n.buffId=e[24]
n.buffRound=e[25]
local t=r.GetDefaultHpChainData()
t.assumedamagePercent=e[26]
t.reduceDamagePercent=e[27]
t.minHpPercent=e[29]
t.defAddfury=e[28]
t.defHeroId=s
t.defBuffId=o.buffId
n.buffValue={t}
r.AddBuffPair(a,i,n,o,s)
else
if t:IsUseSkillByRoundAndSkillType(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound,EBattleSkillType.SkillBig)==false then
local a=e[30]
local o=e[31]
local e=0
t:AddBuff(t,a,o,e)
end
end
end
local e=#o
for e=1,e do
local e=o[e]
e:CheckAddBuff(d,t,l,u,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,m)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

