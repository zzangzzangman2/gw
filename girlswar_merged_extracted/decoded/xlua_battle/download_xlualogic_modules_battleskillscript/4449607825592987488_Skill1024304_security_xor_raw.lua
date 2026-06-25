local d=require("Modules/Battle/BattleUtil")
local e={
}
local f=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i={}
table.insert(i,a)
t:ReduceFury(s.costMp)
local m=e[1]
local c=e[3]
local w=e[4]
local f=e[7]
local y=e[8]
local p=e[11]
local v=e[12]
local u=e[13]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
local a=0
local r=t.HeroBattleInfo:GetAttrValue(HeroAttrId.injure)
local o=0
local l=t.HeroBattleInfo:GetAttrValue(HeroAttrId.injureRes)
local n=require("Modules/Battle/Formula")
local h=#i
for n=1,h do
local i=i[n]
local n=i.HeroBattleInfo:GetAttrValue(HeroAttrId.injure)
if n<=0 then
n=r
end
a=a+n*e[5]*MillionCoe
local a=i.HeroBattleInfo:GetAttrValue(HeroAttrId.injureRes)
if a<=0 then
a=l
end
o=o+a*e[5]*MillionCoe
i:CheckAddBuff(p,t,v,u,0)
end
a=math.min(a,r*e[6]*MillionCoe)
local a=d.ChangeBattleAttr(HeroAttrId.injure,HeroAttrId.injureRateAdd,a)
local a={a}
t:AddBuff(t,c,w,a)
o=math.min(o,l*e[6]*MillionCoe)
local e=d.ChangeBattleAttr(HeroAttrId.injureRes,HeroAttrId.injureResRateAdd,o)
local e={e}
t:AddBuff(t,f,y,e)
for e=1,h do
local e=i[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,s,m)
end
return nil
end
return f 
