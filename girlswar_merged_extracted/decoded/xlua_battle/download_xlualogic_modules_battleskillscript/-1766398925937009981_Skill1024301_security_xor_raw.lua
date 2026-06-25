local h=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eFront)
if(o==nil)then
return nil
end
e:ReduceFury(i.costMp)
local d=t[1]
local u=t[3]
local m=t[4]
local c=t[7]
local r=t[8]
local l=t[9]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local a=0
local n=e.HeroBattleInfo:GetAttrValue(HeroAttrId.injure)
local s=require("Modules/Battle/Formula")
local s=#o
for i=1,s do
local i=o[i]
local o=i.HeroBattleInfo:GetAttrValue(HeroAttrId.injure)
if o<=0 then
o=n
end
a=a+o*t[5]*MillionCoe
i:CheckAddBuff(c,e,r,l,0)
end
a=math.min(a,n*t[6]*MillionCoe)
local t=h.ChangeBattleAttr(HeroAttrId.injure,HeroAttrId.injureRateAdd,a)
local t={t}
e:AddBuff(e,u,m,t)
for t=1,s do
local t=o[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,d)
end
return nil
end
return l 
