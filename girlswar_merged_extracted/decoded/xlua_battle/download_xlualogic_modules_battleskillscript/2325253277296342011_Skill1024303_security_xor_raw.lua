local h=require("Modules/Battle/BattleUtil")
local e={
}
local w=e
function e.DoAction(t,r)
local e=t:JudgeSkillPreView(r)
if t:CurrHPPer()<e[16]*MillionCoe then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[17])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return nil
end
t:ReduceFury(r.costMp)
local f=e[1]
local c=e[3]
local m=e[4]
local w=e[7]
local p=e[8]
local n=e[11]
local y=e[12]
local v=e[13]
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local o=h:GetTeamSoulCategoryCount(o)
if o<e[14]then
n=n*(1+e[15]*MillionCoe)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=0
local l=t.HeroBattleInfo:GetAttrValue(HeroAttrId.injure)
local i=0
local d=t.HeroBattleInfo:GetAttrValue(HeroAttrId.injureRes)
local s=require("Modules/Battle/Formula")
local u=#a
for s=1,u do
local a=a[s]
local s=a.HeroBattleInfo:GetAttrValue(HeroAttrId.injure)
if s<=0 then
s=l
end
o=o+s*e[5]*MillionCoe
local o=a.HeroBattleInfo:GetAttrValue(HeroAttrId.injureRes)
if o<=0 then
o=d
end
i=i+o*e[5]*MillionCoe
a:CheckAddBuff(n,t,y,v,0)
end
o=math.min(o,l*e[6]*MillionCoe)
local o=h.ChangeBattleAttr(HeroAttrId.injure,HeroAttrId.injureRateAdd,o)
local o={o}
t:AddBuff(t,c,m,o)
i=math.min(i,d*e[6]*MillionCoe)
local e=h.ChangeBattleAttr(HeroAttrId.injureRes,HeroAttrId.injureResRateAdd,i)
local e={e}
t:AddBuff(t,w,p,e)
for e=1,u do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,r,f)
end
return nil
end
return w 
